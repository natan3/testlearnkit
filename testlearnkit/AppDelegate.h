//
//  AppDelegate.h
//  testlearnkit
//
//  Created by master on 2014/11/21.
//  Copyright (c) 2014年 naomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ViewController.h"
#import <IRKit/IRKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    ViewController *topcon;
    UINavigationController *navcon;
}

@property (strong, nonatomic) UIWindow *window;


@end

