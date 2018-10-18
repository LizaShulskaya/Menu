//
//  MenuViewController.h
//  Menu
//
//  Created by lizaveta shulskaya on 19.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, NSCoding>

@property(strong,nonatomic) NSString *navTitle;
@property(assign,nonatomic) int restId;
@property(strong,nonatomic)UITableView *menuTableView;


@end



