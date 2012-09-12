//
//  SyncListOperation.m
//  quickmanga
//
//  Created by Luong Ken on 1/25/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//
#import "AppConfig.h"
#import "SyncListOperation.h"
#import "MoManga+Extra.h"
@implementation SyncListOperation

@synthesize delegate;

#pragma mark-
#pragma mark dealloc
- (void)dealloc{	
	[super dealloc];	
}


#pragma mark -
#pragma mark init
- (SyncListOperation *)initWithPersistenceStoreCoordinator:(NSPersistentStoreCoordinator *)psc{
	self = [super init];
	if	(self){
		self.persistentStoreCoordinator = psc;
	}
   
	return self;
}

#pragma mark -
#pragma mark sub class override methods;

- (NSString *)stringForURL{
	return [[NSString stringWithFormat:@"%@%@&timestamp=%lli&country=%@",kBaseURL,kSyncListActionName,[AppSettings lastUpdate],[AppSettings countryName]]
						   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

- (void)beforeOperation{
	[super beforeOperation];
	if (self.delegate && [self.delegate respondsToSelector:@selector(syncListOperationDidSave:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self.delegate selector:@selector(syncListOperationDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.insertionContext];
    }
}

- (void)afterOperation{
	[super afterOperation];
	if (self.delegate && [self.delegate respondsToSelector:@selector(syncListOperationDidSave:)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.delegate name:NSManagedObjectContextDidSaveNotification object:self.insertionContext];
    }
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(syncListOperationDidFinishImportingData)]) {
		[self.delegate syncListOperationDidFinishImportingData];
    }
}

- (NSError *)processData:(NSData *)content{
	
	NSPropertyListFormat format;
	NSString *desc;
	
	id plist = [NSPropertyListSerialization propertyListFromData:content mutabilityOption:0 format:&format errorDescription:&desc];
	
	long long timestamp = [[plist objectForKey:@"timestamp"] longLongValue];
	
	NSArray *mangaList = [plist objectForKey:@"list"];	
	int count = 0;
	
	NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
	
	for (NSDictionary *aDict in mangaList) {
		int mid = [[aDict objectForKey:@"mid"] intValue];
		int completed = [[aDict objectForKey:@"completed"] intValue];
		NSString *author = [[aDict objectForKey:@"author"] stringByDecodingXMLEntities];
		NSString *name = [[aDict objectForKey:@"name"] stringByDecodingXMLEntities];
		int rank = [[aDict objectForKey:@"rank"] intValue];
		if (rank == 0) {
			rank = 9999;
		}
		int direction = [[aDict objectForKey:@"direction"] intValue];
		
		long long last_update = [[aDict objectForKey:@"last_update"] longLongValue];
		
		int remove = [[aDict objectForKey:@"remove"] intValue];
		int total_chapters = [[aDict objectForKey:@"total_chapters"] intValue];
		
		NSArray *categories = [[aDict objectForKey:@"categories"] retain];
		NSMutableString *categoriesString = [[NSMutableString alloc] initWithString:@""];
		
		for (NSString *aString in categories) {
			//DLog(@"%@",aString);
			[categoriesString appendString:aString];
			
			if ([categories indexOfObject:aString] < [categories count] - 1) {
				[categoriesString appendString:@","];
			}
		}
		DLog(@"mid = %d, completed = %d, author = %@, name = %@, rank = %d, direction = %d,  last_update = %lli, categories = %@, remove = %d",mid,completed,author,name,rank,direction,last_update,categoriesString,remove);
		
		count = count + 1;		
		
		MoManga *m = nil;
		
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *mangaEntity = [NSEntityDescription entityForName:@"MoManga" inManagedObjectContext:self.insertionContext];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"manga_id = %d",mid];
		
		[fetchRequest setEntity:mangaEntity];
		[fetchRequest setPredicate:predicate];
		[fetchRequest setFetchBatchSize:5];
		
		NSError *error;
		NSArray *result = [self.insertionContext executeFetchRequest:fetchRequest error:&error];
		
		if ([result count] > 0) {
			m = [(MoManga *)[result objectAtIndex:0] retain];
		} else {
			m = [[MoManga alloc] initWithEntity:self.aMangaEntityDescription insertIntoManagedObjectContext:self.insertionContext];
		}
		[fetchRequest release];
		fetchRequest = nil;		
		
		m.manga_id = [NSNumber numberWithInt:mid];
		m.completed = [NSNumber numberWithInt:completed];
		m.author = author;
		m.name = name;
		m.rank = [NSNumber numberWithInt:rank];
		m.direction = [NSNumber numberWithInt:direction];
		m.last_update = [NSNumber numberWithLongLong:last_update];
		m.categories = categoriesString;
		m.license = [NSNumber numberWithInt:remove];
		
		if ([m.total_chapter intValue] == 0) {
			m.total_chapter = [NSNumber numberWithInt:total_chapters];
			m.new_updated_total = [NSNumber numberWithInt:total_chapters];
		} else {
			DLog(@"total = %d, having = %d",total_chapters,[m.total_chapter intValue]);
			int diff = total_chapters - [m.total_chapter intValue];
			
			m.total_chapter = [NSNumber numberWithInt:total_chapters];
			if (diff >= 0) {			
				int new_updated = diff;
				
				if ([m.new_updated_total intValue] > 0) {
					new_updated = new_updated + diff;
				}
				
				if ([m.favourite intValue] == 1) {
					if ([m.new_updated_total intValue] > 0) {
						[AppSettings setTotalUncheckFav: ([AppSettings totalUncheckFav] - [m.new_updated_total intValue])];
					} 					
					[AppSettings setTotalUncheckFav: ([AppSettings totalUncheckFav] + new_updated)];
				} 
				
				m.new_updated_total = [NSNumber numberWithInt:new_updated];
			} 
		}

		if ([m.rank intValue] < 1000) {
			m.rank_index = [NSNumber numberWithInt:0]; 
		} else {
			int number = floor([m.rank intValue]/1000) * 1000;
			m.rank_index = [NSNumber numberWithInt:number];
		}
		
		NSString *alphabetical = [[name substringToIndex:1] uppercaseString];
		if ([alphabetical characterAtIndex:0] < 'A' || [alphabetical characterAtIndex:0] > 'Z') {
			alphabetical = @"#";
		}
		
		m.alphabetical = alphabetical;		
		
		[categoriesString release];
		categoriesString = nil;
		
		[categories release];
		categories = nil;
		
		if (m != nil) {
			[m release];
			m = nil;
		}	
		
		if (count > 500){
			NSError *saveError = nil;
			[self.insertionContext save:&saveError];
			
			[aPool release];
			aPool = nil;
			aPool = [[NSAutoreleasePool alloc] init];
			count = 0;
		}
		
		
	}
	
	if (aPool != nil){
		[aPool release];
		aPool = nil;
	}
	
	DLog(@"timestamp = %lli",timestamp);
	
    [self getPushNewsCount];
    
	[AppSettings setLastUpdate:timestamp];		
	[AppSettings setLastUpdateDate:[NSDate date]];    
	
	return nil;
}

- (void)getPushNewsCount{
	
    //getting number of news
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"US"] autorelease]];	
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Singapore/Singapore"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString *dateString = [dateFormatter stringFromDate: [AppSettings lastUpdateDate]];
    
    NSError *error;
    //NSString *newsUrl = [[NSString stringWithFormat:@"http://internal.notabasement.com/app_push_news.php?app_name=Manga rock&last_date=2011-01-11 00:00:00",1/*dateString*/] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *newsUrl = [[NSString stringWithFormat:@"http://internal.notabasement.com/app_push_news.php?app_name=%@&last_date=%@",@"Manga Rock",dateString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"newsurl = %@",newsUrl);
    NSURL *newsurl = [NSURL URLWithString:newsUrl];
    NSString *totalNewsString = [[NSString alloc] initWithContentsOfURL:newsurl encoding:NSUTF8StringEncoding error:&error];
    
    if (error != nil) {
        DLog(@"total news string = %@",totalNewsString);
		int totalNews = [totalNewsString intValue];
		[AppSettings setTotalNewsCount:[AppSettings totalNewsCount] + totalNews];
		
    }
    
    [totalNewsString release];
}

#pragma mark -
#pragma mark NSURLConnection Delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	DLog(@"-");
	[super connection:connection didReceiveResponse:response];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(syncListOperationWillImportData:)]) {
		[self.delegate syncListOperationWillImportData:[response expectedContentLength]];
    }	
}

#pragma mark forwardError
- (void)forwardError:(NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(syncListOperationDidFailImportingData:)]) {
        [self.delegate syncListOperationDidFailImportingData:error];
    }
}
@end
