//
//  FavoritesViewController.m
//  Menu
//
//  Created by lizaveta shulskaya on 18.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import "FavoritesViewController.h"
#import "DBManager.h"
#import "MenuViewController.h"

NSString *const DATA_BASE_PATH = @"default_data_base.db";
NSString *const COLUMN_NAME = @"name";
NSString *const TABLE_CELL = @"Cell";
NSString *const TITLE_FOR_FAVORITES_VC = @"Favorites";
NSString *const COLUMN_FILE_PATH = @"file_path";
NSString *const KEY = @"favorite";

@interface FavoritesViewController ()
{
    DBManager* dbManager;
    NSMutableArray *fav;
    NSArray *newFav;
}

@property(strong, nonatomic) UITableView *favTableView;


@end


@implementation FavoritesViewController

- (UITableView*)favTableView
{
    if(!_favTableView){
        _favTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _favTableView;
}


#pragma mark - Life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = TITLE_FOR_FAVORITES_VC;
    self.favTableView.delegate = self;
    self.favTableView.dataSource = self;
    dbManager = [[DBManager alloc] initWithFileName:DATA_BASE_PATH];
    [self.favTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TABLE_CELL];
    [self.view addSubview:self.favTableView];
    [self setConstraints];
    [self loadData];
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
    [_favTableView release];
    [super dealloc];
}


#pragma mark - Data

- (void)loadData
{
    NSUserDefaults *loader = [NSUserDefaults standardUserDefaults];
    fav = [loader objectForKey:KEY];
    [self.favTableView reloadData];
}


#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fav.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_CELL forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TABLE_CELL];
        [cell autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", fav[indexPath.row][1]];
    NSString *filePath = [NSString stringWithFormat:@"%@", fav[indexPath.row][2]];
    cell.imageView.image = [UIImage imageNamed:filePath];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuViewController *vc = [[MenuViewController alloc] init];
    [vc autorelease];
    [self.navigationController pushViewController:vc animated:NO];
    NSString *titleForMenu = [NSString stringWithFormat:@"%@", fav[0][1]];
    vc.navTitle = titleForMenu;
    vc.restId = [fav[0][0] intValue];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray *defaults = [NSUserDefaults.standardUserDefaults objectForKey:KEY];
        NSMutableArray *favorites = [NSMutableArray arrayWithArray:defaults];
        [favorites removeObject:fav[indexPath.row]];
        NSUserDefaults *saved = [NSUserDefaults standardUserDefaults];
        [saved setObject:favorites forKey:KEY];
        [self loadData];
    }
}


#pragma mark - Constrains for table

- (void)setConstraints
{
    self.favTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.favTableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.favTableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.favTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.favTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
}


@end
