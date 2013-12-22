//
//  DOIntroViewController.h
//  Domo
//
//  Created by Alexander Hoekje List on 12/21/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOIntroViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *supporteeWithSolutionView;
@property (strong, nonatomic) IBOutlet UIView *supportersAnswerView;
@property (strong, nonatomic) IBOutlet UIView *supporteeQuestionView;

@property (weak, nonatomic) IBOutlet UIScrollView *mainContentScrollView;

- (IBAction)exitTapGestureRecognizerRecognized:(UITapGestureRecognizer *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *cloud0;
@property (weak, nonatomic) IBOutlet UIImageView *cloud1;
@property (weak, nonatomic) IBOutlet UIImageView *cloud2;
@property (weak, nonatomic) IBOutlet UIImageView *cloud3;

-(void)_setupCloudMotion;

@end
