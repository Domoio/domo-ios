//
//  DOHomeScreenRootVC.m
//  Domo
//
//  Created by Alexander List on 6/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOHomeScreenRootVC.h"
#import <QuartzCore/QuartzCore.h>

@interface DOHomeScreenRootVC ()

@end

@implementation DOHomeScreenRootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DOHomeScreenRootVC-iPhone" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"patternsquare_green.png"]]];
	
	[self.mainContentScrollView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
	[self.mainContentScrollView setPagingEnabled:TRUE];

	self.welcomeCommunityHeader = [[DOWelcomeAndCommunityVC alloc] initWithNibName:nil bundle:nil];
	self.welcomeCommunityHeader.view.layer.shadowColor = UIColor.blackColor.CGColor;
	self.welcomeCommunityHeader.view.layer.shadowOffset = CGSizeZero;
	self.welcomeCommunityHeader.view.layer.shadowOpacity = 0.2;
	self.welcomeCommunityHeader.view.layer.shadowRadius = 2;
	
	self.requestAdviceVC = [[DORequestAdviceVC alloc] initWithNibName:nil bundle:nil];

	CGFloat handleHeight = 50;
	CGFloat yOriginOfAskAdviceHandle = self.myQuestionsPeakView.frame.origin.y - handleHeight /* above the myquestions handle */;
	CGFloat totalHeight = yOriginOfAskAdviceHandle + self.requestAdviceVC.view.frame.size.height;
	[self.mainContentScrollView setContentSize:CGSizeMake(320, totalHeight)];
	[self.mainContentScrollView addSubview:self.welcomeCommunityHeader.view];
	
	[self.requestAdviceVC.view setOrigin:CGPointMake(0,yOriginOfAskAdviceHandle)];
	[self.mainContentScrollView addSubview:self.requestAdviceVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
