//
//  RNUINativeManager.m
//  RNUINative
//
//  Created by Hank Brekke on 10/25/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>

#import "RNUINativeManager.h"

@interface RNUINativeManager ()

@property (nonatomic, strong) NSMutableArray *dataHandlers;
@property (nonatomic, strong) NSMutableArray *eventListeners;

+ (void)runWhenReady:(void(^)(RNUINativeManager *))block;

@end

@implementation RNUINativeManager
@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataHandlers = [NSMutableArray array];
        self.eventListeners = [NSMutableArray array];
    }
    return self;
}

+ (void)runWhenReady:(void (^)(RNUINativeManager *))block {
    // Note: right now we require `self.bridge` on AppDelegate for finding the bridge to JS
    // code. Ideally, applications can seed this project with their bridge at launch so we
    // don't need the assumption below.
    
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

+ (void)loadDataWithHandler:(NSString *)handler arguments:(NSArray *)arguments completionBlock:(RNUINativeDataCallback)callbackBlock {
    [self runWhenReady:^(RNUINativeManager *manager) {
        NSString *handlerId = [NSUUID UUID].UUIDString;
        if (callbackBlock) {
            NSMapTable *handler = [NSMapTable strongToStrongObjectsMapTable];
            [handler setObject:callbackBlock forKey:@"block"];
            [handler setObject:handlerId forKey:@"identifier"];
            
            [manager.dataHandlers addObject:handler];
        }
        NSArray *args = [@[handler, handlerId] arrayByAddingObjectsFromArray:arguments];
        [manager.bridge enqueueJSCall:@"RNUINative" method:@"loadData" args:args completion:NULL];
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

RCT_EXPORT_METHOD(loadDataComplete:(NSString *)response responseId:(NSString *)responseId error:(NSString *)errorString) {
    NSUInteger handlerIdx = [self.dataHandlers indexOfObjectPassingTest:^BOOL(NSMapTable *handler, NSUInteger idx, BOOL *stop) {
        NSString *handlerId = [handler objectForKey:@"identifier"];
        return ([handlerId isEqualToString:responseId]);
    }];
    
    if (handlerIdx == NSNotFound) {
        return;
    }
    
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
        NSMapTable *handler = [self.dataHandlers objectAtIndex:handlerIdx];
        [self.dataHandlers removeObjectAtIndex:handlerIdx];
        
        RNUINativeDataCallback callback = [handler objectForKey:@"block"];
        callback(data, err);
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
