//
//  DOHomeScreenRootVC.m
//  Domo
//
//  Created by Alexander List on 6/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOHomeScreenRootVC.h"
#import <QuartzCore/QuartzCore.h>
#import "UIResponder+FirstResponder.h"

@interface DOHomeScreenRootVC (){
	float originalMyQuestionsDistanceFromBottom;
	float askAdviceDisplayedOrigin;
    
    float peakViewHeightPortrait;
    float peakViewHeightLandscape;
}
@end

const float myQuestionsDisplayedPosition = 20;
const float askAdviceHandleHeight = 48;

@implementation DOHomeScreenRootVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DOHomeScreenRootVC-iPhone" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL) mainGetAdviceTrayIsScrolledToTop{
	return ([self.mainContentScrollView contentOffset].y == CGPointZero.y);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"patternsquare_green.png"]]];
	
	
	[self.mainContentScrollView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
	[self.mainContentScrollView setPagingEnabled:TRUE];
	[self.mainContentScrollView setDelegate:self];

	self.welcomeCommunityHeader = [[DOWelcomeAndCommunityVC alloc] initWithNibName:nil bundle:nil];
    self.welcomeCommunityHeader.delegate = self;
	self.welcomeCommunityHeader.view.layer.shadowColor = UIColor.blackColor.CGColor;
	self.welcomeCommunityHeader.view.layer.shadowOffset = CGSizeMake(0, 1);
	self.welcomeCommunityHeader.view.layer.shadowOpacity = 0.2;
	self.welcomeCommunityHeader.view.layer.shadowRadius = 2;
	self.welcomeCommunityHeader.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.welcomeCommunityHeader.view.bounds].CGPath;;
	
	self.requestAdviceVC = [[DORequestAdviceVC alloc] initWithNibName:nil bundle:nil];
    self.requestAdviceVC.delegate = self;
	self.requestAdviceVC.view.layer.shadowColor = UIColor.blackColor.CGColor;
	self.requestAdviceVC.view.layer.shadowOffset = CGSizeMake(0, 1);
	self.requestAdviceVC.view.layer.shadowOpacity = 0.2;
	self.requestAdviceVC.view.layer.shadowRadius = 2;
	self.requestAdviceVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.requestAdviceVC.view.bounds].CGPath;;


	CGFloat yOriginOfAskAdviceHandle = self.myQuestionsPeakView.frame.origin.y - askAdviceHandleHeight /* above the myquestions handle */;
	CGFloat totalHeight = yOriginOfAskAdviceHandle + self.requestAdviceVC.view.frame.size.height;

	[self.mainContentScrollView setContentSize:CGSizeMake(320, totalHeight)];
	[self.mainContentScrollView addSubview:self.welcomeCommunityHeader.view];
	
	[self.requestAdviceVC.view setOrigin:CGPointMake(0,yOriginOfAskAdviceHandle)];
	[self.mainContentScrollView addSubview:self.requestAdviceVC.view];
	
	askAdviceDisplayedOrigin = self.requestAdviceVC.view.origin.y;

	
	self.myQuestionsVC = [[DOMyQuestionsVC alloc] init];
	[self.myQuestionsPeakView addSubview:self.myQuestionsVC.view];
	self.myQuestionsPeakView.layer.shadowColor = UIColor.blackColor.CGColor;
	self.myQuestionsPeakView.layer.shadowOffset = CGSizeMake(0, -1);
	self.myQuestionsPeakView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.myQuestionsPeakView.bounds].CGPath;
	
	//Gesture recognizers
	UITapGestureRecognizer * adviceRequestTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adviceRequestTapRecognizerDidTap:)];
	[self.requestAdviceVC.view addGestureRecognizer:adviceRequestTapRecognizer];
	
	UIPanGestureRecognizer * myQuestionsPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(myQuestionsPanGestureRecognizerDidPan:)];
	[self.myQuestionsPeakView addGestureRecognizer:myQuestionsPanGestureRecognizer];
	UITapGestureRecognizer * myQuestionsTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myQuestionsTapRecognizerDidTap:)];
	[self.myQuestionsPeakView addGestureRecognizer:myQuestionsTapRecognizer];

    //let's KVC for peak view, so we can set shadow radius based on origin
    [self.myQuestionsPeakView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	if (originalMyQuestionsDistanceFromBottom == 0){
        // interestingly, actually not interesting but just true
        // the view autosizing only kicks-in sometime after viewdidload
        // thus, this is where post-load sizing needs to occur
        
        
		originalMyQuestionsDistanceFromBottom = self.view.height - self.myQuestionsPeakView.origin.y;
        
        CGFloat yOriginOfAskAdviceHandle = self.myQuestionsPeakView.frame.origin.y - askAdviceHandleHeight /* above the myquestions handle */;
        CGFloat totalHeight = yOriginOfAskAdviceHandle + self.requestAdviceVC.view.frame.size.height;

        [self.mainContentScrollView setContentSize:CGSizeMake(320, totalHeight)];
        [self.mainContentScrollView addSubview:self.welcomeCommunityHeader.view];
        
        [self.requestAdviceVC.view setOrigin:CGPointMake(0,yOriginOfAskAdviceHandle)];
        
        [self setupPeakViewForCurrentOrientation];
	}
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self setupPeakViewForCurrentOrientation];
}

