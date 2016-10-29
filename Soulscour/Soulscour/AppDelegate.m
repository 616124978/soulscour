//
//  AppDelegate.m
//  Soulscour
//
//  Created by lanou on 16/10/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "AppDelegate.h"
#import "PoeViewController.h"
#import "OtherViewController.h"
#import "BeaViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

-(UIViewController *)createVCWithClass:(Class)class
                                 title:(NSString *)title
                           normalImage:(NSString *)normalImage
                         selectedImage:(NSString *)selectedImage
{
    UIViewController *VC=[[class alloc] init];
    UIImage *norImage=[UIImage imageNamed:normalImage];
    norImage=[norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selImage=[UIImage imageNamed:selectedImage];
    selImage=[selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    VC.tabBarItem=[[UITabBarItem alloc] initWithTitle:title image:norImage selectedImage:selImage];
    
    return VC;
}

-(UITabBarController *)createTabbarController
{
    PoeViewController *poeVC=(PoeViewController *)[self createVCWithClass:[PoeViewController class] title:@"诗歌" normalImage:@"poe.png" selectedImage:@"poe1.png"];
    UINavigationController *poeNav=[[UINavigationController alloc] initWithRootViewController:poeVC];
    
    OtherViewController *otherVC = (OtherViewController *)[self createVCWithClass:[OtherViewController class] title:@"其他" normalImage:@"未收藏.png" selectedImage:@"已收藏.png"];
    UINavigationController *otherNav=[[UINavigationController alloc] initWithRootViewController:otherVC];
    //美图美文
    BeaViewController *beaVC=(BeaViewController *)[self createVCWithClass:[BeaViewController class] title:@"美图文" normalImage:@"书本.png" selectedImage:@"书本2.png"];
    UINavigationController *beaNav=[[UINavigationController alloc]initWithRootViewController:beaVC];
    
    UITabBarController *tabbarVC=[[UITabBarController alloc] init];
    
    tabbarVC.viewControllers=@[beaNav,poeNav,otherNav];
    
    tabbarVC.selectedIndex=0;
    
    tabbarVC.tabBar.translucent=NO;
    
    return tabbarVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [self createTabbarController];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.389 green:0.603 blue:1.000 alpha:1.000]];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.950 green:0.945 blue:1.000 alpha:1.000]];
    
    [[UITabBar appearance] setTranslucent:NO];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
