//
//  DOCommunityChooserVC.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/13/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Organization.h"

@class DOCommunityChooserVC;

@protocol DOCommunityChooserVCDelegate <NSObject>
//states that the chooser is ready to hide
-(void) communityChooserDidFinish:(DOCommunityChooserVC*)chooser;
-(void) communityChooserDidSelectOrganization:(Organization*)organization withChooser:(DOCommunityChooserVC*)chooser;

@end

@interface DOCommunityChooserVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *communityNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *communityChooserTableView;
@property (weak, nonatomic) IBOutlet UIView *communityChooserView;
@property (weak, nonatomic) IBOutlet UIView *communityChooserBackgroundView;


- (IBAction)communityChooserBackgroundViewTapped:(UITapGestureRecognizer *)sender;

@end
