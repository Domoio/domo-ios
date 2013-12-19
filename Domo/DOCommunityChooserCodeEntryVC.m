//
//  DOCommunityChooserCodeEntryVC.m
//  Domo
//
//  Created by Alexander Hoekje List on 9/18/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOCommunityChooserCodeEntryVC.h"
#import <QuartzCore/QuartzCore.h>

@interface DOCommunityChooserCodeEntryVC(){
    BOOL canSubmit;
}
@end

@implementation DOCommunityChooserCodeEntryVC

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"DOCommunityChooserCodeEntryVC-iPhone" bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void)updateUIForOrg{
    NSString * orgPrompt = [NSString stringWithFormat:NSLocalizedString(@"Enter the Domo code for %@", @"domo code entry prompt"), self.evaluatingOrganization.displayName];
    
    [self.domoCodePromptLabel setText:orgPrompt];
    [self.codeEntryTextField setText:self.evaluatingOrganization.usersAuthCode];
    
}

- (IBAction)codeEntryTextFieldContentChanged:(id)sender {
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate codeEntryVCDidCancel:self];
}

- (IBAction)sendButtonPressed:(id)sender {
    [self beginEnteredCodeValidation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self beginEnteredCodeValidation];
    return FALSE;
}

-(void) setEvaluatingOrganization:(Organization *)evaluatingOrganization{
    _evaluatingOrganization = evaluatingOrganization;
    [self updateUIForOrg];
}

-(void)enableSubmit{
    [self.sendButton setEnabled:TRUE];
    [self.sendButton setAlpha:1];
    canSubmit = TRUE;
}

-(void)disableSubmit{
    [self.sendButton setEnabled:FALSE];
    [self.sendButton setAlpha:.7];
    canSubmit = FALSE;
}

-(void) beginEnteredCodeValidation{
    if (canSubmit == FALSE)
        return;
    
    [self disableSubmit];

    NSString * code = [self.codeEntryTextField text];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    DOCommunityChooserCodeEntryVC * __weak weakSelf = self;
    [objectManager getObject:self.evaluatingOrganization path:RKPathFromPatternWithObject(@"/api/v1/organizations/:urlFragment/codecheck", self.evaluatingOrganization)  parameters:@{@"code": code} success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"Retreived: %@", [result array]);
        if ([[weakSelf.evaluatingOrganization usersAuthCode] isEqualToString:code]) {
            NSLog(@"SUCCESS %@", @"YO");
            [weakSelf.delegate codeEntryVCDidCompleteSuccesfull:weakSelf];
            [weakSelf enableSubmit];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        if (error.domain == NSURLErrorDomain){
            [CSNotificationView showInViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] style:CSNotificationViewStyleError message:NSLocalizedString(@"Server connection failed!", @"serverConnectionFailed")];
        }
        
        NSLog(@"failed: %@", [error description]);
        
        [UIView wiggleView:weakSelf.codeEntryTextField completion:^(BOOL finished) {
            [weakSelf enableSubmit];
        }];
        
    }];
    
}

-(void) viewDidLoad{
    [super viewDidLoad];

    self.view.layer.cornerRadius = 2;
    self.view.layer.shadowRadius = 8;
    
    self.codeEntryTextField.layer.borderColor = [UIColor colorWithWhite:0.55 alpha:0.15].CGColor;
    self.codeEntryTextField.layer.borderWidth = 1;
    self.codeEntryTextField.layer.cornerRadius = 10;
    [self.codeEntryTextField setTextColor:[UIColor darkGrayColor]];
    
    [self enableSubmit];
}

@end
