//
//  DOMyQuestionsRequestCell.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICellCatalog.h"
#import "AdviceRequest.h"

@class DOMyQuestionsRequestCell;

@protocol DOMyQuestionsRequestCellDelegate <NSObject>
-(void) myQuestionsRequestCellWasTappedWithCell:(DOMyQuestionsRequestCell*)cell;
@end

@interface DOMyQuestionsRequestCell : UITableViewCell <NICell>

@property (strong, nonatomic) UIView * styleView;

+ (CGFloat)heightForObject:(AdviceRequest*)request atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (BOOL)shouldUpdateCellWithObject:(AdviceRequest*)request;

@property (weak, nonatomic) id<DOMyQuestionsRequestCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *timeAgoSubmittedLabel;
@property (weak, nonatomic) IBOutlet UILabel *toWithSkillsLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestTextLabel;
@property (weak, nonatomic) IBOutlet UIView *contentDisplayView;

@end
