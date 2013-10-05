//
//  DOWelcomeAndCommunityVC.m
//  Domo
//
//  Created by Alexander List on 6/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOWelcomeAndCommunityVC.h"

@interface DOWelcomeAndCommunityVC ()
-(void) activeOrganizationUpdated:(id)sender;
@end

@implementation DOWelcomeAndCommunityVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DOWelcomeAndCommunityVC-iPhone" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self activeOrganizationUpdated:self];
    //respond to notification about org change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeOrganizationUpdated:) name:activeOrganizationChangedNotification object:nil];

}

-(void) activeOrganizationUpdated:(id)sender{
    if ([Organization activeOrganization]){
         self.communityLabel.text = [[Organization activeOrganization] displayName];
    }else{
        self.communityLabel.text = NSLocalizedString(@"Choose Your Community", @"select a community label");

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseCommunityButtonPressed:(id)sender {
    [self.delegate welcomeAndCommunityVCWantsDisplayCommunityChooser:self];
}

- (IBAction)communityLabelTapped:(id)sender {
    [self.delegate welcomeAndCommunityVCWantsDisplayCommunityChooser:self];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
