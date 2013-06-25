//
//  DOAppDelegate.h
//  Domo
//
//  Created by Alexander List on 6/25/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