-(void) setupPeakViewForCurrentOrientation{
    if (orientationIsPortrait){
        peakViewHeightPortrait = self.view.height - myQuestionsDisplayedPosition;
        
        CGSize peakViewSize = self.myQuestionsPeakView.size;
        peakViewSize.height = peakViewHeightPortrait;
        self.myQuestionsPeakView.size = peakViewSize;
    }else{
        peakViewHeightLandscape = 320 - myQuestionsDisplayedPosition -20; //hard code=lame = wtf apple why doesn't this auto size? (status bar = 20)
        
        CGSize peakViewSize = self.myQuestionsPeakView.size;
        peakViewSize.height = peakViewHeightLandscape;
        self.myQuestionsPeakView.size = peakViewSize;
    }

}



-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[[[UIResponder new] currentFirstResponder] resignFirstResponder];
}

-(void) adviceRequestTapRecognizerDidTap:(UITapGestureRecognizer*)tapGesture{
    if ([tapGesture locationInView:self.requestAdviceVC.view].y > 60)
        return;

	if (tapGesture.state == UIGestureRecognizerStateRecognized){
		if ([self mainGetAdviceTrayIsScrolledToTop]){

			[self.mainContentScrollView setContentOffset:CGPointMake(0, askAdviceDisplayedOrigin) animated:TRUE];
			
		}else{
            
			[self.mainContentScrollView setPagingEnabled:FALSE]; //a hack because our page height is weird
			[self.mainContentScrollView setContentOffset:CGPointMake(0, 0) animated:TRUE];
			double delayInSeconds = 0.5;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
				[self.mainContentScrollView setPagingEnabled:TRUE];
			});
		}
	}
}

-(void) myQuestionsPanGestureRecognizerDidPan:(UIPanGestureRecognizer*)panRecognizer{

	
	static CGFloat _firstXMyQuestions;
	static CGFloat _firstYMyQuestions;
	
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)panRecognizer translationInView:self.view];
	
    if([(UIPanGestureRecognizer*)panRecognizer state] == UIGestureRecognizerStateBegan) {
		
        _firstXMyQuestions = [[panRecognizer view] origin].x;
        _firstYMyQuestions = [[panRecognizer view] origin].y;
		
    }
	
	translatedPoint = CGPointMake(_firstXMyQuestions, _firstYMyQuestions+translatedPoint.y);
	if(translatedPoint.y < myQuestionsDisplayedPosition) {
		translatedPoint.y = myQuestionsDisplayedPosition;
	}

	
    [[panRecognizer view] setOrigin:translatedPoint];
	
    if([(UIPanGestureRecognizer*)panRecognizer state] == UIGestureRecognizerStateEnded) {
        CGFloat velocityY = (0.2*[(UIPanGestureRecognizer*)panRecognizer velocityInView:self.view].y);
		
        CGFloat finalX = _firstXMyQuestions;
        CGFloat finalY = translatedPoint.y + velocityY;
        if(finalY < _firstYMyQuestions) {
			finalY = myQuestionsDisplayedPosition;
        }
        else if(finalY > _firstYMyQuestions) {
			finalY = [self peekViewRestingYLocation];
        }
		
        CGFloat animationDuration = (ABS(velocityY)*.0002)+.2;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
        [[panRecognizer view] setOrigin:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
    }
	
	[self updateMyQuestionsViewForScrollState];
}

-(void) updateMyQuestionsViewForScrollState{
	if ([self myQuestionsIsDisplayed]){

	}else{
		self.myQuestionsPeakView.layer.shadowOpacity = 0;		
	}
}

-(float) peekViewRestingYLocation{
	float finalY = self.view.height - originalMyQuestionsDistanceFromBottom;
	
	if (UIDeviceOrientationIsLandscape( [UIApplication sharedApplication].statusBarOrientation)){
		finalY = 320 - originalMyQuestionsDistanceFromBottom - 20;
	}
	return finalY;
}


-(void) setMyQuestionsPeakViewDisplayed:(BOOL)display{
	CGFloat finalY = 0;
	CGFloat finalX = self.myQuestionsPeakView.origin.x;
	if(display) {
		finalY = myQuestionsDisplayedPosition;
	}
	else {
		finalY = [self peekViewRestingYLocation];
	}
	
	CGFloat animationDuration = .2+.2;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
	[self.myQuestionsPeakView setOrigin:CGPointMake(finalX, finalY)];
	[UIView commitAnimations];
	[self updateMyQuestionsViewForScrollState];
}

-(BOOL) myQuestionsIsDisplayed{
	return (self.myQuestionsPeakView.origin.y != [self peekViewRestingYLocation]);
}

