//
//  DOCommunityCell.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/13/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization.h"

@interface DOCommunityCell : UITableViewCell


+ (CGFloat)heightForObject:(Organization*)organization atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (BOOL)shouldUpdateCellWithObject:(Organization*)organization;

@end
