//
//  FirstViewController.m
//  MangaEden
//
//  Created by Cuccku on 8/24/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import "HomeViewController.h"
#import "MoManga.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize customCell;
@synthesize progessDownLoadListManga;
@synthesize statusLabel;
@synthesize tableViewListManga, currentListFRC, searchFilterAlls, operationQueue, persistentStoreCoordinator, managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewListManga.delegate = self;
    self.tableViewListManga.dataSource = self;
	// Do any additional setup after loading the view, typically from a nib.
    if ([AppSettings lastUpdate] == 0) {//first time open
		[AppSettings setAutoHideMenu:YES];
		[AppSettings setAutoDeleteChapter:NO];
		[AppSettings setAutoUpdateManagaList:NO];
		[AppSettings setChapterListOrder:NO];
		[AppSettings setTotalNewsCount:0];
		[AppSettings setTotalUncheckFav:0];
		if ([UIAppDelegate backgroundSupported]) {//if iphone 3g
			[AppSettings setTotalConcurrentDownloadingChapter:3];
		} else {
			[AppSettings setTotalConcurrentDownloadingChapter:1];
		}
		
		RetrieveListOperation *retrieveOp = (RetrieveListOperation *)[[RetrieveListOperation alloc] initWithPersistenceStoreCoordinator:self.persistentStoreCoordinator];
		retrieveOp.delegate = self;
		[self.operationQueue addOperation:retrieveOp];
		
		retrieveOp = nil;
	}
    else
    {
		if ([AppSettings autoUpdateMangaList]) {
			//[self showBlockView];
			SyncListOperation *operation = [[SyncListOperation alloc] initWithPersistenceStoreCoordinator:self.persistentStoreCoordinator];
			operation.delegate = self;
			[self.operationQueue addOperation:operation];
			
			
		} else {
            /*
			[self loadAllFRC];
			[self fetch];
             */
		}
	}

}

- (void)viewDidUnload
{
    tableViewListManga = nil;
    [self setTableViewListManga:nil];
    [self setCustomCell:nil];
    [self setProgessDownLoadListManga:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) loadAllARC
{
    
}
- (NSPredicate *) predicateForFRC {
	NSPredicate *predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"categories contains[c]",@""];
    /*
	if ([self.currentFilterCategories count] >0) {
		if (self.currentFilterStatus != MangaCompleteFilterAll) {
			predicate = [NSPredicate predicateWithFormat:@"categories contains[c] %@ and completed = %d", [self categoriesString], self.currentFilterStatus];
		} else {
			predicate = [NSPredicate predicateWithFormat:@"categories contains[c] %@", [self categoriesString]];
		}
	} else {
		if (self.currentFilterStatus != MangaCompleteFilterAll) {
			DLog(@"come here");
			predicate = [NSPredicate predicateWithFormat:@"completed = %d", self.currentFilterStatus];
		}
	}
     */
	return predicate;
}
- (NSOperationQueue *)operationQueue{
    if (operationQueue == nil) {
        operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:1];
    }
    return operationQueue;
}
#pragma mark UITableView Delegate

- (void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    NSLog(@"woathe fuck here");
}
#pragma mark -
#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	if (aTableView == self.searchDisplayController.searchResultsTableView) {
		return 1;
	} else {
		return [[self.currentListFRC sections] count];
	}
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	
		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.currentListFRC sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView {
	return nil;
}

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section{
	return nil;;
}

- (NSInteger)tableView:(UITableView *)aTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    // tell table which section corresponds to section title/index (e.g. "B",1))
	if (aTableView == self.searchDisplayController.searchResultsTableView) {
		return 0;
	} else {
        /*
		if (index == 0) {
			[self.tableView setContentOffset:CGPointZero animated:NO];
			return NSNotFound;
		}
		return [self.currentFRC sectionForSectionIndexTitle:title atIndex:index - 1];
         */
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MoManga *manga;
	
	static NSString *cellIdentifier = @"CustomCatalogCell";
	
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
		cell = customCell;
		self.customCell = nil;
    }
	
	
    manga = (MoManga*)[self.currentListFRC objectAtIndexPath:indexPath] ;
	
	
	UIImageView *backgroundImg = nil;
	if (indexPath.row%2==0) {
		backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"browseMangaEvenCell.png"]];
	} else {
		backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"browseMangaOddCell.png"]];
	}
	
	cell.backgroundView = backgroundImg;	
	UIImageView *selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"browseMangaSelected.png"]];
	cell.selectedBackgroundView = selectedBackgroundView;
	
	UILabel *name = (UILabel *)[cell viewWithTag:1];
	name.text = manga.name;
	UILabel *author = (UILabel *)[cell viewWithTag:2];
	author.text = manga.manga_id;
	return cell;
}
#pragma mark -
#pragma mark RetrieveListOperation Delegate
long long fileSize = 0;
- (void) retrieveListOperationWillDonwloadDataWithSize:(long long)size{
	fileSize = size;
	DLog(@"size = %lld",fileSize);
	//[self showLoadingBar];
}

