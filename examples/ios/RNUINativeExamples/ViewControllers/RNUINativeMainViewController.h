//
//  RNUINativeMainViewController.h
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/4/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNUINativeMainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *jsView;

- (IBAction)loadJSDataTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END
