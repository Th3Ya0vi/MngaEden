//
//  MangaDetailViewController.h
//  MangaEden
//
//  Created by Cuccku on 1/5/11.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoManga+Extra.h"
#import "RetrieveMangaInfoOperation.h"
#import "RetrieveChapterListOperation.h"
#import "ImageDownloaderOperation.h"

@interface MangaDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RetrieveChapterListOperationDelegate, RetrieveMangaInfoOperationDelegate, ImageDownloaderDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewChapter;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *headerTableView;
@property (strong, nonatomic) MoManga *manga;

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultControllerChapter;
@end
