//
//  DOHomeScreenRootVC.h
//  Domo
//
//  Created by Alexander List on 6/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOWelcomeAndCommunityVC.h"
#import "DORequestAdviceVC.h"

@interface DOHomeScreenRootVC : UIViewController

@property (nonatomic, strong) DOWelcomeAndCommunityVC * welcomeCommunityHeader;
@property (nonatomic, strong) DORequestAdviceVC* requestAdviceVC;


@property (nonatomic, strong) IBOutlet UIScrollView * mainContentScrollView;
@property (nonatomic, strong) IBOutlet UIView * myQuestionsPeakView;



@end
