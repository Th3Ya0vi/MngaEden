//
//  RetrieveChapterListOperation.m
//  quickmanga
//
//  Created by Luong Ken on 1/26/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import "RetrieveChapterListOperation.h"
#import "MoChapter+Extra.h"

@implementation RetrieveChapterListOperation
@synthesize delegate,aMangaObjectID;

#pragma mark-
#pragma mark dealloc
- (void)dealloc{
	[aMangaObjectID release];
	[super dealloc];	
}


#pragma mark -
#pragma mark init
- (RetrieveChapterListOperation *)initWithPersistenceStoreCoordinator:(NSPersistentStoreCoordinator *)psc andAMangaObjectID:(NSManagedObjectID *)objectID{
	self = [super init];
	if	(self){
		self.persistentStoreCoordinator = psc;
		self.aMangaObjectID= objectID;
		self->manga_id =  [(MoManga *)[self.insertionContext objectWithID:self.aMangaObjectID] manga_id];
	}
	return self;
}

#pragma mark -
#pragma mark sub class override methods;

- (NSString *)stringForURL{	
	return [[NSString stringWithFormat:@"%@%@&mid=%d",kBaseURL,kRetrieveChapterListActionName,self->manga_id] 
			stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
}

- (void)beforeOperation{
	[super beforeOperation];
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveChapterListOperationDidSave:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self.delegate selector:@selector(retrieveChapterListOperationDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.insertionContext];
    }
}

- (void)afterOperation{
	[super afterOperation];
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveChapterListOperationDidSave:)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.delegate name:NSManagedObjectContextDidSaveNotification object:self.insertionContext];
    }
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveChapterListOperationDidFinishImportingData)]) {
		[self.delegate retrieveChapterListOperationDidFinishImportingData];
    }
}
- (NSError *)processData:(NSData *)content{
	
	NSPropertyListFormat format;
	NSString *desc;
	
	id plist = [NSPropertyListSerialization propertyListFromData:content mutabilityOption:0 format:&format errorDescription:&desc];
	
	NSArray *list = (NSArray *)plist;	
	
	MoManga *manga = (MoManga *)[self.insertionContext objectWithID:self.aMangaObjectID];
	NSError *error;	
		
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *chapterEntity = [NSEntityDescription entityForName:@"aChapter" inManagedObjectContext:self.insertionContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"manga_id = %d",self->manga_id];
	NSArray *sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"chapter_number" ascending:YES] autorelease]];	
	
	[fetchRequest setEntity:chapterEntity];
	[fetchRequest setPredicate:predicate];
	[fetchRequest setFetchBatchSize:20];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSArray *result = [self.insertionContext executeFetchRequest:fetchRequest error:&error];
	
	if ([result count] == [list count]) { //update to the existing list
		
	}
	
	DLog(@"list count = %d",[list count]);
		
	NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
	int count = 0;
	for (NSDictionary *item in list) {
		if (self.isCancelled) {
			break;
		}
		int cid = [[item objectForKey:@"cid"] intValue];
		int order = [[item objectForKey:@"order"] intValue];
		NSString * name = [[item objectForKey:@"name"] stringByDecodingXMLEntities];
		int total_pages = [[item objectForKey:@"total_pages"] intValue];
		
		//DLog(@"cid = %d, order = %d, name = %@, total pages = %d",cid,order,name,total_pages);
		BOOL isNeedToCreate = YES;
		if ([result count] != 0) {
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chapter_id = %d",cid];
			NSArray *search = [result filteredArrayUsingPredicate:predicate];
			if ([search count] > 0) {
				MoChapter *c = [search objectAtIndex:0];
				if ([c.name caseInsensitiveCompare:name] != NSOrderedSame) {
					c.name = name;
				}
				if ([c.chapter_number intValue] != order+1) {
					c.chapter_number = [NSNumber numberWithInt:order+1];
				}
				if ([c.total_page intValue] != total_pages) {
					c.total_page = [NSNumber numberWithInt:total_pages];
				}
				isNeedToCreate = NO;
			} 
		}
		if (isNeedToCreate) {
			MoChapter *c = [[MoChapter alloc] initWithEntity:chapterEntity insertIntoManagedObjectContext:self.insertionContext];
			c.chapter_id = [NSNumber numberWithInt:cid];
			c.chapter_number = [NSNumber numberWithInt:order+1];
			c.name = name;
			c.total_page = [NSNumber numberWithInt:total_pages];
			c.manga_id = [NSNumber numberWithInt:self->manga_id];
			c.moManga = manga;
			[c release];
		}	
		
		if (count > 150) {
			NSError *saveError = nil;
			[self.insertionContext save:&saveError];
			
			[aPool release];
			aPool = nil;
			aPool = [[NSAutoreleasePool alloc] init];
			count = 0;
		}
		count++;
	}
	
	if (aPool != nil){
		[aPool release];
		aPool = nil;
	}
	
	[fetchRequest release];
	fetchRequest = nil;
	return nil;
}

#pragma mark -
#pragma mark NSURLConnection Delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	DLog(@"-");
	[super connection:connection didReceiveResponse:response];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveChapterListOperationWillImportData:)]) {
		[self.delegate retrieveChapterListOperationWillImportData:[response expectedContentLength]];
    }	
}

#pragma mark forwardError
- (void)forwardError:(NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(retrieveChapterListOperationDidFailImportingData:)]) {
        [self.delegate retrieveChapterListOperationDidFailImportingData:error];
    }
}

@end
