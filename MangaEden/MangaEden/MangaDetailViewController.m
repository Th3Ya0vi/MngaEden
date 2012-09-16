//
//  MangaDetailViewController.m
//  MangaEden
//
//  Created by Cuccku on 1/5/11.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import "MangaDetailViewController.h"
#import "MoChapter.h"
@interface MangaDetailViewController ()

@end

@implementation MangaDetailViewController
@synthesize tableViewChapter;
@synthesize headerTableView;
@synthesize authorLable;
@synthesize categoriesLabel;
@synthesize artistLabel;
@synthesize descriptionLabel;
@synthesize manga;
@synthesize operationQueue;
@synthesize managedObjectContext, persistentStoreCoordinator, fetchedResultControllerChapter;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewChapter.tableHeaderView = self.headerTableView;
    self.title = @"Loading..";
    if ([self.manga isNeedToDownloadMangaDetail]) {
        [self createAndStartRetrieveMangaInfoOp];
    }
    else{
        [self fetch];
        [self populateUILabels];
    }
    if ([self.manga isNeedToDownloadMangaThumbnail]) {
        [self createAndStartImgDownloadOp];
    } else {
        //[self populateThumbnailWithUIImage:[self.manga UIImageForThumbnail]];
    }

}

- (void)viewDidUnload
{
    [self setTableViewChapter:nil];
    [self setManga:nil];
    [self setAuthorLable:nil];
    [self setCategoriesLabel:nil];
    [self setArtistLabel:nil];
    [self setDescriptionLabel:nil];
    [self setHeaderTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark UITableView Delegate

- (void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}
#pragma mark -
#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
        return [[self.fetchedResultControllerChapter sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	
 	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultControllerChapter sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
	
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView {
	return nil;
}

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section{
	return nil;;
}

- (NSInteger)tableView:(UITableView *)aTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
   
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *cellIdentifier = @"ChapterListCell";
	
    MoChapter *moChapter = (MoChapter*) [self.fetchedResultControllerChapter objectAtIndexPath:indexPath];
	UITableViewCell *cellChapterList = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cellChapterList == nil) {
        cellChapterList = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
	[cellChapterList.textLabel setText:moChapter.name];
	
	return cellChapterList;
}
- (NSOperationQueue *)operationQueue{
    if (operationQueue == nil) {
        operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
    }
    return operationQueue;
}
#pragma mark -
#pragma mark chaptersFRC

- (NSFetchedResultsController *)fetchedResultControllerChapter{
	if (fetchedResultControllerChapter == nil) {
		
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
        NSEntityDescription *chapterEntity = [NSEntityDescription entityForName:@"MoChapter" inManagedObjectContext:self.managedObjectContext];
		
		NSPredicate *predicate = nil;
		
		predicate = [NSPredicate predicateWithFormat:@"manga_id = %@",self.manga.manga_id ];
		
		[fetchRequest setPredicate:predicate];
		[fetchRequest setEntity:chapterEntity];
		
		NSDictionary *entityProperties = [chapterEntity propertiesByName];
		
		[fetchRequest setFetchBatchSize:20];
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:[entityProperties objectForKey:@"name"],[entityProperties objectForKey:@"chapter_number"],nil]];
		
        NSArray *sortDescriptors = nil;
        NSString *sectionNameKeyPath = @"chapterNumberSection";
        
		sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"chapter_number" ascending:[AppSettings chapterListOrder]]];
		
		[fetchRequest setSortDescriptors:sortDescriptors];
		fetchedResultControllerChapter = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:sectionNameKeyPath cacheName:nil];
    }
    return fetchedResultControllerChapter;
}

#pragma mark -
#pragma mark create and start operations
- (void)createAndStartRetrieveMangaInfoOp{
	RetrieveMangaInfoOperation *op = [[RetrieveMangaInfoOperation alloc] initWithPersistenceStoreCoordinator:self.persistentStoreCoordinator andMid:self.manga.manga_id ];
	op.delegate = self;
	[self.operationQueue addOperation:op];
	op = nil;
}