- (void) retrieveListOperationDidDonwloadDataAtCurrentSize:(long long)size{
	float currentProgress = 1.0f* size/fileSize;
	//DLog(@"size = %f",currentProgress);
	[self updateLoadingBar:[NSNumber numberWithFloat:currentProgress]];
}
-(void) updateLoadingBar:(NSNumber *) _value
{
    if ([NSThread isMainThread]) {
        [progessDownLoadListManga setProgress:[_value floatValue]];    
    }
    else
    {
        [self performSelectorOnMainThread:@selector(updateLoadingBar:) withObject:_value waitUntilDone:NO];
    }
    
    
}
- (void) retrieveListOperationDidFinishImportingData{
    NSLog(@"Test retrieve list");
    [self fetch];
    [self hideLoadingBar];
	/*
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *manga = [NSEntityDescription entityForName:@"Manga" inManagedObjectContext:self.oldManagedObjectContext];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_favourite = 1"];
		[fetchRequest setEntity:manga];
		[fetchRequest setPredicate:predicate];
		
		NSArray *result = [self.oldManagedObjectContext executeFetchRequest:fetchRequest error:nil];
		
		if ([result count] > 0) {
			countForOldFavs = [result count];
			currentCountForOldFavs = 1;
			for (Manga *m in result) {
				NSNumber *mid = m.manga_id;
				NSArray *founds = [[self.currentFRC fetchedObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"old_mid = %d",[mid intValue]]];
				if ([founds count] > 0) {
					aManga *am = [founds objectAtIndex:0];
					am.favourite = [NSNumber numberWithBool:YES];
					
					ImageDownloaderOperation *op = [[ImageDownloaderOperation alloc] initWithNSStringURL:m.thumbnail_url];
					op.delegate = self;
					op.pathToSave = [am constructThumbnailPath];
					[self.operationQueue setMaxConcurrentOperationCount:5];
					[self.operationQueue addOperation:op];
					
					[op release];
					op = nil;
				}
			}
            
			[self.managedObjectContext save:nil];
		}
		
		[fetchRequest release];
	*/
}

-(void) hideLoadingBar
{
    UIView *statusView = [self.view viewWithTag:9];
    if (statusView) {
        [statusView setHidden:YES];
    }
}
- (void) retrieveListOperationDidFailImportingData:(NSError *)error{
	[self hideLoadingBar];
}

- (void) retrieveListOperationDidSave:(NSNotification *)saveNotification{
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
}
#pragma mark -
#pragma mark SyncListOperation Delegate

- (void) syncListOperationWillImportData:(long long)size{
    NSLog(@"SyncListoperation will import data");
}
- (void)fetch {
	DLog(@"fetch");
	[self.currentListFRC performFetch:nil];
    [self.tableViewListManga reloadData];
}
- (void) syncListOperationDidFinishImportingData{
	if ([NSThread mainThread]) {
		//[UIAppDelegate refreshUpdateFavInfoTabItemBadge];
		[self fetch];
		
		[self performSelectorInBackground:@selector(getAnnoucement) withObject:nil];
	} else {
		[self performSelectorOnMainThread:@selector(syncListOperationDidFinishImportingData) withObject:nil waitUntilDone:YES];
	}
}
- (NSFetchedResultsController *)currentListFRC {
    if (currentListFRC == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *mangaEntity = [NSEntityDescription entityForName:@"MoManga" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:mangaEntity];
		
		
		NSDictionary *entityProperties = [mangaEntity propertiesByName];
		
		[fetchRequest setFetchBatchSize:20];
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:[entityProperties objectForKey:@"name"],[entityProperties objectForKey:@"author"],[entityProperties objectForKey:@"rank"],nil]];
		
        NSArray *sortDescriptors = nil;
        NSString *sectionNameKeyPath = nil;
		
		sortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"alphabetical"  ascending:YES],[[NSSortDescriptor alloc] initWithKey:@"name"  ascending:YES],nil];
		sectionNameKeyPath = @"alphabetical";
		[fetchRequest setSortDescriptors:sortDescriptors];
		
        
		currentListFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:sectionNameKeyPath cacheName:@"CatalogMangaAlphabeticalFRC"];
        
    }
    return currentListFRC;
}
- (void) syncListOperationDidFailImportingData:(NSError *)error{
	if ([NSThread mainThread]) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Eroor" message:@"Fail to update the catalog! Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
	} else {
		[self performSelectorOnMainThread:@selector(syncListOperationDidFailImportingData:) withObject:error waitUntilDone:NO];
	}
}

// Notification posted by NSManagedObjectContext when saved.
- (void) syncListOperationDidSave:(NSNotification *)saveNotification{
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
}

@end
