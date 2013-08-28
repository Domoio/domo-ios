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
#import "MGScrollView.h"
#import "DOMyQuestionsVC.h"
#import "DOCommunityChooserVC.h"
#import "DOSupportAreaChooserVC.h"

@interface DOHomeScreenRootVC : UIViewController <UIScrollViewDelegate,DOWelcomeAndCommunityVCDelegate,DOCommunityChooserVCDelegate, DORequestAdviceVCDelegate,DOSupportAreaChooserVCDelegate>

@property (nonatomic, strong) DOWelcomeAndCommunityVC * welcomeCommunityHeader;
@property (nonatomic, strong) DORequestAdviceVC* requestAdviceVC;
@property (nonatomic, strong) DOMyQuestionsVC * myQuestionsVC;

@property (nonatomic, strong) DOCommunityChooserVC * communityChooser;
@property (nonatomic, strong) DOSupportAreaChooserVC * supportAreaChooser;

@property (nonatomic, strong) IBOutlet MGScrollView * mainContentScrollView;
@property (nonatomic, strong) IBOutlet UIView * myQuestionsPeakView;


-(BOOL) mainGetAdviceTrayIsScrolledToTop;//if on top 'page' of view

-(BOOL) myQuestionsIsDisplayed;
-(void) updateMyQuestionsViewForScrollState;

@end
