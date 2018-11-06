//
//  AppDelegate.h
//  SplitViewTest
//
//  Created by Hank Brekke on 11/5/18.
//  Copyright © 2018 HouseRater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) RCTBridge *bridge;

@end
