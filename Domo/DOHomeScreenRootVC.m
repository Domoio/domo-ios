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
	float originalMyQuestionsOrigin;
	float askAdviceDisplayedOrigin;
}
@end

const float myQuestionsDisplayedPosition = 20;

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
	self.welcomeCommunityHeader.view.layer.shadowColor = UIColor.blackColor.CGColor;
	self.welcomeCommunityHeader.view.layer.shadowOffset = CGSizeMake(0, 1);
	self.welcomeCommunityHeader.view.layer.shadowOpacity = 0.2;
	self.welcomeCommunityHeader.view.layer.shadowRadius = 2;
	self.welcomeCommunityHeader.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.welcomeCommunityHeader.view.bounds].CGPath;;
	
	self.requestAdviceVC = [[DORequestAdviceVC alloc] initWithNibName:nil bundle:nil];
	self.requestAdviceVC.view.layer.shadowColor = UIColor.blackColor.CGColor;
	self.requestAdviceVC.view.layer.shadowOffset = CGSizeMake(0, 1);
	self.requestAdviceVC.view.layer.shadowOpacity = 0.2;
	self.requestAdviceVC.view.layer.shadowRadius = 2;
	self.requestAdviceVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.requestAdviceVC.view.bounds].CGPath;;


	CGFloat handleHeight = 48;
	CGFloat yOriginOfAskAdviceHandle = self.myQuestionsPeakView.frame.origin.y - handleHeight /* above the myquestions handle */;
	CGFloat totalHeight = yOriginOfAskAdviceHandle + self.requestAdviceVC.view.frame.size.height;
	//OR
	//totalHeight = self.mainContentScrollView.height * 2;
	[self.mainContentScrollView setContentSize:CGSizeMake(320, totalHeight)];
	[self.mainContentScrollView addSubview:self.welcomeCommunityHeader.view];
	
	[self.requestAdviceVC.view setOrigin:CGPointMake(0,yOriginOfAskAdviceHandle)];
	[self.mainContentScrollView addSubview:self.requestAdviceVC.view];
	
	originalMyQuestionsOrigin = self.myQuestionsPeakView.origin.y;
	askAdviceDisplayedOrigin = self.requestAdviceVC.view.origin.y;

	
	self.myQuestionsVC = [[DOMyQuestionsVC alloc] init];
	[self.myQuestionsPeakView addSubview:self.myQuestionsVC.view];
	self.myQuestionsPeakView.layer.shadowColor = UIColor.blackColor.CGColor;
	self.myQuestionsPeakView.layer.shadowOffset = CGSizeMake(0, -1);
	self.myQuestionsPeakView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.myQuestionsPeakView.bounds].CGPath;;
	
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[[[UIResponder new] currentFirstResponder] resignFirstResponder];
}

-(void) adviceRequestTapRecognizerDidTap:(UITapGestureRecognizer*)tapGesture{
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
			finalY = originalMyQuestionsOrigin;
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

-(void) setMyQuestionsPeakViewDisplayed:(BOOL)display{
	CGFloat finalY = 0;
	CGFloat finalX = self.myQuestionsPeakView.origin.x;
	if(display) {
		finalY = myQuestionsDisplayedPosition;
	}
	else {
		finalY = originalMyQuestionsOrigin;
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
	return (self.myQuestionsPeakView.origin.y != originalMyQuestionsOrigin);
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
		float shadowRadius = ceilf((originalMyQuestionsOrigin - self.myQuestionsPeakView.origin.y)/22 );
		[self.myQuestionsPeakView.layer setShadowRadius:shadowRadius];
		self.myQuestionsPeakView.layer.shadowOpacity = MAX(shadowRadius/60.0f,0.2f);

    }
}

-(void) dealloc{
	[self removeObserver:self forKeyPath:@"frame"];
}




@end
