//
//  DBManager.h
//  Menu
//
//  Created by lizaveta shulskaya on 19.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

@property(strong,nonatomic) NSMutableArray *arrColumnNames;

- (instancetype)initWithFileName:(NSString*) dbFileName;
- (void)runQuery:(const char*)query isQueryExecutable:(BOOL)queryExecutable;
- (NSArray*)loadDataFromDB: (NSString*)query;
- (void)executeQuery:(NSString*)query;
- (NSArray*)loadDataFromDBForRestaurantVC;
- (NSArray*)loadDataFromDBForMenuVC:(int)restaurantId;
- (NSArray*)loadDataFromDBForItemVC:(int)mealId;
- (NSMutableArray*)loadDataFromDBMut:(NSString *)query;
- (NSArray*)loadDataFromDBForFavItem:(int)restId;


@end
