//
//  RestaurantsViewController.m
//  Menu
//
//  Created by lizaveta shulskaya on 18.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "DBManager.h"
#import "MenuViewController.h"
#import "NSMutableAttributedString+Color.h"

NSString *const DATA_BASE_FILE = @"default_data_base.db";
NSString *const CELL = @"Cell";
NSString *const ID = @"id";
NSString *const NAME = @"name";
NSString *const LOGO_FILE_PATH = @"file_path";
NSString *const TITLE = @"Restaurants";
NSString *const HEADER = @"Choose a restaurant";

@interface RestaurantsViewController ()
{
    DBManager* dbManager;
    NSArray *rests;
    UISearchBar *search;
    NSMutableArray *searchArray;
    BOOL isSearching;
}

@property(strong,nonatomic)UITableView *restTableView;


@end


@implementation RestaurantsViewController

-(UITableView*)restTableView
{
    if(!_restTableView)
    {
        _restTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _restTableView;
}


#pragma mark - Life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = TITLE;
    self.restTableView.delegate = self;
    self.restTableView.dataSource = self;
    dbManager = [[DBManager alloc] initWithFileName:DATA_BASE_FILE];
    [self.restTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL];
    [self.view addSubview:self.restTableView];
    [self setConstraints];
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(1, 0, self.view.bounds.size.width, 50)];
    [self.restTableView setTableHeaderView:search];
    search.delegate = self;
    [self loadData];
}


- (void)dealloc
{
    [_restTableView release];
    [super dealloc];
}


#pragma mark - Data

- (void)loadData
{
    if(rests != nil)
    {
        rests = nil;
    }
    rests = [[NSArray alloc] initWithArray:[dbManager loadDataFromDBForRestaurantVC]];
    [self.restTableView reloadData];
}


- (void)searchTableList
{
    searchArray = [[NSMutableArray alloc] init];
    NSString *searchString = search.text;
    NSInteger nameIndex = [dbManager.arrColumnNames indexOfObject:NAME];
    for (int i = 0; i < rests.count; i++)
    {
        if([rests[i][nameIndex] rangeOfString:searchString].location !=NSNotFound)
        {
            [searchArray addObject:rests[i]];
        }
    }
}


#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearching)
    {
        return searchArray.count;
    }
    else
    {
        return rests.count;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return HEADER;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL];
        [cell autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSInteger nameIndex = [dbManager.arrColumnNames indexOfObject:NAME];
    NSInteger logoIndex = [dbManager.arrColumnNames indexOfObject:LOGO_FILE_PATH];
    if (isSearching)
    {
        NSString *strColor = [NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] objectAtIndex:nameIndex]];
        NSString *strName=search.text;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strColor];
        [string setColorForText:strName withColor:[UIColor redColor]];
        cell.textLabel.attributedText = string;
        NSString *filePath = [NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] objectAtIndex:logoIndex]];
        cell.imageView.image = [UIImage imageNamed:filePath];
        [string release];
    }
    else
    {
        NSString *strColor = [NSString stringWithFormat:@"%@",[[rests objectAtIndex:indexPath.row] objectAtIndex:nameIndex]];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strColor];
        cell.textLabel.attributedText = string;
        NSString *filePath = [NSString stringWithFormat:@"%@",[[rests objectAtIndex:indexPath.row] objectAtIndex:logoIndex]];
        cell.imageView.image = [UIImage imageNamed:filePath];
        [string release];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuViewController *vc = [[MenuViewController alloc] init];
    [vc autorelease];
    [self.navigationController pushViewController:vc animated:NO];
    NSInteger nameIndex = [dbManager.arrColumnNames indexOfObject:NAME];
    NSInteger restIdDB = [dbManager.arrColumnNames indexOfObject:ID];
    if (isSearching)
    {
        NSString *restId = [NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] objectAtIndex:restIdDB]];
        NSString *titleForMenu = [NSString stringWithFormat:@"%@",[[searchArray objectAtIndex:indexPath.row] objectAtIndex:nameIndex]];
        vc.navTitle = titleForMenu;
        NSInteger intValueRestId = [restId integerValue];
        vc.restId = (int)intValueRestId;
    }
    else
    {
        NSString *restId = [NSString stringWithFormat:@"%@",[[rests objectAtIndex:indexPath.row] objectAtIndex:restIdDB]];
        NSString *titleForMenu = [NSString stringWithFormat:@"%@",[[rests objectAtIndex:indexPath.row] objectAtIndex:nameIndex]];
        vc.navTitle = titleForMenu;
        NSInteger intValueRestId = [restId integerValue];
        vc.restId = (int)intValueRestId;
    }
}


#pragma mark - Constrains for table

- (void)setConstraints
{
    self.restTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.restTableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.restTableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.restTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.restTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
}


#pragma mark - Search bar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [searchArray removeAllObjects];
    if(searchText.length != 0)
    {
        isSearching = YES;
        [self searchTableList];
    }
    else
    {
        isSearching = NO;
    }
    [self.restTableView reloadData];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [search resignFirstResponder];
    [self searchTableList];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}


@end
