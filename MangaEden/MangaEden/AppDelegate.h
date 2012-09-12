//
//  AppDelegate.h
//  MangaEden
//
//  Created by Cuccku on 8/24/12.
//  Copyright (c) 2012 Cuccku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
enum {
	AppReachabilityReachable = 0,
	AppReachabilityNotReachable
};
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

//core data
@property (strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//network reachability
@property (strong) Reachability* internetReach;
@property (assign) NetworkStatus currentNetworkStatus;


- (NSString *)stringApplicationDocumentsDirectory;
- (NSURL *)urlApplicationDocumentsDirectory;
- (BOOL)backgroundSupported;
- (void)updateReachability:(Reachability *)curReach;
- (void)retainNetworkIndicator;
- (void)releaseNetworkIndicator;


@end
