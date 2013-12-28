//
//  DOAppDelegate.m
//  Domo
//
//  Created by Alexander List on 6/25/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

#import "AdviceRequest.h"
#import "Organization.h"
#import "Response.h"
#import "DOUpdater.h"

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
    [DOUpdater registerForNotificationsIfPushNotificationsActive];
    
    [self setupDatabases];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	
	self.homeScreenVC = [[DOHomeScreenRootVC alloc] init];
	[self.window setRootViewController:self.homeScreenVC];
	
    if ([[UIDevice currentDevice] systemVersion].doubleValue >= 7){
        [self.window setValue:[UIColor colorWithRed:22.0/255.0 green:154.0/255.0 blue:96.0/255.0 alpha:1] forKey:@"tintColor"];
    }
    
    [self.window makeKeyAndVisible];
        
    [self callInToServer];
    return YES;
}

-(void) callInToServer{
    RKObjectManager *manager = [RKObjectManager sharedManager];
                                
    [manager getObjectsAtPath:@"organizations" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        EXLog(@"The public call-in: %@", [result array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        EXLog(@"Whoops call-in failed: %@", [error description]);
    }];
    
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
    if ([[NSFileManager defaultManager] fileExistsAtPath:seedPath] == FALSE){
        seedPath = [RKApplicationDataDirectory() stringByAppendingPathComponent:seedDatabaseName];
        #if IS_SHIPPING == 1
        #warning make sure that this isn't printed out!
//        EXLog(@"Warning, dynamic seed at path used - compile and bundle b4 ship: %@", seedPath);
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
    
    
    BOOL isLocalDev = FALSE;
    NSString * apiHome = @"https://domoapis.herokuapp.com/api/v1/";
    if (isLocalDev)
        apiHome = @"http://localhost:3000/api/v1/";
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:apiHome]];
    objectManager.managedObjectStore = managedObjectStore;
    [objectManager setRequestSerializationMIMEType:RKMIMETypeJSON]; //every request body is json
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [RKObjectManager setSharedManager:objectManager];
    
    
    [self setObjectMappings];
    
    
}

-(void) setObjectMappings{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    
    //add this entity mapping for this class to a set of mappings for posting to a route
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[AdviceRequest requestMapping] objectClass:[AdviceRequest class] rootKeyPath:nil method:RKRequestMethodPOST];
    [objectManager addRequestDescriptor:requestDescriptor];

    //add this class to a route for a post
    RKRoute * adviceUpdateRoute = [RKRoute routeWithClass:[AdviceRequest class] pathPattern:@"organizations/:organization.urlFragment/advicerequest/:adviceRequestID?code=:organization.usersAuthCode" method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:adviceUpdateRoute];
    //add this class to a route for an organization
    RKRoute * adviceRequestPostRoute = [RKRoute routeWithClass:[AdviceRequest class] pathPattern:@"organizations/:organization.urlFragment/advicerequest?code=:organization.usersAuthCode" method:RKRequestMethodPOST];
    [objectManager.router.routeSet addRoute:adviceRequestPostRoute];

    //add this class to a route for an organization
    RKRoute * organizationUpdateRoute = [RKRoute routeWithClass:[Organization class] pathPattern:@"organizations/:urlFragment" method:RKRequestMethodGET];
    [objectManager.router.routeSet addRoute:organizationUpdateRoute];
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[Organization class] pathPattern:@"organizations" method:RKRequestMethodPOST]];



    
    
    NSIndexSet *successStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *organizationResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Organization entityMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"response.organizations" statusCodes:successStatusCodes]; //nil for all responses, adviceUpdateRoute.pathPattern
    [objectManager addResponseDescriptor:organizationResponseDescriptor];
    RKResponseDescriptor *organizationNestedDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Organization entityMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"organization" statusCodes:successStatusCodes]; //nil for all responses, adviceUpdateRoute.pathPattern
    [objectManager addResponseDescriptor:organizationNestedDescriptor];
    RKResponseDescriptor *oneOrganizationResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[Organization entityMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"response.organization" statusCodes:successStatusCodes]; //nil for all responses, adviceUpdateRoute.pathPattern
    [objectManager addResponseDescriptor:oneOrganizationResponseDescriptor];


    //create the RKResponseDescriptor connected to a mapping
    RKResponseDescriptor *adviceResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[AdviceRequest entityMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"advicerequest" statusCodes:successStatusCodes]; //nil for all responses, adviceUpdateRoute.pathPattern
    [objectManager addResponseDescriptor:adviceResponseDescriptor];
    RKResponseDescriptor *adviceNestedResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[AdviceRequest entityMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"response.advicerequest" statusCodes:successStatusCodes]; //nil for all responses, adviceUpdateRoute.pathPattern
    [objectManager addResponseDescriptor:adviceNestedResponseDescriptor];
    RKResponseDescriptor *adviceNestedPluralResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[AdviceRequest entityMapping] method:RKRequestMethodAny pathPattern:nil keyPath:@"response.advicerequests" statusCodes:successStatusCodes];
    [objectManager addResponseDescriptor:adviceNestedPluralResponseDescriptor];
    
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
    
    EXLog(@"SeedDB dropped at %@",seedPath);
}

#pragma mark push it, boy
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    [self.homeScreenVC.updater updateSubscriberIDWithPushNotificationID:hexToken];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [CSNotificationView showInViewController:self.window.rootViewController style:CSNotificationViewStyleError message:NSLocalizedString(@"Enabling push notifications failed, check your settings!", @"pushNotificationsFailed")];
    EXLog(@"Darn, push failed with error %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [[[UIAlertView alloc] initWithTitle:@"New Response" message:[NSString stringWithFormat:@"Checkout 'My Questions' to see more about: %@", [userInfo description]] delegate:nil cancelButtonTitle:@"Thanks Domo!" otherButtonTitles:nil] show];
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"badge"]){
        NSNumber * badgeNumber = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
        application.applicationIconBadgeNumber = badgeNumber.integerValue;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:shouldUpdateNewAdviceUINotification object:self];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    }
    [self.homeScreenVC.updater updateFromServer:TRUE];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
}

#pragma mark app life cycle
- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] postNotificationName:shouldUpdateNewAdviceUINotification object:self];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [self.homeScreenVC.updater updateFromServer:FALSE];
}

- (void)applicationWillTerminate:(UIApplication *)application{
      [MagicalRecord cleanUp];
}

@end