//
//  RNUINativeManager.m
//  RNUINative
//
//  Created by Hank Brekke on 10/25/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import "RNUINativeManager.h"

@implementation RNUINativeManager

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

+ (instancetype)sharedUIBridge {
    id appDelegate = [UIApplication sharedApplication].delegate;
    RCTBridge *bridge = [appDelegate valueForKey:@"bridge"];
    return [bridge moduleForClass:RNUINativeManager.class];
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"RNUINative-BridgeEvent"];
}

- (void)loadDataWithHandler:(NSString * _Nonnull)handler completionBlock:(callback)callbackBlock {
    callbackBlock(nil, nil);
}

@end
