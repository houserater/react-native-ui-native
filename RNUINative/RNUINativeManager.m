//
//  RNUINativeManager.m
//  RNUINative
//
//  Created by Hank Brekke on 10/25/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import "RNUINativeManager.h"

@interface RNUINativeManager ()

@property (nonatomic, copy) RNUINativeDataCallback loadDataCallback;
@property (nonatomic, strong) NSMutableArray *eventListeners;

+ (void)runWhenReady:(void(^)(RNUINativeManager *))block;

@end

@implementation RNUINativeManager

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventListeners = [NSMutableArray array];
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"RNUINative-UIEvent"];
}

+ (void)runWhenReady:(void (^)(RNUINativeManager *))block {
    id appDelegate = [UIApplication sharedApplication].delegate;
    RCTBridge *bridge = [appDelegate valueForKey:@"bridge"];
    
    if (bridge.isLoading) {
        [[NSNotificationCenter defaultCenter] addObserverForName:RCTJavaScriptDidLoadNotification object:bridge queue:nil usingBlock:^(NSNotification *note) {
            block([bridge moduleForClass:RNUINativeManager.class]);
        }];
    } else {
        block([bridge moduleForClass:RNUINativeManager.class]);
    }
}

+ (void)loadDataWithHandler:(NSString * _Nonnull)handler completionBlock:(RNUINativeDataCallback)callbackBlock {
    [self runWhenReady:^(RNUINativeManager *manager) {
        manager.loadDataCallback = callbackBlock;
        [manager.bridge enqueueJSCall:@"RNUINative" method:@"loadData" args:@[handler] completion:NULL];
    }];
}

+ (void)addEventListener:(NSString *)handler eventBlock:(RNUINativeEventCallback)eventBlock withController:(id)sender {
    [self runWhenReady:^(RNUINativeManager *manager) {
        NSMapTable *listener = [NSMapTable strongToStrongObjectsMapTable];
        [listener setObject:eventBlock forKey:@"block"];
        [listener setObject:handler forKey:@"event"];
        
        NSMapTable *controller = [NSMapTable strongToWeakObjectsMapTable];
        [controller setObject:sender forKey:@"sender"];
        
        [listener setObject:controller forKey:@"controller"];
        
        [manager.eventListeners addObject:listener];
    }];
}

RCT_EXPORT_METHOD(loadDataComplete:(NSString *)response error:(NSString *)errorString) {
    NSError *err = nil;
    if (errorString) {
        err = [NSError errorWithDomain:@"RNUINativeError" code:1 userInfo:@{
            NSLocalizedDescriptionKey: errorString
        }];
    }
    id data = nil;
    if (response) {
        data = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadDataCallback(data, err);
        self.loadDataCallback = nil;
    });
}

RCT_EXPORT_METHOD(emitEvent:(NSString *)event withEventData:(NSString *)eventData) {
    [self.eventListeners filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSMapTable *listener, NSDictionary *bindings) {
        // Remove any objects which have been `-[dealloc]`d
        return ([[listener objectForKey:@"controller"] objectForKey:@"sender"] != nil);
    }]];
    
    NSArray *validEvents = [self.eventListeners filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSMapTable *listener, NSDictionary *bindings) {
        return [(NSString *)[listener objectForKey:@"event"] isEqual:event];
    }]];
    
    if (validEvents.count == 0) {
        return;
    }
    
    NSError *err = nil;
    id data = nil;
    if (eventData) {
        data = [NSJSONSerialization JSONObjectWithData:[eventData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [validEvents enumerateObjectsUsingBlock:^(NSMapTable *listener, NSUInteger idx, BOOL *stop) {
            RNUINativeEventCallback handler = [listener objectForKey:@"block"];
            handler(data);
        }];
    });
}

@end
