//
//  DOWelcomeAndCommunityVC.m
//  Domo
//
//  Created by Alexander List on 6/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOWelcomeAndCommunityVC.h"

@interface DOWelcomeAndCommunityVC ()

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseCommunityButtonPressed:(id)sender {
    [self.delegate welcomeAndCommunityVCWantsDisplayCommunityChooser:self];
}
@end
