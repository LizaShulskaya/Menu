//
//  AppDelegate.m
//  Menu
//
//  Created by lizaveta shulskaya on 18.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "RestaurantsViewController.h"
#import "FavoritesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect frame = UIScreen.mainScreen.bounds;
    UIWindow *window = [[UIWindow alloc] initWithFrame:frame];
    
    UINavigationController *restNavController = [[UINavigationController alloc] init];
    RestaurantsViewController *restViewController = [[RestaurantsViewController alloc] init];
    [restViewController setTabBarItem:[[[UITabBarItem alloc] initWithTitle:@"Resraurants" image:[UIImage imageNamed:@"restaurants-icon"] tag:0] autorelease]];
    restNavController.viewControllers = [NSArray arrayWithObjects:restViewController, nil];
    
    [restNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1Res"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    UINavigationController *favNavController = [[UINavigationController alloc] init];
    FavoritesViewController *favViewController = [[FavoritesViewController alloc] init];
    [favViewController setTabBarItem:[[[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage imageNamed:@"star"] tag:1] autorelease]];
    favNavController.viewControllers = [NSArray arrayWithObjects:favViewController, nil];
    
    [favNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2Fav"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[restNavController, favNavController];
    
    
    window.rootViewController = tabBarController;
    
    
    _window = window;
    [window makeKeyAndVisible];
    
    [restViewController release];
    [favViewController release];
    [restNavController release];
    [favNavController release];
    [tabBarController release];
    return YES;
}


-(void)dealloc{
    [_window release];
    [super dealloc];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
