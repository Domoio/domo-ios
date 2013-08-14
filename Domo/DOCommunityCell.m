//
//  DOCommunityCell.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/13/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOCommunityCell.h"

@implementation DOCommunityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
        
        
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(150/255.0) blue:(71/255.0) alpha:1];
        self.selectedBackgroundView = selectionColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForObject:(Organization*)organization atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    return 32;
}
- (BOOL)shouldUpdateCellWithObject:(Organization*)organization{
    
    self.textLabel.text = [organization displayName];
    
    return TRUE;
}

@end
