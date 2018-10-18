//
//  MenuViewController.m
//  Menu
//
//  Created by lizaveta shulskaya on 19.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import "MenuViewController.h"
#import "FavoritesViewController.h"
#import "DBManager.h"
#import "ItemViewController.h"
#import <AVFoundation/AVFoundation.h>

NSString *const PATH_FOR_DB = @"default_data_base.db";
NSString *const TABLE_MENU_CELL = @"Cell";
NSString *const ADD_TO_FAV = @"+";
NSString *const SOUND_FILE = @"Fav";
NSString *const SOUND_TYPE = @"wav";
NSString *const MEAL_NAME = @"name";
NSString *const MEAL_ID = @"id";
NSString *const KEY_FOR_FAVORITE = @"favorite";

@interface MenuViewController ()

{
    NSArray *dataSource;
    DBManager *dbManager;
    NSArray *meals;
    FavoritesViewController *favViewController;
}


@end


@implementation MenuViewController

-(UITableView*)menuTableView
{
    if(!_menuTableView)
    {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _menuTableView;
}


- (id)init
{
    if (self = [super init])
    {
        favViewController = [[FavoritesViewController alloc] init];
    }
    return self;
}


#pragma mark - Life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.navTitle;
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    dbManager = [[DBManager alloc] initWithFileName:PATH_FOR_DB];
    [self.menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TABLE_MENU_CELL];
    [self.view addSubview:self.menuTableView];
    [self setConstraints];
    [self loadData];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:ADD_TO_FAV style:UIBarButtonItemStyleDone target:self action:@selector(addToFav:)];
    [[self navigationItem] setRightBarButtonItem:rightButtonItem];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [_navTitle release];
    [_menuTableView release];
    [super dealloc];
}


#pragma mark - Button add to favorites

- (void)addToFav:(UIBarButtonItem *)sender
{
    NSArray *defaults = [NSUserDefaults.standardUserDefaults objectForKey:KEY_FOR_FAVORITE];
    NSMutableArray *favorites = [NSMutableArray arrayWithArray:defaults];
    NSArray *addedRest = [dbManager loadDataFromDBForFavItem:self.restId];
    if(![defaults containsObject:addedRest[0]])
    {
        [favorites addObjectsFromArray:addedRest];
        NSUserDefaults *saved = [NSUserDefaults standardUserDefaults];
        [saved setObject:favorites forKey:KEY_FOR_FAVORITE];
        [saved synchronize];
    }
    SystemSoundID soundID;
    NSString *path = [[NSBundle mainBundle] pathForResource:SOUND_FILE ofType:SOUND_TYPE];
    NSURL *pathURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((CFURLRef)pathURL, &soundID);
    AudioServicesPlaySystemSound(soundID);
}


#pragma mark - Data

- (void)loadData
{
    if(meals != nil)
    {
        meals = nil;
    }
    meals = [[NSArray alloc] initWithArray:[dbManager loadDataFromDBForMenuVC:self.restId]];
    [self.menuTableView reloadData];
}


#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return meals.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_MENU_CELL forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLE_MENU_CELL];
        [cell autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSInteger mealIndex = [dbManager.arrColumnNames indexOfObject:MEAL_NAME];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[meals objectAtIndex:indexPath.row] objectAtIndex:mealIndex]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemViewController *vc = [[ItemViewController alloc] init];
    [vc autorelease];
    [self.navigationController pushViewController:vc animated:NO];
    NSInteger mealIndex = [dbManager.arrColumnNames indexOfObject:MEAL_NAME];
    NSString *titleForItem = [NSString stringWithFormat:@"%@",[[meals objectAtIndex:indexPath.row] objectAtIndex:mealIndex]];
    vc.navTitle = titleForItem;
    NSInteger idIndex = [dbManager.arrColumnNames indexOfObject:MEAL_ID];
    NSString *idMeal = [NSString stringWithFormat:@"%@",[[meals objectAtIndex:indexPath.row] objectAtIndex:idIndex]];
    NSInteger intValueIdMeal = [idMeal integerValue];
    vc.mealId = (int)intValueIdMeal;
}


#pragma mark - Constrains for table

- (void)setConstraints
{
    self.menuTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.menuTableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.menuTableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.menuTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.menuTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
}


@end
