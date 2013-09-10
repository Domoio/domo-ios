//
//  DOMyQuestionsRequestCell.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOMyQuestionsRequestCell.h"
#import "Organization.h"
#import <QuartzCore/QuartzCore.h>
#import "TTTTimeIntervalFormatter.h"

static const double defaultRequestTextHeight = 125;


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
    
    self.styleView.userInteractionEnabled = FALSE;
    self.styleView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTappedWithRecognizer:)];
    [self addGestureRecognizer:tapRecognizer];
}

-(UINib*) viewNib{
	return [UINib nibWithNibName:@"DOMyQuestionsRequestCell-iPhone" bundle:[NSBundle mainBundle]];
}


-(void) cellTappedWithRecognizer:(UITapGestureRecognizer*)recognizer{
    [self.delegate myQuestionsRequestCellWasTappedWithCell:self];
}

- (BOOL)shouldUpdateCellWithObject:(AdviceRequest*)request{
    
    [self.requestTextLabel setText:[request requestContent]];
    [self.styleView setHeight:[DOMyQuestionsRequestCell heightForObject:request atIndexPath:nil tableView:nil]];
    
    CGFloat textfieldReqHeight = [DOMyQuestionsRequestCell sizeForRequestText:request.requestContent].height;
    if (request.isExpanded.boolValue == FALSE){
        textfieldReqHeight = MIN(defaultRequestTextHeight, textfieldReqHeight);
    }
    [self.requestTextLabel setHeight:textfieldReqHeight];
    
    NSDate * relevantDate = [request createdDate];
    
    NSString * agoString = nil;
    
    if ([relevantDate timeIntervalSinceNow] > (-1*60*60*24*3)){
        TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        [timeIntervalFormatter setUsesIdiomaticDeicticExpressions:NO];
        agoString = [timeIntervalFormatter stringForTimeInterval:[relevantDate timeIntervalSinceNow]];
    }else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDoesRelativeDateFormatting:YES];
    
        agoString = [dateFormatter stringFromDate:relevantDate];
    }
    
    [self.timeAgoSubmittedLabel setText:agoString];
    
    [self.toWithSkillsLabel setText:[DOMyQuestionsRequestCell toWithSkillsLabelTextForRequest:request]];
    
	return TRUE;
}

+(NSString*) toWithSkillsLabelTextForRequest:(AdviceRequest*)request{
    NSString * text = nil;
    if (request.supportArea != nil){
        text = [NSString stringWithFormat:NSLocalizedString(@"to people at %@ claiming insight in %@", @"toWithSkillsLabelStringFormat"),request.organization.displayName, request.supportArea.name];
    }else{
        text = [NSString stringWithFormat:NSLocalizedString(@"to people at %@ claiming insight in some area", @"toWithSkillsUndefinedLabelStringFormat"),request.organization.displayName];
    }
    
    return text;
}

+(CGSize)sizeForRequestText:(NSString*)requestContentText{
    UIFont * requestFont = [UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize requestMaxSize = CGSizeMake(272, DBL_MAX);
    CGSize sizeOfRequestText = [requestContentText sizeWithFont:requestFont constrainedToSize:requestMaxSize lineBreakMode:NSLineBreakByTruncatingTail];

    return sizeOfRequestText;

}

+ (CGFloat)heightForObject:(AdviceRequest*)request atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    const double cellHeight = 222;
    
    CGSize sizeOfRequestText = [self sizeForRequestText:[request requestContent]];
    
    if ([request isExpanded].boolValue){
        
        return cellHeight + sizeOfRequestText.height - defaultRequestTextHeight;
        
    }else {
        if (sizeOfRequestText.height < defaultRequestTextHeight){
            CGFloat newHeight = cellHeight + sizeOfRequestText.height - defaultRequestTextHeight;
            return newHeight;
        }else{
            return cellHeight;
        }
        
    }
}

@end
