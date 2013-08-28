//
//  DOSupportAreaChooserVC.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/27/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NITableViewModel.h"
#import "SupportArea.h"


@class DOSupportAreaChooserVC;

@protocol DOSupportAreaChooserVCDelegate <NSObject>
//states that the chooser is ready to hide
-(void) supportAreaChooserDidFinish:(DOSupportAreaChooserVC*)chooser;
-(void) supportAreaChooserDidSelectSupportArea:(SupportArea*)supportArea withChooser:(DOSupportAreaChooserVC*)chooser;

@end


@interface DOSupportAreaChooserVC : UIViewController <NITableViewModelDelegate, UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *chooserView;
@property (weak, nonatomic) IBOutlet UIView *chooserBackgroundView;

@property (nonatomic, strong) NSArray *			displayedObjects;
@property (nonatomic, strong) NITableViewModel*	tvModel;
@property (nonatomic, strong) NSFetchedResultsController * fetchController;
@property (nonatomic, strong) IBOutlet UITableView * tableView;


- (IBAction)chooserBackgroundViewTapped:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) id<DOSupportAreaChooserVCDelegate> delegate;


@end


@interface chooserBackgroundView : UIView
@end
