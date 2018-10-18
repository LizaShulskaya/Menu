//
//  ItemViewController.h
//  Menu
//
//  Created by lizaveta shulskaya on 19.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic) NSString *navTitle;
@property(assign,nonatomic) int mealId;
@property(strong,nonatomic)UITableView *itemTableView;


@end
