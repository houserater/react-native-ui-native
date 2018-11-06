//
//  RNUINJSEventButtonViewController.h
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/5/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RNUINExampleViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RNUINJSEventButtonViewController : UIViewController <RNUINExampleControllerDelegate>

@property (nonatomic, strong) NSDictionary *example;

@end

NS_ASSUME_NONNULL_END
