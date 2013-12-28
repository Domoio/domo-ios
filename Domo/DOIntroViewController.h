//
//  DOIntroViewController.h
//  Domo
//
//  Created by Alexander Hoekje List on 12/21/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DOIntroViewController;

@protocol DOIntroViewControllerDelegate <NSObject>
-(void)DOIntroViewControllerDidConclude:(DOIntroViewController*)sender;
@end

@interface DOIntroViewController : UIViewController
@property (strong, nonatomic) UIView * backgroundView;

@property (strong, nonatomic) IBOutlet UIView *supporteeWithSolutionView;
@property (strong, nonatomic) IBOutlet UIView *supportersAnswerView;
@property (strong, nonatomic) IBOutlet UIView *supporteeQuestionView;

@property (weak, nonatomic) IBOutlet UIScrollView *mainContentScrollView;

- (IBAction)exitTapGestureRecognizerRecognized:(UITapGestureRecognizer *)sender;
- (IBAction)nextPageTapGestureRecognized:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *supporteeQuestionTipTapHintLabel;

@property (weak, nonatomic) IBOutlet UIImageView *cloud0;
@property (weak, nonatomic) IBOutlet UIImageView *cloud1;
@property (weak, nonatomic) IBOutlet UIImageView *cloud2;
@property (weak, nonatomic) IBOutlet UIImageView *cloud3;

@property (weak, nonatomic) id<DOIntroViewControllerDelegate> delegate;

-(void)_setupCloudMotion;

@end
