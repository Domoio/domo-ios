//
//  DOIntroViewController.m
//  Domo
//
//  Created by Alexander Hoekje List on 12/21/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOIntroViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DOIntroViewController ()

@end

@implementation DOIntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"patternsquare_green.png"]]];

    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.mainContentScrollView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat realHeight = [UIApplication sharedApplication].keyWindow.size.height;
//    [self.view setHeight:realHeight];
//    [self.mainContentScrollView setHeight:self.view.height];
    CGFloat contentHeight = self.mainContentScrollView.size.height;
    self.mainContentScrollView.contentSize = CGSizeMake(self.mainContentScrollView.size.width, realHeight * 4);
    
    [self.mainContentScrollView addSubview:self.supporteeQuestionView];
    self.supporteeQuestionTipTapHintLabel.alpha = 0;
    self.supporteeQuestionTipTapHintLabel.layer.anchorPoint = CGPointMake(.5, .5);

    __weak DOIntroViewController * bSelf = self;
    double delayInSeconds = 7.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:.7 delay:0 options:0 animations:^{
            bSelf.supporteeQuestionTipTapHintLabel.alpha = 1;

            CATransform3D transform = CATransform3DMakeScale(1, 1, 1);
            transform = CATransform3DRotate(transform, -7.0/360.0 * 2.0* M_PI, 0, 0, 1);

            bSelf.supporteeQuestionTipTapHintLabel.layer.transform = transform;

        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:.3 animations:^{
                CATransform3D transform = CATransform3DMakeScale(1, 1, 1);
                transform = CATransform3DRotate(transform, 7.0/360.0 * 2.0* M_PI, 0, 0, 1);
                bSelf.supporteeQuestionTipTapHintLabel.layer.transform = transform;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.3 animations:^{
                    CATransform3D transform = CATransform3DMakeScale(1, 1, 1);
                    transform = CATransform3DRotate(transform, 0.0/360.0 * 2.0* M_PI, 0, 0, 1);
                    bSelf.supporteeQuestionTipTapHintLabel.layer.transform = transform;
                }];

            }];

        }];
    });
    
    
    
    [self.supportersAnswerView setOrigin:CGPointMake(0, contentHeight)];
    [self.mainContentScrollView addSubview:self.supportersAnswerView];
    
    [self.supporteeWithSolutionView setOrigin:CGPointMake(0, contentHeight*2)];
    [self.mainContentScrollView addSubview:self.supporteeWithSolutionView];
    
//    double delayInSeconds2 = 2.0;
//    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds2 * NSEC_PER_SEC));
//    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
//        EXLog(@"self.supporteeWithSolutionView : %@", self.supporteeWithSolutionView);
//    });
    
    UIView * underview = [[UIView alloc] initWithFrame:CGRectZero];
    underview.size = CGSizeMake(self.mainContentScrollView.size.width, realHeight * 3);
    [underview setBackgroundColor:[UIColor whiteColor]];
    [self.mainContentScrollView insertSubview:underview atIndex:0];
    
    
    //kvo on contentOffset
    [self.mainContentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    [self _setupCloudMotion];
    
    
    
}


-(void)_setupCloudMotion{
    
    //I Can't get motion working :/
    
    
    __weak DOIntroViewController * bSelf = self;
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UIView *cloudView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, bSelf.view.width*2, 64)];
        cloudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloud"]];
        cloudView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [bSelf.supporteeQuestionView addSubview:cloudView];
        UIView *extraCloudView = [[UIView alloc] initWithFrame:CGRectMake(-64, 30, bSelf.view.width*2, 64)];
        extraCloudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloud"]];
        extraCloudView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cloudView addSubview:extraCloudView];
        //
        [UIView animateWithDuration:5 delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
            cloudView.transform = CGAffineTransformMakeTranslation(-120, -5);
            extraCloudView.transform = CGAffineTransformMakeTranslation(200, 5);
        } completion:NULL];

        [bSelf.cloud2 setOrigin:CGPointMake( 0-bSelf.cloud2.width, bSelf.cloud2.origin.y)];
        [bSelf.cloud3 setOrigin:CGPointMake( 0-bSelf.cloud3.width, bSelf.cloud3.origin.y)];
        [UIView animateWithDuration:50 delay:20 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [bSelf.cloud2 setOrigin:CGPointMake( bSelf.view.width + bSelf.cloud2.width, bSelf.cloud2.origin.y)];
        } completion:nil];
        
        [UIView animateWithDuration:40 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionAllowAnimatedContent animations:^{
            [bSelf.cloud3 setOrigin:CGPointMake( bSelf.view.width +bSelf.cloud3.width, bSelf.cloud3.origin.y)];
        } completion:nil];
        
        

    });


    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut| UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionAllowAnimatedContent animations:^{
        [bSelf.cloud2 setOrigin:CGPointMake( bSelf.cloud2.origin.x + 300, bSelf.cloud2.origin.y)];
        [bSelf.cloud3 setOrigin:CGPointMake( bSelf.cloud3.origin.x -100, bSelf.cloud3.origin.y)];

    } completion:nil];
}

-(IBAction) exitTapGestureRecognizerRecognized:(UITapGestureRecognizer*)recognizer{
    //disabled GR in nib
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)nextPageTapGestureRecognized:(id)sender {
    CGRect nextPageFrame = self.mainContentScrollView.bounds;
    nextPageFrame.origin = [self.mainContentScrollView contentOffset];
    nextPageFrame.origin.y += nextPageFrame.size.height;
    
    if (nextPageFrame.origin.y < self.mainContentScrollView.contentSize.height)
        [self.mainContentScrollView scrollRectToVisible:nextPageFrame animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        
        CGPoint offset = [self.mainContentScrollView contentOffset];
        double distIntoClear = offset.y - self.supporteeWithSolutionView.origin.y;
        
        if (distIntoClear >= 0){
            double viewHeight = self.supporteeWithSolutionView.size.height;
            
            double newAlpha =1 - distIntoClear / viewHeight;
            
            self.view.alpha = newAlpha;
            
            __weak DOIntroViewController * wSelf = self;
            if (distIntoClear == viewHeight){
                [UIView animateWithDuration:.4 animations:^{
                    [self.view removeFromSuperview];
                } completion:^(BOOL finished) {
                    [wSelf.delegate DOIntroViewControllerDidConclude:wSelf];
                    wSelf.delegate = nil;
                }];
            }
            
        }

        
    }
}

-(void) dealloc{
    [self.mainContentScrollView removeObserver:self forKeyPath:@"contentOffset"];
}



@end
