//
//  AppDelegate.m
//  SplitViewTest
//
//  Created by Hank Brekke on 11/5/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import "AppDelegate.h"
#import "RNUINExampleViewController.h"

#import <React/RCTBundleURLProvider.h>

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *jsCodeLocation;

    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"examples/index.ios" fallbackResource:nil];
  
    self.bridge = [[RCTBridge alloc] initWithBundleURL:jsCodeLocation
                                        moduleProvider:nil
                                         launchOptions:launchOptions];

    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    return YES;
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]]
        && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[RNUINExampleViewController class]]
        && ([(RNUINExampleViewController *)[(UINavigationController *)secondaryViewController topViewController] example] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
