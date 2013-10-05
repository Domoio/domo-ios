//
//  DOCommunityChooserCodeEntryVC.h
//  Domo
//
//  Created by Alexander Hoekje List on 9/18/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Organization.h"

@class DOCommunityChooserCodeEntryVC;
@protocol DOCommunityChooserCodeEntryVCDelegate <NSObject>
-(void) codeEntryVCDidCancel:(DOCommunityChooserCodeEntryVC*)vc;
-(void) codeEntryVCDidCompleteSuccesfull:(DOCommunityChooserCodeEntryVC*)vc;

@end

@interface DOCommunityChooserCodeEntryVC : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *domoCodePromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLocationHintLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeEntryTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) id<DOCommunityChooserCodeEntryVCDelegate> delegate;

@property (nonatomic, strong) Organization * evaluatingOrganization;

- (IBAction)codeEntryTextFieldContentChanged:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sendButtonPressed:(id)sender;

-(void) beginEnteredCodeValidation;
@end
