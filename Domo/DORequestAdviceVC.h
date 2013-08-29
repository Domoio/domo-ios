//
//  DORequestAdviceVC.h
//  Domo
//
//  Created by Alexander List on 6/25/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"
#import "Organization.h"
#import "AdviceRequest.h"

@class DORequestAdviceVC;

@protocol DORequestAdviceVCDelegate <NSObject>
- (void) requestAdviceVCWantsDisplaySupportAreaChooser:(DORequestAdviceVC*)viewController;
@end


@interface DORequestAdviceVC : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) IBOutlet UIView * questionRequestContainerView;
@property (weak, nonatomic) IBOutlet UILabel *communityLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportAreaLabel;

@property (strong, nonatomic) AdviceRequest * pendingAdviceRequest;

@property (weak, nonatomic) id<DORequestAdviceVCDelegate> delegate;

@property (nonatomic, strong) IBOutlet NoteView * adviceRequestNoteView;

- (IBAction)supportAreaChooserButtonPressed:(id)sender;
- (IBAction)askButtonPressed:(id)sender;
@end
