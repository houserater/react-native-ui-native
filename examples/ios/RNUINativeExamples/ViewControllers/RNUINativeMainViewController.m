//
//  RNUINativeMainViewController.m
//  RNUINativeExamples
//
//  Created by Hank Brekke on 11/4/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import <React/RCTRootView.h>
#import <RNUINative/RNUINativeManager.h>

#import "RNUINativeMainViewController.h"
#import "AppDelegate.h"

@interface RNUINativeMainViewController ()

@end

@implementation RNUINativeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  [RNUINativeManager addEventListener:@"ExampleController.buttonTapped" eventBlock:^(NSDictionary *data) {
    NSString *messageData = [NSString stringWithFormat:@"JS time: %@", [data objectForKey:@"time"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Event Emitted"
                                                                   message:messageData
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
  } sender:self];
  
  AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:delegate.bridge
                                                   moduleName:@"RNUINativeExamples"
                                            initialProperties:nil];
  rootView.frame = CGRectMake(0, 0, self.jsView.frame.size.width, self.jsView.frame.size.height);
  rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.jsView addSubview:rootView];
}

- (IBAction)loadJSDataTapped:(id)sender {
  [RNUINativeManager loadDataWithHandler:@"ExampleController.loadDocuments()" completionBlock:^(NSArray *data, NSError *error) {
    NSString *messageData = error ? error.localizedDescription : [NSString stringWithFormat:@"JS random: %@", [[data objectAtIndex:0] objectForKey:@"random"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Data Loaded"
                                                                   message:messageData
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
  }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
