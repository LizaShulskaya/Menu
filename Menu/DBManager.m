//
//  DBManager.m
//  Menu
//
//  Created by lizaveta shulskaya on 19.09.2018.
//  Copyright © 2018 lizaveta shulskaya. All rights reserved.
//

#import "DBManager.h"

@interface DBManager()
{
    NSString* documentsDirectory;
    NSString* databaseFileName;
    NSMutableArray* results;
    int affectedRows;
    long long lastInsertedRowID;
}

-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char*)query isQueryExecutable:(BOOL)queryExecutable;


@end


@implementation DBManager

- (instancetype) initWithFileName:(NSString *)dbFileName
{
    self = [super init];
    if(self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        databaseFileName = dbFileName;
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}


- (void) copyDatabaseIntoDocumentsDirectory
{
    NSString *destinationPath = [documentsDirectory stringByAppendingPathComponent:databaseFileName];
    if (![[NSFileManager defaultManager]  fileExistsAtPath:destinationPath])
    {
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseFileName];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    }
    
}


- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable
{
    sqlite3 *sqlite3DB;
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:databaseFileName];
    if(results != nil)
    {
        [results removeAllObjects];
        results = nil;
    }
    results = [[NSMutableArray alloc] init];
    if(self.arrColumnNames != nil)
    {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    BOOL openDataBaseResult = sqlite3_open([databasePath UTF8String], &sqlite3DB);
    if (openDataBaseResult == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement;  //declare that sqlite3_stmt object in which the query after having been compiled into SQLite statement will be stored
        //loading all data from database to memory
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3DB, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK)
        {
            if (!queryExecutable)
            {
                NSMutableArray *arrDataRow; //for keeping data for each fetched row
                while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    arrDataRow = [[NSMutableArray alloc] init];
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    for (int i=0; i<totalColumns; i++)
                    {
                        char *databaseDataAsChars = (char*) sqlite3_column_text(compiledStatement, i); //converting the column data to chars
                        if (databaseDataAsChars != NULL)
                        {
                            [arrDataRow addObject:[NSString stringWithUTF8String:databaseDataAsChars]];
                        }
                        if(self.arrColumnNames.count != totalColumns)
                        {
                            databaseDataAsChars = (char*)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:databaseDataAsChars]];
                        }
                    }
                    if(arrDataRow>0)
                    {
                        [results addObject:arrDataRow];
                    }
                }
            }
            else
            {
                int execQueryResults = sqlite3_step(compiledStatement);
                if (execQueryResults == SQLITE_DONE)
                {
                    affectedRows = sqlite3_changes(sqlite3DB);
                    lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3DB);
                }
                else
                {
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3DB));
                }
            }
        }
        else
        {
            NSLog(@"%s",sqlite3_errmsg(sqlite3DB));
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(sqlite3DB);
}


- (NSArray*)loadDataFromDB:(NSString *)query
{
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray*)results;
}

- (NSMutableArray*)loadDataFromDBMut:(NSString *)query
{
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSMutableArray*)results;
}



- (NSArray*)loadDataFromDBForRestaurantVC
{
    NSString *query = @"select res.id, res.name, logo.file_path from ch_restaurant res left join ch_restaurant_logo logo on res.id = logo.restaurant_id";
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray*)results;
}


- (NSArray*)loadDataFromDBForMenuVC:(int)restaurantId
{
    NSString *query = [NSString stringWithFormat:@"select * from ch_item where restaurant_id=%d", restaurantId];
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray*)results;
}


- (NSArray*)loadDataFromDBForItemVC:(int)mealId
{
    NSString *query = [NSString stringWithFormat:@"select coalesce(serving, 0), coalesce(calories, 0), coalesce(total_fat, 0), coalesce(saturated_fat,0),coalesce(trans_fats,0), coalesce(cholesterol, 0), coalesce(sodium,0), coalesce(carbs,0) from ch_item where id=%d", mealId];
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray*)results;
}


- (NSArray*)loadDataFromDBForFavItem:(int)restId
{
    NSString *query = [NSString stringWithFormat:@"select res.id, res.name, logo.file_path from ch_restaurant res left join ch_restaurant_logo logo on res.id = logo.restaurant_id where res.id=%d", restId];
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray*)results;
}


- (void)executeQuery:(NSString *)query{
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


@end
