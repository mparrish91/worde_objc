//
//  AppDelegate.h
//  v2
//
//  Created by malcolm on 6/20/14.
//  Copyright (c) 2014 WordWise. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSArray *badWordArray;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+(AppDelegate*)instance;

@end

