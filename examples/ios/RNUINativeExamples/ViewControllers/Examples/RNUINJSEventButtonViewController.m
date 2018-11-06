//
//  RNUINJSEventButtonViewController.m
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/5/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import "RNUINJSEventButtonViewController.h"
#import "AppDelegate.h"

#import <React/RCTRootView.h>
#import <RNUINative/RNUINativeManager.h>

@interface RNUINJSEventButtonViewController ()

@property (strong, nonatomic) RCTRootView *rootView;

@end

@implementation RNUINJSEventButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.rootView = [[RCTRootView alloc] initWithBridge:appDelegate.bridge
                                             moduleName:self.example[@"controller"]
                                      initialProperties:nil];
    self.rootView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.rootView];
    
    __weak RNUINJSEventButtonViewController *weakSelf = self;
    [RNUINativeManager addEventListener:@"JSEventButtonController.buttonTapped" eventBlock:^(NSDictionary *data) {
        NSString *message = [NSString stringWithFormat:@"Current JS time: %@", data[@"time"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Button Tapped" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    } withController:self];
}

@end
