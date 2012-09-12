//  InitialDataImporterOperation.m
//  quickmanga
//
//  Created by Luong Ken on 1/23/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import "RetrieveListOperation.h"
#import "MoManga+Extra.h"
#import "DateUtil.h"
@implementation RetrieveListOperation

@synthesize delegate;

#pragma mark-
#pragma mark dealloc
- (void)dealloc{
	[super dealloc];	
}


#pragma mark -
#pragma mark init
- (RetrieveListOperation *)initWithPersistenceStoreCoordinator:(NSPersistentStoreCoordinator *)psc{
	self = [super init];
	if	(self){
		self.persistentStoreCoordinator = psc;
	}
	return self;
    [[DateUtil getSingleton] humanDate:@""];
}

#pragma mark -
#pragma mark sub class override methods;

- (NSString *)stringForURL{
    //return @"http://komikconnect.com/plistmrquery10.php?action=retrieve_list&country=United%20States";
    return @"http://www.mangaeden.com/api/list/0/";
	//return [[NSString stringWithFormat:@"%@%@&country=%@",kBaseURL,kRetrieveListActionName, [AppSettings countryName]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)beforeOperation{
	[super beforeOperation];
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveListOperationDidSave:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self.delegate selector:@selector(retrieveListOperationDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.insertionContext];
    }	
}

- (void)afterOperation{
    
	[super afterOperation];
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveListOperationDidSave:)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.delegate name:NSManagedObjectContextDidSaveNotification object:self.insertionContext];
    }
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveListOperationDidFinishImportingData)]) {
		[self.delegate retrieveListOperationDidFinishImportingData];
    }
}


- (NSError *)processData:(NSData *)content{
	
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:content 
                                                         options:kNilOptions
                          
                                                           error:&error];
    NSArray* manga = [json objectForKey:@"manga"];
       
    for (NSDictionary *dictManga in manga)
    {
        NSString * mangaID = [dictManga objectForKey:@"i"] ;
        NSString *nameManga = [dictManga objectForKey:@"t"];
        MoManga *myManga = [[MoManga alloc] initWithEntity:self.aMangaEntityDescription insertIntoManagedObjectContext:self.insertionContext];
        myManga.manga_id = mangaID;
        myManga.name = nameManga;

    }
    NSError *saveError = nil;
    [self.insertionContext save:&saveError];
    return saveError;
    /*
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
		int old_mid = [[aDict objectForKey:@"old_mid"] intValue];
		long long last_update = [[aDict objectForKey:@"last_update"] longLongValue];
		
		int license = [[aDict objectForKey:@"license"] intValue];
		
		NSArray *categories = [[aDict objectForKey:@"categories"] retain];
		NSMutableString *categoriesString = [[NSMutableString alloc] initWithString:@""];
		
		for (NSString *aString in categories) {
			//DLog(@"%@",aString);
			[categoriesString appendString:aString];
			
			if ([categories indexOfObject:aString] < [categories count] - 1) {
				[categoriesString appendString:@","];
			}
		}
		//DLog(@"mid = %d, completed = %d, author = %@, name = %@, rank = %d, direction = %d, old_mid = %d, last_update = %lli, categories = %@, license = %d",mid,completed,author,name,rank,direction,old_mid,last_update,categoriesString,license);
		
		count = count + 1;		
		
		MoManga *m = [[MoManga alloc] initWithEntity:self.aMangaEntityDescription insertIntoManagedObjectContext:self.insertionContext];
		m.manga_id = [NSNumber numberWithInt:mid];
		m.completed = [NSNumber numberWithInt:completed];
		m.author = author;
		m.name = name;
		m.rank = [NSNumber numberWithInt:rank];
		m.direction = [NSNumber numberWithInt:direction];
		m.old_mid = [NSNumber numberWithInt:old_mid];
		m.last_update = [NSNumber numberWithLongLong:last_update];
		m.license = [NSNumber numberWithInt:license];
		m.categories = categoriesString;
		
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
		
		[m release];
		m = nil;
		
		if (count > 700){
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
	return nil;
     */
}

#pragma mark -
#pragma mark NSURLConnection Delegate methods

- (void)forwardError:(NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(retrieveListOperationDidFailImportingData:)]) {
        [self.delegate retrieveListOperationDidFailImportingData:error];
    }
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[super connection:connection didReceiveData:data];	
	
	if (delegate && [delegate respondsToSelector:@selector(retrieveListOperationDidDonwloadDataAtCurrentSize:)]) {
		[self.delegate retrieveListOperationDidDonwloadDataAtCurrentSize:[self.importingData length]];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{	
	if (self.delegate && [self.delegate respondsToSelector:@selector(retrieveListOperationWillDonwloadDataWithSize:)]) {
		[self.delegate retrieveListOperationWillDonwloadDataWithSize:[response expectedContentLength]];
	}	
	[super connection:connection didReceiveResponse:response];
	
	
}
@end
