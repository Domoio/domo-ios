//
//  DOAppDelegate.m
//  Domo
//
//  Created by Alexander List on 6/25/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOAppDelegate.h"

#import "AdviceRequest.h"
#import "Organization.h"
#import "Response.h"

@interface DOAppDelegate (){
    
}
-(void) setupDatabases;
-(void) setObjectMappings;

@end


// Use a class extension to expose access to MagicalRecord's private setter methods
@interface NSManagedObjectContext ()
+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;
@end


@implementation DOAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupDatabases];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	
	self.homeScreenVC = [[DOHomeScreenRootVC alloc] init];
	[self.window setRootViewController:self.homeScreenVC];
	
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) setupDatabases{
    
    static NSString * storeName = @"domo.sqlite";
    #ifdef DEV_STATE_RESET
    NSURL *url = [NSPersistentStore MR_urlForStoreName:storeName];
    [[NSFileManager new] removeItemAtURL:url error:nil];
    #endif

    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:storeName];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    [managedObjectStore createManagedObjectContexts];
    
    // Configure MagicalRecord to use RestKit's Core Data stack
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
    
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://domo-io-staging.herokuapp.com/apiv1/"]];
    [RKObjectManager setSharedManager:objectManager];
    
    [self setObjectMappings];
    
    objectManager.managedObjectStore = managedObjectStore;
    
}

-(void) setObjectMappings{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    //create a mapping btw class and data
    RKEntityMapping * adviceRequestMapping = [AdviceRequest entityMapping];
    
    //add this entity mapping for this class to a set of mappings for posting to a route
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:adviceRequestMapping objectClass:[AdviceRequest class] rootKeyPath:@"adviceRequest" method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:requestDescriptor];

    //add this class to a route for a post
    RKRoute * adviceUpdateRoute = [RKRoute routeWithClass:[AdviceRequest class] pathPattern:@"advice/:adviceRequestID" method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:adviceUpdateRoute];
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[AdviceRequest class] pathPattern:@"advice" method:RKRequestMethodPOST]];

    
    //create the RKResponseDescriptor connected to a mapping
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *adviceResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:adviceRequestMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"adviceRequest" statusCodes:statusCodes]; //nil for all responses, adviceUpdateRoute.pathPattern
    [objectManager addResponseDescriptor:adviceResponseDescriptor];
    
}

-(void) generateSeedDatabase{
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    
    //importObjectsFromItemAtPath:withMapping:keyPath:error //for organizations keypath
    //importObjectsFromItemAtPath:withMapping:keyPath:error //for adviceRequests keypath

    NSString *seedPath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"seedDatabase.sqlite"];
    RKManagedObjectImporter *importer = [[RKManagedObjectImporter alloc] initWithManagedObjectModel:objectManager.managedObjectStore.managedObjectModel storePath:seedPath];
    
    // Import the files "articles.json" from the Main Bundle using our RKEntityMapping
    // JSON looks like {"articles": [ {"title": "Article 1", "body": "Text", "author": "Blake" ]}
    NSError *error;
    NSBundle *mainBundle = [NSBundle mainBundle];
    [importer importObjectsFromItemAtPath:[mainBundle pathForResource:@"domoDemoData" ofType:@"json"]
                              withMapping:[AdviceRequest entityMapping]
                                  keyPath:@"adviceRequests"
                                    error:&error];
    
    BOOL success = [importer finishImporting:&error];
    if (success) {
        [importer logSeedingInfo];
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
}

- (void)applicationWillTerminate:(UIApplication *)application{
      [MagicalRecord cleanUp];
}

@end