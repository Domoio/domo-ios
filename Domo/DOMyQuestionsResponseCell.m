//
//  DOMyQuestionsResponseCell.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/26/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOMyQuestionsResponseCell.h"
#import <QuartzCore/QuartzCore.h>
#import "TTTTimeIntervalFormatter.h"

static const double defaultResponseTextHeight = 69;

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
	
    [self setBackgroundColor:[UIColor clearColor]];
    self.styleView.userInteractionEnabled = FALSE;
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
    
    const CGFloat dnTaMargin = 8;
    CGSize sizeOfDisplayNameText = [DOMyQuestionsResponseCell sizeForDisplayNameText:[response responderDisplayName]];
    [self.responderDisplayNameLabel setWidth:sizeOfDisplayNameText.width];
    [self.responderDisplayNameLabel setText:[response responderDisplayName]];
    
    
    CGSize responseDisplaySize = [DOMyQuestionsResponseCell sizeForResponseText:response.responseContent];
    CGFloat textfieldReqHeight = ceilf(responseDisplaySize.height);
    if (response.isExpanded.boolValue == FALSE){
        textfieldReqHeight = MIN(defaultResponseTextHeight, textfieldReqHeight);
    }
    [self.responseTextLabel setHeight:textfieldReqHeight];
    
    CGFloat viewHeight = [[self class] heightForObject:response atIndexPath:nil tableView:nil];
    [self.styleView setHeight:viewHeight];
    
    NSDate * relevantDate = [response createdDate];
    if (relevantDate == nil)
        relevantDate = [response modifiedDate];
    
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
    
    //set from above stuff
    [self.responseTimeAgoLabel setOrigin:CGPointMake(self.responderDisplayNameLabel.origin.x + self.responderDisplayNameLabel.size.width + dnTaMargin , self.responseTimeAgoLabel.origin.y)];
    [self.responseTimeAgoLabel setText:agoString];

    if (response.isHelpful.boolValue == TRUE){
        [self.helpfullButton setImage:[UIImage imageNamed:@"this-helps-button-activated.png"] forState:UIControlStateNormal];
    }else{
        [self.helpfullButton setImage:[UIImage imageNamed:@"this-helps-button-deactivated.png"] forState:UIControlStateNormal];
    }

    if (response.responderThanked.boolValue == TRUE){
        [self.thankYouButton setImage:[UIImage imageNamed:@"thank-you-button-activated.png"] forState:UIControlStateNormal];
    }else{
        [self.thankYouButton setImage:[UIImage imageNamed:@"thank-you-button-deactivated.png"] forState:UIControlStateNormal];
    }
    
    [self.helpfullButton setEnabled:TRUE];
    [self.thankYouButton setEnabled:TRUE];

    
	return TRUE;
}

+(CGSize)sizeForDisplayNameText:(NSString*)displayNameText{
    UIFont * responseFont = [UIFont fontWithName:@"Helvetica-Light" size:14];
    CGSize displayNameMaxSize = CGSizeMake(120, 20);
    CGSize sizeOfDisplayNameText = CGSizeMake(ceil([displayNameText sizeWithFont:responseFont constrainedToSize:displayNameMaxSize lineBreakMode:NSLineBreakByTruncatingTail].width), displayNameMaxSize.height);
    
    return sizeOfDisplayNameText;
    
}

+(CGSize)sizeForResponseText:(NSString*)responseContentText{
    UIFont * responseFont = [UIFont fontWithName:@"HelveticaNeue" size:13];
    CGSize responseMaxSize = CGSizeMake(272, DBL_MAX);
    CGSize sizeOfResponseText = [responseContentText sizeWithFont:responseFont constrainedToSize:responseMaxSize lineBreakMode:NSLineBreakByTruncatingTail];
    
    return sizeOfResponseText;
    
}

- (IBAction)helpfullButtonPressed:(id)sender {
    [self.delegate helpfullButtonWasTappedWithMyQuestionsResponseCell:self];
    [self.helpfullButton setEnabled:FALSE];//disabled while server loading
}

- (IBAction)thankYouButtonPressed:(id)sender {
    [self.delegate thankYouButtonWasTappedWithMyQuestionsResponseCell:self];
    [self.thankYouButton setEnabled:FALSE];//disabled while server loading
}

+ (CGFloat)heightForObject:(Response*)response atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    const double cellHeight = 117;
    
    CGSize sizeOfResponseText = [self sizeForResponseText:[response responseContent]];
    
    if ([response isExpanded].boolValue){
        
        double expandedHeight = ceilf(cellHeight + sizeOfResponseText.height - defaultResponseTextHeight);
        return expandedHeight;
        
    }else {
        if (sizeOfResponseText.height < defaultResponseTextHeight){
            CGFloat newHeight = ceilf(cellHeight + sizeOfResponseText.height - defaultResponseTextHeight);
            return newHeight;
        }else{
            return cellHeight;
        }
        
    }
}

@end
