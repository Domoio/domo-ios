//
//  DOMyQuestionsResponseCell.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NICellCatalog.h"
#import "Response.h"


@class DOMyQuestionsResponseCell;

@protocol DOMyQuestionsResponseCellDelegate <NSObject>
-(void) myQuestionsResponseCellCellWasTappedWithCell:(DOMyQuestionsResponseCell*)cell;

-(void) helpfullButtonWasTappedWithMyQuestionsResponseCell:(DOMyQuestionsResponseCell*)cell;
-(void) thankYouButtonWasTappedWithMyQuestionsResponseCell:(DOMyQuestionsResponseCell*)cell;
@end


@interface DOMyQuestionsResponseCell : UITableViewCell <NICell>

@property (weak, nonatomic) id<DOMyQuestionsResponseCellDelegate> delegate;

@property (strong, nonatomic) UIView * styleView;
@property (weak, nonatomic) IBOutlet UILabel *responderDisplayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseTimeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *thankYouButton;
@property (weak, nonatomic) IBOutlet UIButton *helpfullButton;

- (IBAction)helpfullButtonPressed:(id)sender;
- (IBAction)thankYouButtonPressed:(id)sender;


+ (CGFloat)heightForObject:(Response*)Response atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (BOOL)shouldUpdateCellWithObject:(Response*)Response;

@end
