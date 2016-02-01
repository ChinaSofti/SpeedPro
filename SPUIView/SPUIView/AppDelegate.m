//
//  SVTestingCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "AppDelegate.h"
#import "SVTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //    NSLog(@"%f", [UIScreen mainScreen].scale);
    //    NSLog(@"%@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    //统一设置navigationController.navigationBar.barTintColor为黑色
//    [[UINavigationBar appearance]
//     setBarTintColor:[UIColor colorWithRed:53/255 green:65/255 blue:74/255 alpha:1]];
    [[UINavigationBar appearance]setBarTintColor:RGBACOLOR(37, 55, 64, 1)];
//    [UIColor colorWithRed:229 / 255.0 green:2 / 255.0 blue:229 / 255.0 alpha:1.0];
    // 1.初始化一个window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 2.设置根控制器
    self.window.rootViewController = [SVTabBarController new];
    // 3.让显示并成为主窗口
    [self.window makeKeyAndVisible];
    return YES;
    
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

@end
