//
//  DOCommunityChooserCodeEntryVC.m
//  Domo
//
//  Created by Alexander Hoekje List on 9/18/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOCommunityChooserCodeEntryVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation DOCommunityChooserCodeEntryVC

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"DOCommunityChooserCodeEntryVC-iPhone" bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
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

-(void) beginEnteredCodeValidation{

    NSString * code = [self.codeEntryTextField text];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];

    DOCommunityChooserCodeEntryVC * __weak weakSelf = self;
    [objectManager getObject:self.evaluatingOrganization path:RKPathFromPatternWithObject(@"/api/v1/organizations/:urlFragment/codecheck", self.evaluatingOrganization)  parameters:@{@"code": code} success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"Retreived: %@", [result array]);
        if ([[self.evaluatingOrganization usersAuthCode] isEqualToString:code]) {
            NSLog(@"SUCCESS %@", @"YO");
            [weakSelf.delegate codeEntryVCDidCompleteSuccesfull:self];
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failed: %@", [error description]);
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
    
}

@end
