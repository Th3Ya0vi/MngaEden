//
//  RetrieveMangaInfoOperation.m
//  quickmanga
//
//  Created by Luong Ken on 1/25/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import "RetrieveMangaInfoOperation.h"
#import "MoManga+Extra.h"

@implementation RetrieveMangaInfoOperation
@synthesize delegate,manga_id;

BOOL isNeedToRefresh;
#pragma mark-
#pragma mark dealloc
- (void)dealloc{	
	[super dealloc];	
}


#pragma mark -
#pragma mark init
- (RetrieveMangaInfoOperation *)initWithPersistenceStoreCoordinator:(NSPersistentStoreCoordinator *)psc andMid:(int)aManga_id;{
	self = [super init];
	if	(self){
		self.persistentStoreCoordinator = psc;
		self.manga_id = aManga_id;
		isNeedToRefresh = NO;
	}
	return self;
}

#pragma mark -
#pragma mark sub class override methods;

- (NSString *)stringForURL{	
	return [[NSString stringWithFormat:@"%@%@&mid=%d",kBaseURL,kRetrieveMangaInfoActionName,self.manga_id] 
			stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];	
}

- (void)beforeOperation{
	[super beforeOperation];
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveMangaInfoOperationDidSave:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self.delegate selector:@selector(retrieveMangaInfoOperationDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.insertionContext];
    }
}

- (void)afterOperation{
	[super afterOperation];
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveMangaInfoOperationDidSave:)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.delegate name:NSManagedObjectContextDidSaveNotification object:self.insertionContext];
    }
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveMangaInfoOperationDidFinishImportingDataAndRequireRefreshData:)]) {
		[self.delegate retrieveMangaInfoOperationDidFinishImportingDataAndRequireRefreshData:isNeedToRefresh];
    }
}
- (NSError *)processData:(NSData *)content{
	
	NSPropertyListFormat format;
	NSString *desc;
	
	id plist = [NSPropertyListSerialization propertyListFromData:content mutabilityOption:0 format:&format errorDescription:&desc];	
	
	NSDictionary *aDict = (NSDictionary *)plist;
	
	int completed = [[aDict objectForKey:@"completed"] intValue];
	NSString *author = [[aDict objectForKey:@"author"] stringByDecodingXMLEntities];
	NSString *name = [[aDict objectForKey:@"name"] stringByDecodingXMLEntities];
	int rank = [[aDict objectForKey:@"rank"] intValue];
	if (rank == 0) {
		rank = 9999;
	}
	
	long long last_update = [[aDict objectForKey:@"last_update"] longLongValue];
	
	int direction = [[aDict objectForKey:@"direction"] intValue];
	int totalChapters = [[aDict objectForKey:@"total_chapters"] intValue];
	
	NSString *thumbnailUrl = [aDict objectForKey:@"thumbnail_url"];
	
	NSArray *categories = [[aDict objectForKey:@"categories"] retain];
	NSMutableString *categoriesString = [[NSMutableString alloc] initWithString:@""];
	
	for (NSString *aString in categories) {
		//DLog(@"%@",aString);
		[categoriesString appendString:aString];
		
		if ([categories indexOfObject:aString] < [categories count] - 1) {
			[categoriesString appendString:@","];
		}
	}
	
	NSString *summary = [[aDict objectForKey:@"description"] stringByDecodingXMLEntities]; 
	
	DLog(@"completed = %d, author = %@, name = %@, rank = %d, direction = %d,  last_update = %lli, categories = %@, total chapter = %d, thumbnail url = %@",completed,author,name,rank,direction,last_update,categoriesString,totalChapters, thumbnailUrl);
	
	
	MoManga *m = nil;
		
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *mangaEntity = [NSEntityDescription entityForName:@"MoManga" inManagedObjectContext:self.insertionContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"manga_id = %d",self.manga_id];
	
	[fetchRequest setEntity:mangaEntity];
	[fetchRequest setPredicate:predicate];
	[fetchRequest setFetchBatchSize:5];
	
	NSError *error;
	NSArray *result = [self.insertionContext executeFetchRequest:fetchRequest error:&error];
	
	if ([result count] > 0) {
		m = [(MoManga *)[result objectAtIndex:0] retain];
		
		if (([m.last_update longLongValue] != last_update) || [m.total_chapter intValue] != totalChapters || [[m.moChapters allObjects] count] != totalChapters) {
			m.completed = [NSNumber numberWithInt:completed];
			m.author = author;
			m.name = name;
			m.rank = [NSNumber numberWithInt:rank];
			m.direction = [NSNumber numberWithInt:direction];
			m.last_update = [NSNumber numberWithLongLong:last_update];
			m.categories = categoriesString;
			m.license = [NSNumber numberWithInt:1];			
			m.total_chapter = [NSNumber numberWithInt:totalChapters];
			
			//m.new_updated_total = [NSNumber numberWithInt:totalChapters - [m.total_chapter intValue]];
			m.thumbnail_url = thumbnailUrl;
			if ([m.rank intValue] < 1000) {
				m.rank_index = [NSNumber numberWithInt:0]; 
			} else {
				int number = floor([m.rank intValue]/1000) * 1000;
				m.rank_index = [NSNumber numberWithInt:number];
			}
			m.summary = summary;
			NSString *alphabetical = [[name substringToIndex:1] uppercaseString];
			if ([alphabetical characterAtIndex:0] < 'A' || [alphabetical characterAtIndex:0] > 'Z') {
				alphabetical = @"#";
			}
			
			m.alphabetical = alphabetical;	
			isNeedToRefresh = YES;
		}
		[m release];
		m = nil;		
	}
	
	[categoriesString release];
	categoriesString = nil;
	
	[categories release];
	categories = nil;
	
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
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveMangaInfoOperationWillImportData:)]) {
		[self.delegate retrieveMangaInfoOperationWillImportData:[response expectedContentLength]];
    }	
}

#pragma mark forwardError
- (void)forwardError:(NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(retrieveMangaInfoOperationDidFailImportingData:)]) {
        [self.delegate retrieveMangaInfoOperationDidFailImportingData:error];
    }
}

@end
