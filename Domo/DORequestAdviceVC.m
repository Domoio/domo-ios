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
@end

@implementation DORequestAdviceVC{
	NSString * placeholderText;
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
	[self.adviceRequestNoteView setDelegate:self];

    
    [self activeOrganizationUpdated:self];
    
    //respond to notification about org change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeOrganizationUpdated:) name:activeOrganizationChangedNotification object:nil];
}

-(void) activeOrganizationUpdated:(NSNotification*)sender{
    self.communityLabel.text = [[Organization activeOrganization] displayName];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)supportAreaChooserButtonPressed:(id)sender {
}

- (IBAction)askButtonPressed:(id)sender {
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
