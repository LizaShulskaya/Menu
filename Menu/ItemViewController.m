//
//  ItemViewController.m
//  Menu
//
//  Created by lizaveta shulskaya on 19.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import "ItemViewController.h"
#import "DBManager.h"

NSString *const DATA_BASE_FILE_NAME = @"default_data_base.db";
NSString *const ITEM_TABLE_CELL = @"Cell";

@interface ItemViewController ()
{
    NSArray *dataSource;
    DBManager* dbManager;
    NSArray *characteristics;
    NSArray *lableTitles;
}


@end


@implementation ItemViewController

- (UITableView*)itemTableView
{
    if(!_itemTableView)
    {
        _itemTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _itemTableView;
}


#pragma mark - Life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.navTitle;
    self.itemTableView.delegate = self;
    self.itemTableView.dataSource = self;
    dbManager = [[DBManager alloc] initWithFileName:DATA_BASE_FILE_NAME];
    [self.itemTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ITEM_TABLE_CELL];
    [self.view addSubview:self.itemTableView];
    [self setConstraints];
    [self loadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [_navTitle release];
    [_itemTableView release];
    [super dealloc];
}


#pragma mark - Data

- (void)loadData
{
    NSArray *titles = @[@"Serving", @"Calories",@"Total fat", @"Saturated fat", @"Trans fats", @"Cholesterol", @"Sodium", @"Carbonates"];
    lableTitles = [[NSArray alloc] initWithArray:titles];
    
    if(characteristics != nil)
    {
        characteristics = nil;
    }
    characteristics = [[NSArray alloc] initWithArray:[dbManager loadDataFromDBForItemVC:self.mealId]];
    [self.itemTableView reloadData];
}


#pragma mark - Table iew delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lableTitles.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ITEM_TABLE_CELL forIndexPath:indexPath];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ITEM_TABLE_CELL];
    [cell autorelease];
    cell.textLabel.text = lableTitles[indexPath.row];
    cell.detailTextLabel.text = characteristics[0][indexPath.row];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}


#pragma mark - Constrains for table

- (void)setConstraints
{
    self.itemTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [self.itemTableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.itemTableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.itemTableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.itemTableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
}


@end
