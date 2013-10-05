//
//  DOWelcomeAndCommunityVC.h
//  Domo
//
//  Created by Alexander List on 6/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization.h"

@class DOWelcomeAndCommunityVC;

@protocol DOWelcomeAndCommunityVCDelegate <NSObject>
- (void) welcomeAndCommunityVCWantsDisplayCommunityChooser:(DOWelcomeAndCommunityVC*)viewController;
@end

@interface DOWelcomeAndCommunityVC : UIViewController
- (IBAction)chooseCommunityButtonPressed:(id)sender;
- (IBAction)communityLabelTapped:(id)sender;

@property (weak, nonatomic) id<DOWelcomeAndCommunityVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *communityLabel;


@end
