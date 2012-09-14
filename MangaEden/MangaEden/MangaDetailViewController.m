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
    // Do any additional setup after loading the view from its nib.
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
@end
