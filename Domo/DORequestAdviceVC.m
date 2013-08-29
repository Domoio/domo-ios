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

-(void) validateAndOrSubmitQuestion;


-(void)loadFromAdviceRequest:(AdviceRequest*)request;
-(void)updateAdviceRequest:(AdviceRequest*)request;
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
    
    [self loadFromAdviceRequest:self.pendingAdviceRequest];
}

-(void)loadFromAdviceRequest:(AdviceRequest*)request{
    
    if ([request.requestContent length] > 0)
        [self.adviceRequestNoteView setText:request.requestContent];
}

-(void)updateAdviceRequest:(AdviceRequest*)request{
    request.requestContent = self.adviceRequestNoteView.text;
}


-(void) activeOrganizationUpdated:(NSNotification*)sender{
    
    Organization * activeOrganization = [Organization activeOrganization];
    
    [self.pendingAdviceRequest setOrganization:activeOrganization];
    
    if (activeOrganization){
        self.supportAreaLabel.textColor = [UIColor blackColor];

        self.communityLabel.text = [[Organization activeOrganization] displayName];
    }else{
        self.supportAreaLabel.textColor = [UIColor grayColor];

        self.communityLabel.text = NSLocalizedString(@"Choose Your Community", @"select a community label");
    }
    
    
    [self activeSupportAreaUpdated:nil];
}

-(void) activeSupportAreaUpdated:(NSNotification*)sender{
    
    SupportArea * activeSupportArea = [SupportArea activeSupportAreaForActiveOrganization];
    
    [self.pendingAdviceRequest setSupportArea:activeSupportArea];

    if (activeSupportArea){
        self.supportAreaLabel.text = [[SupportArea activeSupportAreaForActiveOrganization] name];
    }else{
        self.supportAreaLabel.text = NSLocalizedString(@"Select a knowledge area", @"select a knowledge area placeholder label");
        
    }
}

-(AdviceRequest*) pendingAdviceRequest{
    if (_pendingAdviceRequest == nil){
        AdviceRequest* savedAdviceRequest = [AdviceRequest currentEditingAdviceRequestForActiveOrganization];
        if (savedAdviceRequest == nil){
            _pendingAdviceRequest = [AdviceRequest MR_createEntity];
            [_pendingAdviceRequest setOrganization:[Organization activeOrganization]];
            [[NSManagedObjectContext contextForCurrentThread] save:nil];
        }else{
            _pendingAdviceRequest = savedAdviceRequest;
        }
    }
    return _pendingAdviceRequest;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // to update NoteView
    [self.adviceRequestNoteView setNeedsDisplay];
}

-(void) textViewDidChange:(UITextView *)textView{
    [self updateAdviceRequest:self.pendingAdviceRequest];
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
    
//    if ([self.pendingAdviceRequest isUpdated]){
    NSError * saveError = nil;
    [[NSManagedObjectContext defaultContext] save:&saveError];
    if (saveError){
        NSLog(@"darn, a save error. %@",saveError);
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
    [self validateAndOrSubmitQuestion];
}

-(void) validateAndOrSubmitQuestion{
    
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