-(void) myQuestionsTapRecognizerDidTap:(UITapGestureRecognizer*)tapGesture{
	if ([tapGesture locationInView:self.myQuestionsPeakView].y > 50)
		return;
	
	if (tapGesture.state == UIGestureRecognizerStateRecognized){
		if ([self myQuestionsIsDisplayed]){
			[self setMyQuestionsPeakViewDisplayed:FALSE];
		}else{
			[self setMyQuestionsPeakViewDisplayed:TRUE];
		}
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        if (originalMyQuestionsDistanceFromBottom == 0){ //not setup yet, hasn't appeared
            return;
        }
        
		float shadowRadius = ceilf(([self peekViewRestingYLocation] - self.myQuestionsPeakView.origin.y )/22 );
        if (shadowRadius < 0.001){ //for whatever reason, floats just aren't capable of super-duper-zero.
            [self.myQuestionsPeakView.layer setShadowRadius:0];
            self.myQuestionsPeakView.layer.shadowOpacity = 0;
        }else{
            [self.myQuestionsPeakView.layer setShadowRadius:shadowRadius];
            self.myQuestionsPeakView.layer.shadowOpacity = MAX(shadowRadius/60.0f,0.2f);
        }

    }
}


#pragma mark choosers

- (DOCommunityChooserVC*) communityChooser{
    if (_communityChooser == nil){
        _communityChooser = [[DOCommunityChooserVC alloc] init];
        _communityChooser.delegate = self;
    }
    return _communityChooser;
}

- (DOSupportAreaChooserVC*) supportAreaChooser{
    if (_supportAreaChooser == nil){
        _supportAreaChooser = [[DOSupportAreaChooserVC alloc] init];
        _supportAreaChooser.delegate = self;
    }
    return _supportAreaChooser;
}
#pragma mark - DODelegation
//support areas
- (void) requestAdviceVCWantsDisplaySupportAreaChooser:(DORequestAdviceVC*)viewController{
    //add to view, draw happens at end of loop
    [self.view addSubview:self.supportAreaChooser.view];
    
    //save first origin of chooser
    CGPoint originalChooserOrigin = self.supportAreaChooser.chooserView.origin;
    //set pre-animate origin of *chooser*
    self.supportAreaChooser.chooserView.origin =  CGPointMake(self.supportAreaChooser.chooserView.origin.x, - 1.0 * self.supportAreaChooser.view.size.height);
    
    //set all alpha to zero
    self.supportAreaChooser.view.alpha = 0;
    
    [UIView animateWithDuration:.4 animations:^{
        self.supportAreaChooser.chooserView.origin = originalChooserOrigin;
        self.supportAreaChooser.view.alpha = 1;
    }];
}

-(void) supportAreaChooserDidFinish:(DOSupportAreaChooserVC*)chooser{
    CGPoint originalChooserOrigin = self.supportAreaChooser.chooserView.origin;
    
    [UIView animateWithDuration:.3 animations:^{
        self.supportAreaChooser.view.alpha = 0;
        self.supportAreaChooser.chooserView.origin =  CGPointMake(self.supportAreaChooser.chooserView.origin.x, - 1.0 * self.communityChooser.view.size.height);
    } completion:^(BOOL finished) {
        self.supportAreaChooser.chooserView.origin = originalChooserOrigin;
        [self.supportAreaChooser.view removeFromSuperview];
    }];   
}
-(void) supportAreaChooserDidSelectSupportArea:(SupportArea*)supportArea withChooser:(DOSupportAreaChooserVC*)chooser{
    
}

//Org
- (void) welcomeAndCommunityVCWantsDisplayCommunityChooser:(DOWelcomeAndCommunityVC*)viewController{
    
    //add to view, draw happens at end of loop
    [self.view addSubview:self.communityChooser.view];

    //save first origin of chooser
    CGPoint originalChooserOrigin = self.communityChooser.communityChooserView.origin;
    //set pre-animate origin of *chooser*
    self.communityChooser.communityChooserView.origin =  CGPointMake(self.communityChooser.communityChooserView.origin.x, - 1.0 * self.communityChooser.view.size.height);
    
    //set all alpha to zero
    self.communityChooser.view.alpha = 0;
    
    [UIView animateWithDuration:.4 animations:^{
        self.communityChooser.communityChooserView.origin = originalChooserOrigin;
        self.communityChooser.view.alpha = 1;
    }];
}

-(void) communityChooserDidFinish:(DOCommunityChooserVC*)chooser{
    
    CGPoint originalChooserOrigin = self.communityChooser.communityChooserView.origin;
        
    [UIView animateWithDuration:.3 animations:^{
        self.communityChooser.view.alpha = 0;
        self.communityChooser.communityChooserView.origin =  CGPointMake(self.communityChooser.communityChooserView.origin.x, - 1.0 * self.communityChooser.view.size.height);
    } completion:^(BOOL finished) {
        self.communityChooser.communityChooserView.origin = originalChooserOrigin;
        [self.communityChooser.view removeFromSuperview];
    }];
    
}

-(void) communityChooserDidSelectOrganization:(Organization*)organization withChooser:(DOCommunityChooserVC*)chooser{
    
}


#pragma mark - addenda
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self.communityChooser.view superview] == nil){
        _communityChooser = nil;
    }
}


-(void) dealloc{
	[self removeObserver:self forKeyPath:@"frame"];
}



@end
