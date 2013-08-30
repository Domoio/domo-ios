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
    
    //if ready to submit
    
    [self performSubmitRequestAnimation];
    
    self.pendingAdviceRequest = nil; //load new advice request
    [self loadFromAdviceRequest:self.pendingAdviceRequest];
    
    [self.questionRequestContainerView setAlpha:0];
    [self.view addSubview:self.questionRequestContainerView];
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.questionRequestContainerView setAlpha:1];
    } completion:nil];
    
}

-(void) performSubmitRequestAnimation{
    CGSize paperSize = self.questionRequestContainerView.size; //CGSizeMake(self.questionRequestContainerView.size.width * [UIScreen mainScreen].scale,self.questionRequestContainerView.size.height * [UIScreen mainScreen].scale);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGAffineTransform twoXTransform = CGAffineTransformIdentity;
    twoXTransform = CGAffineTransformScale(twoXTransform, scale, scale);
    
    UIGraphicsBeginImageContextWithOptions(paperSize, NO, 0.0);
    [self.questionRequestContainerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect topThirdRect = CGRectMake(0, 0, paperSize.width, roundf(paperSize.height/3.3f)); //slightly smaller than a third
    UIImage* topThirdImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(viewImage.CGImage, CGRectApplyAffineTransform(topThirdRect, twoXTransform)) scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIImageView * topThirdImageView = [[UIImageView alloc] initWithImage:topThirdImage];
    topThirdImageView.layer.anchorPoint = CGPointMake(0.5, 1);
    [topThirdImageView setOrigin:CGPointMake(0, 0)]; //since our anchor is at bottom
    
    CGRect middleThirdRect = CGRectMake(0, topThirdRect.size.height, paperSize.width, roundf(paperSize.height/2.6f));//slightly bigger than all of them
    UIImage* middleThirdImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(viewImage.CGImage, CGRectApplyAffineTransform(middleThirdRect, twoXTransform)) scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIImageView * middleThirdImageView = [[UIImageView alloc] initWithImage:middleThirdImage ];
    [middleThirdImageView setOrigin:CGPointMake(0, topThirdRect.size.height)];
    
    CGFloat heightFromTopTwoThirds = topThirdRect.size.height + middleThirdRect.size.height;
    CGRect bottomThirdRect = CGRectMake(0, heightFromTopTwoThirds, paperSize.width, paperSize.height - heightFromTopTwoThirds);
    UIImage* bottomThirdImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(viewImage.CGImage, CGRectApplyAffineTransform(bottomThirdRect, twoXTransform)) scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIImageView * bottomThirdImageView = [[UIImageView alloc] initWithImage:bottomThirdImage];
    [bottomThirdImageView setOrigin:CGPointMake(0, heightFromTopTwoThirds)];
    bottomThirdImageView.layer.anchorPoint = CGPointMake(0.5, 0);
    [bottomThirdImageView setOrigin:CGPointMake(0, heightFromTopTwoThirds)];
    
    UIView * animateView = [[UIView alloc] initWithFrame:self.questionRequestContainerView.frame];
    //    [animateView setBackgroundColor:[self view].backgroundColor];
    [animateView addSubview:middleThirdImageView];
    [animateView addSubview:topThirdImageView];//folds above middle
    [animateView addSubview:bottomThirdImageView];
    
    [self.view addSubview:animateView];
    [self.questionRequestContainerView removeFromSuperview];
    
    [UIView animateWithDuration:0.65 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CATransform3D imageViewTransform = CATransform3DIdentity;
        imageViewTransform.m34 = 1.0 / -2000;
        imageViewTransform = CATransform3DRotate(imageViewTransform, 3.1415 * -2.0 * 180/360.0, 1, 0, 0);
        topThirdImageView.layer.transform = imageViewTransform;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.65 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CATransform3D imageViewTransform = CATransform3DIdentity;
            imageViewTransform.m34 = 1.0 / -2000;
            imageViewTransform = CATransform3DRotate(imageViewTransform, 3.1415 * 1.999 * 180/360.0, 1, 0, 0);
            bottomThirdImageView.layer.transform = imageViewTransform;
            
            
            //this used to be below 
            CATransform3D hideTransform = CATransform3DMakeScale(0.5f, 0.5f, 1);
            CGPoint hidePoint = CGPointMake(roundf(self.view.width/1.8f), self.view.height + 100);
            
            CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            pathAnimation.duration = .75;
            pathAnimation.calculationMode = kCAAnimationPaced;
            pathAnimation.fillMode = kCAFillModeForwards;
            pathAnimation.removedOnCompletion = NO;
            
            CGPoint viewOrigin = animateView.center;
            CGMutablePathRef curvedPath = CGPathCreateMutable();
            CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
            CGPathAddCurveToPoint(curvedPath, NULL, hidePoint.x, viewOrigin.y, hidePoint.x, viewOrigin.y, hidePoint.x, hidePoint.y);
            pathAnimation.path = curvedPath;
            CGPathRelease(curvedPath);
            
            [animateView.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
            
            [UIView animateWithDuration:pathAnimation.duration delay:.3 options:UIViewAnimationOptionCurveLinear animations:^{
                animateView.layer.transform = hideTransform;
            } completion:^(BOOL finished) {
                [animateView removeFromSuperview];
            }];

        } completion:^(BOOL finished) {
            //was here
            
        }];
    }];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
