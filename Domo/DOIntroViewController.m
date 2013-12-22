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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"patternsquare_green.png"]]];
    [self.mainContentScrollView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat contentHeight = self.mainContentScrollView.size.height;
    self.mainContentScrollView.contentSize = CGSizeMake(self.mainContentScrollView.size.width, contentHeight * 3);
    
    [self.mainContentScrollView addSubview:self.supporteeQuestionView];
    
    [self.supportersAnswerView setOrigin:CGPointMake(0, contentHeight)];
    [self.mainContentScrollView addSubview:self.supportersAnswerView];
    
    [self.supporteeWithSolutionView setOrigin:CGPointMake(0, contentHeight*2)];
    [self.mainContentScrollView addSubview:self.supporteeWithSolutionView];
    
    UIView * underview = [[UIView alloc] initWithFrame:CGRectZero];
    underview.size = self.mainContentScrollView.contentSize;
    [underview setBackgroundColor:[UIColor whiteColor]];
    [self.mainContentScrollView insertSubview:underview atIndex:0];
    
    [self _setupCloudMotion];
}


-(void)_setupCloudMotion{
    
    //I Can't get motion working :/
    
    
    __block DOIntroViewController * bSelf = self;
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

    /*
    UIView *cloudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width*2, 64)];
    cloudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloud"]];
    cloudView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.supporteeWithSolutionView addSubview:cloudView];
    UIView *extraCloudView = [[UIView alloc] initWithFrame:CGRectMake(-64, -10, self.view.width*2, 64)];
    extraCloudView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cloud"]];
    extraCloudView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [cloudView addSubview:extraCloudView];
//
    [UIView animateWithDuration:5 delay:0 options:(UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse) animations:^{
        cloudView.transform = CGAffineTransformMakeTranslation(-120, -5);
        extraCloudView.transform = CGAffineTransformMakeTranslation(120, 5);
    } completion:NULL];
     */
     
//    CGPoint newCloudOrigin = CGPointMake( self.cloud2.origin.x + 300, self.cloud2.origin.y);
    
//    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
//    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
//    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
//    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(200.0, 5.0)]; // y increases downwards on iOS
//    hover.autoreverses = YES; // Animate back to normal afterwards
//    hover.duration = 2; // The duration for one part of the animation (0.2 up and 0.2 down)
//    hover.repeatCount = INFINITY; // The number of times the animation should repeat
//    [self.cloud2.layer addAnimation:hover forKey:@"myCloudAnimation"];

    
//    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.cloud2.origin = newCloudOrigin;
//    } completion:nil];
    
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut| UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionAllowAnimatedContent animations:^{
        [self.cloud2 setOrigin:CGPointMake( self.cloud2.origin.x + 300, self.cloud2.origin.y)];
        [self.cloud3 setOrigin:CGPointMake( self.cloud3.origin.x -100, self.cloud3.origin.y)];

    } completion:nil];
}

-(IBAction) exitTapGestureRecognizerRecognized:(UITapGestureRecognizer*)recognizer{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
