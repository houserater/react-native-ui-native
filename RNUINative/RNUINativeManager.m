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

+ (instancetype)sharedUIBridge;
+ (RCTBridge *)bridge;

@end

@implementation RNUINativeManager

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

+ (RCTBridge *)bridge {
    id appDelegate = [UIApplication sharedApplication].delegate;
    return [appDelegate valueForKey:@"bridge"];
}

+ (instancetype)sharedUIBridge {
    RCTBridge *bridge = [self bridge];
    return [bridge moduleForClass:RNUINativeManager.class];
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"RNUINative-UIEvent"];
}

+ (void)loadDataWithHandler:(NSString * _Nonnull)handler completionBlock:(RNUINativeDataCallback)callbackBlock {
    void (^invokeLoadData)(RNUINativeManager *) = ^(RNUINativeManager *manager) {
        manager.loadDataCallback = callbackBlock;
        [manager.bridge enqueueJSCall:@"RNUINative" method:@"loadData" args:@[handler] completion:NULL];
    };
    
    RCTBridge *bridge = [self bridge];
    
    if (bridge.isLoading) {
        [[NSNotificationCenter defaultCenter] addObserverForName:RCTJavaScriptDidLoadNotification object:bridge queue:nil usingBlock:^(NSNotification *note) {
            invokeLoadData([self sharedUIBridge]);
        }];
    } else {
        invokeLoadData([self sharedUIBridge]);
    }
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
        data = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadDataCallback(data, err);
    });
}

@end
