//
//  AppDelegate.m
//  jm-iap
//
//  Created by jimmy on 2020/7/14.
//  Copyright © 2020 com.jimmy.test. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@property (nonatomic,strong) UIWindow * windows;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
   self.windows = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
      self.windows.rootViewController = [[ViewController alloc] init];
      [self.windows makeKeyAndVisible];
      self.windows.backgroundColor = [UIColor whiteColor];
    
    return YES;
}


@end
