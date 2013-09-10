//
//  DOMyQuestionsResponseCell.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOMyQuestionsResponseCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DOMyQuestionsResponseCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	
	UINib * nib = [self viewNib];
	if ((self = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0])){
		[self setup];
	}
	return self;
}

-(void)setup{
    
    
    UIView * subview  = [[UIView alloc] initWithFrame:self.bounds];
    [self insertSubview:subview atIndex:0];
    self.styleView = subview;
	
    self.styleView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTappedWithRecognizer:)];
    [self addGestureRecognizer:tapRecognizer];
    
}

-(UINib*) viewNib{
	return [UINib nibWithNibName:@"DOMyQuestionsResponseCell-iPhone" bundle:[NSBundle mainBundle]];
}

-(void) cellTappedWithRecognizer:(UITapGestureRecognizer*)recognizer{
    [self.delegate myQuestionsResponseCellCellWasTappedWithCell:self];
}

- (BOOL)shouldUpdateCellWithObject:(Response*)response{
    
    [self.responseTextLabel setText:[response responseContent]];
    
    //	[self.conversationLabel setText:[conversation subject]];
    //
    //	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    //	[dateFormatter setDateStyle:NSDateFormatterFullStyle];
    //	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //	[dateFormatter setLocale:[NSLocale currentLocale]];
    //	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    //
    //	NSString * partnerName = @"someone";
    //	if ([conversation.partnerName length] >0){
    //		partnerName = conversation.partnerName;
    //	}
    //	else if ([conversation.partnerTwitter length] >0){
    //		partnerName = conversation.partnerTwitter;
    //	}
    //
    //	NSString * detailString = [NSString stringWithFormat:@"with %@ on %@", partnerName, [dateFormatter stringFromDate:conversation.modifiedDate]];
    //	[self.detailsLabel setText:detailString];
    //
	
	return TRUE;
}

+ (CGFloat)heightForObject:(Response*)Response atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
	return 117;
}

@end
