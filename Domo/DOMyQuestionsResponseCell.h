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

@interface DOMyQuestionsResponseCell : UITableViewCell <NICell>

@property (strong, nonatomic) UIView * styleView;
@property (weak, nonatomic) IBOutlet UILabel *responderDisplayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseTimeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseTextLabel;

+ (CGFloat)heightForObject:(Response*)Response atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (BOOL)shouldUpdateCellWithObject:(Response*)Response;

@end
