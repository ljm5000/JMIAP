//
//  main.m
//  jm-iap
//
//  Created by jimmy on 2020/7/14.
//  Copyright © 2020 com.jimmy.test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <string.h>

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
