//
//  DOCommunityChooserVC.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/13/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Organization.h"
#import "NITableViewModel.h"
#import "DOCommunityChooserCodeEntryVC.h"
#import "DOShadedBackgroundView.h"
#import "DOIntroViewController.h"

@class DOCommunityChooserVC;

@protocol DOCommunityChooserVCDelegate <NSObject>
//states that the chooser is ready to hide
-(void) communityChooserDidFinish:(DOCommunityChooserVC*)chooser;
-(void) communityChooserDidSelectOrganization:(Organization*)organization withChooser:(DOCommunityChooserVC*)chooser;

-(void) domoInfoButtonTappedOnCommunityChooser:(DOCommunityChooserVC*)chooser;

@end

@interface DOCommunityChooserVC : UIViewController <NITableViewModelDelegate, UITableViewDelegate,NSFetchedResultsControllerDelegate, DOCommunityChooserCodeEntryVCDelegate>{
    void (^updateAndDismissBlock)(void);
}
@property (weak, nonatomic) IBOutlet UITextField *communityNameTextField;
@property (weak, nonatomic) IBOutlet UIView *communityChooserView;
@property (weak, nonatomic) IBOutlet UIView *communityChooserBackgroundView;

@property (nonatomic, strong) NSArray *			displayedObjects;
@property (nonatomic, strong) NITableViewModel*	tvModel;
@property (nonatomic, strong) NSFetchedResultsController * fetchController;
@property (nonatomic, strong) IBOutlet UITableView * tableView;

@property (nonatomic, strong) DOCommunityChooserCodeEntryVC * codeEntryVC;


- (IBAction)communityChooserBackgroundViewTapped:(UITapGestureRecognizer *)sender;
- (IBAction)communityNameTextFieldChanged:(id)sender;
- (IBAction)domoInfoButtonTapped:(id)sender;



@property (weak, nonatomic) id<DOCommunityChooserVCDelegate> delegate;


@end

