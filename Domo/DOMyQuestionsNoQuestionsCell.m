//
//  DOMyQuestionsNoQuestionsCell.m
//  Domo
//
//  Created by Alexander Hoekje List on 12/21/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOMyQuestionsNoQuestionsCell.h"
#import <QuartzCore/QuartzCore.h>



@implementation DOMyQuestionsNoQuestionsCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
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
    self.layer.anchorPoint = CGPointMake(.5, .5);
    
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.styleView.userInteractionEnabled = FALSE;
    self.styleView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTappedWithRecognizer:)];
    [self.contentDisplayView addGestureRecognizer:tapRecognizer];
    [self.contentDisplayView setUserInteractionEnabled:TRUE];
    
}

-(UINib*) viewNib{
	return [UINib nibWithNibName:@"DOMyQuestionsNoQuestionsCell-iPhone" bundle:[NSBundle mainBundle]];
}


-(void) cellTappedWithRecognizer:(UITapGestureRecognizer*)recognizer{
    if (self.didRotateCutsiePoo == FALSE){
        
        
        __block DOMyQuestionsNoQuestionsCell * bView = self;
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            
            CATransform3D transform = CATransform3DMakeScale(.95, .95, 1);
            transform = CATransform3DRotate(transform, -5.0/360.0 * 2.0* M_PI, 0, 0, 1);
            
            bView.layer.transform = transform;
            
            
        } completion:nil];
        
        self.didRotateCutsiePoo = TRUE;
        
    }
    
    
    //    [self.delegate myQuestionsRequestCellWasTappedWithCell:self];
}

- (BOOL)shouldUpdateCellWithObject:(NSObject*)request{
    
	return TRUE;
}


+ (CGFloat)heightForObject:(NSObject*)request atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView{
    const double cellHeight = 87;
    return cellHeight;
}

@end

@implementation DOMyQuestionsNoQuestionsCellObject

- (Class)cellClass{
    return [DOMyQuestionsNoQuestionsCell class];
}

@end

