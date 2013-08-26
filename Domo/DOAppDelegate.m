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

static NSString * seedDatabaseName = @"seedDatabase.sqlite";

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
    #if DEV_STATE_RESET == 1
    NSURL *url = [NSPersistentStore MR_urlForStoreName:storeName];
    [[NSFileManager new] removeItemAtURL:url error:nil];
    #endif
    
    #if DEV_MAKE_DB_SEED == 1
    #warning making a seed database, not fit for release
    [self generateSeedDatabase];
    exit(1);
    #endif
    
    
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:seedDatabaseName ofType:nil];
    
    //so if the seed was created dynamically let's use it
    if ([[NSFileManager defaultManager] fileExistsAtPath:seedPath] == TRUE){
        seedPath = [RKApplicationDataDirectory() stringByAppendingPathComponent:seedDatabaseName];
        #if IS_SHIPPING == 1
        #warning make sure that this isn't printed out!
        NSLog(@"Warning, dynamic seed at path used - compile and bundle b4 ship: %@", seedPath);
        #endif
    }
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:storeName];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
    [managedObjectStore createManagedObjectContexts];
    
    // Configure MagicalRecord to use RestKit's Core Data stack
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
    
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://domo-io-staging.herokuapp.com/apiv1/"]];
    objectManager.managedObjectStore = managedObjectStore;
    
    [RKObjectManager setSharedManager:objectManager];
    
    [self setObjectMappings];
    
    
}

-(void) setObjectMappings{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    
    //add this entity mapping for this class to a set of mappings for posting to a route
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[AdviceRequest requestMapping] objectClass:[AdviceRequest class] rootKeyPath:@"adviceRequest" method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:requestDescriptor];

    //add this class to a route for a post
    RKRoute * adviceUpdateRoute = [RKRoute routeWithClass:[AdviceRequest class] pathPattern:@"advice/:adviceRequestID" method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:adviceUpdateRoute];
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[AdviceRequest class] pathPattern:@"advice" method:RKRequestMethodPOST]];

    
    //create the RKResponseDescriptor connected to a mapping
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *adviceResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[AdviceRequest entityMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"adviceRequest" statusCodes:statusCodes]; //nil for all responses, adviceUpdateRoute.pathPattern
    [objectManager addResponseDescriptor:adviceResponseDescriptor];
    
}



-(void) generateSeedDatabase{
    //we'll do it all our way, the app will quit after anyway
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"https://domo-io-staging.herokuapp.com/apiv1/"]];
    objectManager.managedObjectStore = managedObjectStore;
    
    [RKObjectManager setSharedManager:objectManager];
    
    //importObjectsFromItemAtPath:withMapping:keyPath:error //for organizations keypath
    //importObjectsFromItemAtPath:withMapping:keyPath:error //for adviceRequests keypath
    


    NSString *seedPath = [RKApplicationDataDirectory() stringByAppendingPathComponent:seedDatabaseName];
    [[NSFileManager defaultManager] removeItemAtPath:seedPath error:nil];
    
    RKManagedObjectImporter *importer = [[RKManagedObjectImporter alloc] initWithManagedObjectModel:managedObjectModel storePath:seedPath];
    
    // Import the files "articles.json" from the Main Bundle using our RKEntityMapping
    // JSON looks like {"articles": [ {"title": "Article 1", "body": "Text", "author": "Blake" ]}
    NSError *error;
    [importer importObjectsFromItemAtPath:[[NSBundle mainBundle] pathForResource:@"domoDemoData" ofType:@"json"] withMapping:[AdviceRequest entityMapping] keyPath:@"adviceRequests" error:&error];
    [importer importObjectsFromItemAtPath:[[NSBundle mainBundle] pathForResource:@"domoDemoData" ofType:@"json"] withMapping:[Organization entityMapping] keyPath:@"organizations" error:&error];
    
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