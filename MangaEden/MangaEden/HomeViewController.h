//
//  FirstViewController.h
//  MangaEden
//
//  Created by Cuccku on 8/24/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetrieveListOperation.h"
#import "SyncListOperation.h"
@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RetrieveListOperationDelegate, SyncListOperationDelegate>
{
    UITableView *tableViewListManga;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



@property (strong, nonatomic) NSFetchedResultsController *currentListFRC;
@property (strong, nonatomic) NSMutableArray *searchFilterAlls;


@property (strong, nonatomic) IBOutlet UITableView *tableViewListManga;
@property (strong, nonatomic) IBOutlet UITableViewCell *customCell;
@property (strong, nonatomic) IBOutlet UIProgressView *progessDownLoadListManga;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) NSOperationQueue *operationQueue;
-(void) loadAllARC;
-(void) fetch;
- (void) hideLoadingBar;
-(void) updateLoadingBar:(NSNumber *) _value;
@end
