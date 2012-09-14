//
//  MangaDetailViewController.m
//  MangaEden
//
//  Created by Cuccku on 1/5/11.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import "MangaDetailViewController.h"

@interface MangaDetailViewController ()

@end

@implementation MangaDetailViewController
@synthesize tableViewChapter;
@synthesize headerTableView;
@synthesize manga;
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

    self.title = @"Loading..";
    if ([self.manga isNeedToDownloadMangaDetail]) {
        [self createAndStartRetrieveMangaInfoOp];
    }
    
    if ([self.manga isNeedToDownloadMangaThumbnail]) {
        [self createAndStartImgDownloadOp];
    } else {
        //[self populateThumbnailWithUIImage:[self.manga UIImageForThumbnail]];
    }

}

- (void)viewDidUnload
{
    [self setHeaderTableView:nil];
    [self setTableViewChapter:nil];
    [self setManga:nil];
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	
    return 0;
	
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
	
	return nil;
}
#pragma mark -
#pragma mark create and start operations
- (void)createAndStartRetrieveMangaInfoOp{
	RetrieveMangaInfoOperation *op = [[RetrieveMangaInfoOperation alloc] initWithPersistenceStoreCoordinator:self.persistentStoreCoordinator andMid:[self.manga.manga_id intValue]];
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

@end
