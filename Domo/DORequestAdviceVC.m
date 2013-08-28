//
//  DORequestAdviceVC.m
//  Domo
//
//  Created by Alexander List on 6/25/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DORequestAdviceVC.h"
#import <QuartzCore/QuartzCore.h>
@interface DORequestAdviceVC ()
-(void) activeOrganizationUpdated:(id)sender;
-(void) activeSupportAreaUpdated:(id)sender;

@end

@implementation DORequestAdviceVC{
	NSString * placeholderText;
	UIColor * placeholderTextColor;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DORequestAdviceVC-iPhone" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.questionRequestContainerView.layer.borderColor = [UIColor colorWithWhite:0.55 alpha:0.15].CGColor;
	self.questionRequestContainerView.layer.borderWidth = 1;
	self.questionRequestContainerView.layer.cornerRadius = 3;

	placeholderText = self.adviceRequestNoteView.text;
    placeholderTextColor = self.adviceRequestNoteView.textColor;
	[self.adviceRequestNoteView setDelegate:self];

    
    [self activeOrganizationUpdated:nil];
    [self activeSupportAreaUpdated:nil];
    
    //respond to notification about org change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeOrganizationUpdated:) name:activeOrganizationChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeSupportAreaUpdated:) name:activeSupportAreaChangedNotification object:nil];
}

-(void) activeOrganizationUpdated:(NSNotification*)sender{
    if ([Organization activeOrganization]){
        self.supportAreaLabel.textColor = [UIColor blackColor];

        self.communityLabel.text = [[Organization activeOrganization] displayName];
    }else{
        self.supportAreaLabel.textColor = [UIColor grayColor];

        self.communityLabel.text = NSLocalizedString(@"Choose Your Community", @"select a community label");
    }
    
    [self activeSupportAreaUpdated:nil];
}

-(void) activeSupportAreaUpdated:(NSNotification*)sender{
    

    if ([SupportArea activeSupportAreaForActiveOrganization]){
        self.supportAreaLabel.text = [[SupportArea activeSupportAreaForActiveOrganization] name];
    }else{
        self.supportAreaLabel.text = NSLocalizedString(@"Select a knowledge area", @"select a knowledge area placeholder label");
        
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // to update NoteView
    [self.adviceRequestNoteView setNeedsDisplay];
}

- (void) textViewDidBeginEditing:(UITextView *)textView{
	if ([placeholderText isEqualToString:self.adviceRequestNoteView.text]){
		[self.adviceRequestNoteView setText:@""];
		[self.adviceRequestNoteView setTextColor:UIColor.blackColor];
	}
}

-(void) textViewDidEndEditing:(UITextView *)textView{
    if ([[self.adviceRequestNoteView text] isEqualToString:@""]){
        self.adviceRequestNoteView.text = placeholderText;
        self.adviceRequestNoteView.textColor = placeholderTextColor;
    }
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)supportAreaChooserButtonPressed:(id)sender {
    [self.delegate requestAdviceVCWantsDisplaySupportAreaChooser:self];
}

- (IBAction)askButtonPressed:(id)sender {
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
