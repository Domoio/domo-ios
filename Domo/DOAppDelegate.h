//
//  DOAppDelegate.h
//  Domo
//
//  Created by Alexander List on 6/25/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOHomeScreenRootVC.h"

@interface DOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) DOHomeScreenRootVC * homeScreenVC;

-(void) callInToServer;
@end
