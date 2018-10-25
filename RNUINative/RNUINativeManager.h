//
//  RNUINativeManager.h
//  RNUINative
//
//  Created by Hank Brekke on 10/25/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import <React/RCTEventEmitter.h>

typedef void (^RNUINativeDataCallback)(id data, NSError *error);

@interface RNUINativeManager : RCTEventEmitter

+ (void)loadDataWithHandler:(NSString * _Nonnull)handler completionBlock:(RNUINativeDataCallback)callbackBlock;

@end
