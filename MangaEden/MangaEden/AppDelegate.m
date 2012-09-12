//
//  AppDelegate.m
//  MangaEden
//
//  Created by Cuccku on 8/24/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"

#import "CategoryViewController.h"
NSString *const kAppReachibilityNotification = @"kAppReachibilityNotification";
@implementation AppDelegate
@synthesize internetReach, currentNetworkStatus;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //init data
    if ([AppSettings lastUpdate] == 0) {
		//delete DB file, to prevent data corruption if app quit halfway while importing
		NSString *storePath = [[self stringApplicationDocumentsDirectory] stringByAppendingPathComponent:@"MangaDataStore.sqlite"];
		if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
			NSError *error;
			[[NSFileManager defaultManager] removeItemAtPath:storePath error:&error];
			[AppSettings setLastUpdate:0];
		}
	}
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    HomeViewController *homeViewController;
    UIViewController  *viewController2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone" bundle:nil];
        viewController2 = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController_iPhone" bundle:nil];
    } else {
        homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController_iPad" bundle:nil];
        viewController2 = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController_iPad" bundle:nil];
    }
    homeViewController.managedObjectContext = self.managedObjectContext;
    homeViewController.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[homeViewController, viewController2];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/
#pragma mark -
#pragma mark Reachability
//Called by Reachability whenever status changes.
- (void)reachabilityChanged:(NSNotification* )note {
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateReachability:curReach];
   
}

BOOL allowedToShowAlert = YES;

- (void)turnOnAllowedToShowAlert {
	allowedToShowAlert = YES;
}

- (void)updateReachability:(Reachability *)curReach {
	
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	
	if ((curReach == self.internetReach) && (netStatus != self.currentNetworkStatus)) {
		switch (netStatus)
		{
			case NotReachable:
			{
				DLog(@"REACHABILITY: no internet");
				self.currentNetworkStatus = netStatus;
				NSArray *objectsToSend = [NSArray arrayWithObject:[NSNumber numberWithInt:AppReachabilityNotReachable]];
				[[NSNotificationCenter defaultCenter] postNotificationName: kAppReachibilityNotification object:objectsToSend];
				
				break;
			}
			case ReachableViaWWAN:
			{
				DLog(@"REACHABILITY: WWAN");
				
				if (currentNetworkStatus == NotReachable) {
					self.currentNetworkStatus = netStatus;
					NSArray *objectsToSend = [NSArray arrayWithObject:[NSNumber numberWithInt:AppReachabilityReachable]];
					[[NSNotificationCenter defaultCenter] postNotificationName: kAppReachibilityNotification object:objectsToSend];
				}
				break;
			}
			case ReachableViaWiFi:
			{
			
				if (currentNetworkStatus == NotReachable) {
					self.currentNetworkStatus = netStatus;
					NSArray *objectsToSend = [NSArray arrayWithObject:[NSNumber numberWithInt:AppReachabilityReachable]];
					[[NSNotificationCenter defaultCenter] postNotificationName: kAppReachibilityNotification object:objectsToSend];
				}
				break;
			}
		}
	}
}

#pragma mark -
#pragma mark other
- (BOOL)backgroundSupported{
	UIDevice* device = [UIDevice currentDevice];
	BOOL backgroundSupported = NO;
	if ([device respondsToSelector:@selector(isMultitaskingSupported)]){
		backgroundSupported = device.multitaskingSupported;
	}
	return backgroundSupported;
}



#pragma mark -
#pragma mark Network Activity Indicator

int networkIndicatorRetainCount = 0;

- (void)retainNetworkIndicator {
	if ([NSThread mainThread]) {
		networkIndicatorRetainCount++;
		//NSLog(@"networkIndicatorRetainCount = %d",networkIndicatorRetainCount);
		if (networkIndicatorRetainCount > 0) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		}
	} else {
		[self performSelectorOnMainThread:@selector(retainNetworkIndicator) withObject:nil waitUntilDone:NO];
	}
	
}

- (void)releaseNetworkIndicator {
	if ([NSThread mainThread]) {
		networkIndicatorRetainCount--;
		//NSLog(@"networkIndicatorRetainCount = %d",networkIndicatorRetainCount);
		if (networkIndicatorRetainCount <= 0) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			if (networkIndicatorRetainCount < 0) {
				DLog(@"networkIndicator < 0");
			}
		}
	} else {
		[self performSelectorOnMainThread:@selector(releaseNetworkIndicator) withObject:nil waitUntilDone:NO];
	}
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MangaDataStore" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    //NSURL *storeURLDirectory = (NSURL*) [self applicationDocumentsDirectory];
    NSURL *storeURL = [(NSURL*) [self urlApplicationDocumentsDirectory] URLByAppendingPathComponent:@"MangaDataStore.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}
#pragma mark -
#pragma mark Application's Documents directory
- (NSString *)stringApplicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)urlApplicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
