//
//  DOAppDelegate.m
//  Domo
//
//  Created by Alexander List on 6/25/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOAppDelegate.h"

@interface DOAppDelegate (){
    
}
-(void) setupMagicalRecord;

@end

@implementation DOAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupMagicalRecord];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	
	self.homeScreenVC = [[DOHomeScreenRootVC alloc] init];
	[self.window setRootViewController:self.homeScreenVC];
	
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) setupMagicalRecord{
    static NSString * storeName = @"domo.sqlite";
    #ifdef DEV_STATE_RESET
    NSURL *url = [NSPersistentStore MR_urlForStoreName:storeName];
    [[NSFileManager new] removeItemAtURL:url error:nil];
    #endif
    
	[MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:storeName];
    
    
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