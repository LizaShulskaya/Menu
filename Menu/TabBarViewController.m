//
//  TabBarViewController.m
//  Menu
//
//  Created by lizaveta shulskaya on 18.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import "TabBarViewController.h"
#import "RestaurantsViewController.h"
#import "FavoritesViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*RestaurantsViewController *firstVC = [[RestaurantsViewController alloc] init];
    [firstVC setTabBarItem:[[[UITabBarItem alloc] initWithTitle:@"Resraurants" image:[UIImage imageNamed:@"restaurants-icon"] tag:0] autorelease]];
    
    FavoritesViewController *secondVC = [[FavoritesViewController alloc] init];
    [secondVC setTabBarItem:[[[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage imageNamed:@"restaurants-icon"] tag:1] autorelease]];
    
    [self setViewControllers:[NSArray arrayWithObjects:firstVC, secondVC, nil]];*/
    
    
    //[firstVC release];
    //[secondVC release];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