- (void)createAndStartRetrieveChapterListOp{
	RetrieveChapterListOperation *op2 = (RetrieveChapterListOperation *)[[RetrieveChapterListOperation alloc] initWithPersistenceStoreCoordinator:self.persistentStoreCoordinator andAMangaObjectID:[self.manga objectID]];
	op2.delegate = self;
	[self.operationQueue addOperation:op2];

	op2 = nil;
}

- (void)createAndStartImgDownloadOp{
	ImageDownloaderOperation *op = [[ImageDownloaderOperation alloc] initWithNSStringURL:self.manga.thumbnail_url];
	op.delegate = self;
	op.pathToSave = [self.manga constructThumbnailPath];
	[self.operationQueue addOperation:op];
	
	op = nil;
}
- (void) populateUILabels
{
    if ([NSThread isMainThread]) {
		descriptionLabel.text = self.manga.summary;
		authorLable.text = manga.author;	
	} else {
        [self performSelectorOnMainThread:@selector(populateUILabels) withObject:nil waitUntilDone:YES];
	}
}
- (void) retrieveMangaInfoOperationWillImportData:(long long)size{
	
}
-(void) fetch
{
    NSError *error = nil;
    [self.fetchedResultControllerChapter performFetch:&error];
	[self.tableViewChapter performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}
- (void) retrieveMangaInfoOperationDidFinishImportingDataAndRequireRefreshData:(BOOL)isNeed{
    
	if (isNeed) {
		[self.managedObjectContext refreshObject:self.manga mergeChanges:YES];		
        NSLog(@"number chapters: %i", [self.manga.total_chapter intValue]);
		[self populateUILabels];
		[self fetch];
        //saved last browsed date
        self.manga.last_browsed_date = [NSDate date];
        [AppSettings setTotalUncheckFav:([AppSettings totalUncheckFav] - [self.manga.new_updated_total intValue])];
        
        self.manga.new_updated_total = [NSNumber numberWithInt:0];
        [self.managedObjectContext save:nil];
		
	} else {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *chapterEntity = [NSEntityDescription entityForName:@"aChapter" inManagedObjectContext:self.managedObjectContext];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"manga_id = %d",[self.manga.manga_id intValue]];
		
		[fetchRequest setIncludesSubentities:NO];
		
		[fetchRequest setEntity:chapterEntity];
		[fetchRequest setPredicate:predicate];
		
		NSError *error;
		NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
		if(count == NSNotFound) {
			//Handle error
		} else {
			if (count < [self.manga.total_chapter intValue]) {
				[self createAndStartRetrieveChapterListOp];
			}
			DLog(@"total chapter in core data count = %d",count);
		}	
	}
	if ([self.manga isNeedToDownloadMangaThumbnail]) {
		[self createAndStartImgDownloadOp];
	}
     
}

- (void) retrieveMangaInfoOperationDidFailImportingData:(NSError *)error{
	
}

// Notification posted by NSManagedObjectContext when saved.
- (void) retrieveMangaInfoOperationDidSave:(NSNotification *)saveNotification{
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
    [self fetch];
	
	//saved last browsed date
	self.manga.last_browsed_date = [NSDate date];
    
	[AppSettings setTotalUncheckFav:([AppSettings totalUncheckFav] - [self.manga.new_updated_total intValue])];
    
	self.manga.new_updated_total = [NSNumber numberWithInt:0];
	[self.managedObjectContext save:nil];
}

#pragma mark -
#pragma mark ImageDownloaderDelegate

- (void) imageDownloaderDidFinishDownloadingImage:(UIImage *)image{
	/*
    isThumbnailLoaded = NO;
	[self populateThumbnailWithUIImage:image];
     */
}

- (void) imageDownloaderDidFailDownloadingWithError:(NSError *)error{
}

- (void) imageDownloaderDidStopDownloading{
}

#pragma mark -
#pragma mark RetrieveChapterListOperationDelegate

- (void) retrieveChapterListOperationWillImportData:(long long)size{
	
}
- (void) retrieveChapterListOperationDidFinishImportingData{
	
  
    
}
- (void) retrieveChapterListOperationDidFailImportingData:(NSError *)error{
	
}


// Notification posted by NSManagedObjectContext when saved.
- (void) retrieveChapterListOperationDidSave:(NSNotification *)saveNotification{
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
}

@end
