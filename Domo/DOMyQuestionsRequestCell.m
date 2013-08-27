//
//  DOMyQuestionsRequestCell.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOMyQuestionsRequestCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DOMyQuestionsRequestCell

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
	
    //comment the following for a cool effect
    self.styleView.backgroundColor = [UIColor whiteColor];
	self.styleView.layer.borderColor = [UIColor colorWithWhite:0.55 alpha:0.15].CGColor;
	self.styleView.layer.borderWidth = 1;
	self.styleView.layer.cornerRadius = 0;
	self.styleView.layer.shadowColor = UIColor.blackColor.CGColor;
	self.styleView.layer.shadowOffset = CGSizeMake(0, 1);
	self.styleView.layer.shadowOpacity = 0.2;
	self.styleView.layer.shadowRadius = 2;
	self.styleView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.styleView.bounds].CGPath;

}

-(UINib*) viewNib{
	return [UINib nibWithNibName:@"DOMyQuestionsRequestCell-iPhone" bundle:[NSBundle mainBundle]];
}

- (BOOL)shouldUpdateCellWithObject:(AdviceRequest*)request{
    
    [self.requestTextLabel setText:[request requestContent]];
    
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

+ (CGFloat)heightForObject:(AdviceRequest*)request atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
	return 107;
}

@end
