//
//  RetrieveMangaInfoOperation.m
//  quickmanga
//
//  Created by Luong Ken on 1/25/11.
//  Copyright 2011 Not A Basement Studio. All rights reserved.
//

#import "RetrieveMangaInfoOperation.h"
#import "MoManga+Extra.h"
#import "MoChapter.h"
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
- (RetrieveMangaInfoOperation *)initWithPersistenceStoreCoordinator:(NSPersistentStoreCoordinator *)psc andMid:(NSString *)aManga_id;{
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
  
	return [[NSString stringWithFormat:@"%@%@",kBaseURLManga,self.manga_id]
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
	
    //parse out the json data
    NSError* error;
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:content
                                                         options:kNilOptions
                          
                                                           error:&error];
    
   	
	int completed = [[jsonDict objectForKey:@"status"] intValue];
	NSString *author = [[jsonDict objectForKey:@"author"] stringByDecodingXMLEntities];
	NSString *name = [[jsonDict objectForKey:@"title"] stringByDecodingXMLEntities];
	
    int rank = [[jsonDict objectForKey:@"hits"] intValue];
	
	long long last_update = [[jsonDict objectForKey:@"last_chapter_date"] longLongValue];
	

    NSArray *arrayChapter = (NSArray*)[jsonDict objectForKey:@"chapters"];

    
	int totalChapters = arrayChapter.count;
	
	NSString *thumbnailUrl = [jsonDict objectForKey:@"image"];
	
	NSArray *categories = [[jsonDict objectForKey:@"categories"] retain];
	NSMutableString *categoriesString = [[NSMutableString alloc] initWithString:@""];	
	for (NSString *aString in categories) {
		[categoriesString appendString:aString];		
		if ([categories indexOfObject:aString] < [categories count] - 1) {
			[categoriesString appendString:@","];
		}
	}
	
	NSString *summary = [[jsonDict objectForKey:@"description"] stringByDecodingXMLEntities];
	MoManga *m = nil;
		
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *mangaEntity = [NSEntityDescription entityForName:@"MoManga" inManagedObjectContext:self.insertionContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"manga_id = %@",self.manga_id];
	
	[fetchRequest setEntity:mangaEntity];
	[fetchRequest setPredicate:predicate];
	[fetchRequest setFetchBatchSize:5];
	
	NSArray *result = [self.insertionContext executeFetchRequest:fetchRequest error:&error];
	
	if ([result count] > 0) {
		m = [(MoManga *)[result objectAtIndex:0] retain];
		
		if (([m.last_update longLongValue] != last_update) || [m.total_chapter intValue] != totalChapters || [[m.moChapters allObjects] count] != totalChapters) {
			m.completed = [NSNumber numberWithInt:completed];
			m.author = author;
			m.name = name;
			m.rank = [NSNumber numberWithInt:rank];
			m.last_update = [NSNumber numberWithLongLong:last_update];
			m.categories = categoriesString;
			m.license = [NSNumber numberWithInt:1];			
			m.total_chapter = [NSNumber numberWithInt:totalChapters];
            m.new_updated_total = 0;
			m.thumbnail_url = thumbnailUrl;           
			m.summary = summary;
            //m.last_browsed_date = [NSDate date];
            //m.moChapters = [NSSet setWithArray:arrayChapter];
			NSString *alphabetical = [[name substringToIndex:1] uppercaseString];
			if ([alphabetical characterAtIndex:0] < 'A' || [alphabetical characterAtIndex:0] > 'Z') {
				alphabetical = @"#";
			}
			
            NSError *error;            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *chapterEntity = [NSEntityDescription entityForName:@"MoChapter" inManagedObjectContext:self.insertionContext];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"manga_id = %@",self->manga_id];
            NSArray *sortDescriptors = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"chapter_number" ascending:YES] autorelease]];
            
            [fetchRequest setEntity:chapterEntity];
            [fetchRequest setPredicate:predicate];
            [fetchRequest setFetchBatchSize:20];
            [fetchRequest setSortDescriptors:sortDescriptors];
            
            NSArray *result = [self.insertionContext executeFetchRequest:fetchRequest error:&error];            
            NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
            int count = 0;
            for (NSArray *item in arrayChapter) {
                NSString *cid = [item objectAtIndex:3] ;
                int chapterNumber = [[item objectAtIndex:0] intValue];
                NSString * name = [item objectAtIndex:2] ;
                if (name == (id) [NSNull null])
                {
                    name = [NSString stringWithFormat:@"Chapter: %i",chapterNumber];
                }
                BOOL isNeedToCreate = YES;
                //just update when already have property MoChapter
                if ([result count] != 0) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chapter_id = %d",cid];
                    NSArray *search = [result filteredArrayUsingPredicate:predicate];
                    if ([search count] > 0) {
                        MoChapter *c = [search objectAtIndex:0];
                        if ([c.name caseInsensitiveCompare:name] != NSOrderedSame) {
                            c.name = name;
                        }                      
                        isNeedToCreate = NO;
                    } 
                }
                if (isNeedToCreate) {
                    MoChapter *c = [[MoChapter alloc] initWithEntity:chapterEntity insertIntoManagedObjectContext:self.insertionContext];
                    c.chapter_id = cid;
                    c.chapter_number = [ NSNumber numberWithInt:chapterNumber];
                    c.name = name;
                   // c.total_page = [NSNumber numberWithInt:total_pages];
                    c.manga_id = self->manga_id;
                    c.moManga = m;
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
			m.alphabetical = alphabetical;
			isNeedToRefresh = YES;
            }
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
    
    
    //save array chapter id here
    
	return nil;
   
}

#pragma mark -
#pragma mark NSURLConnection Delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
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
