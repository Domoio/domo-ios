//
//  DOSupportAreaCell.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/27/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOSupportAreaCell.h"


@implementation DOSupportAreaCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (BOOL)shouldUpdateCellWithObject:(SupportArea*)supportArea{
    
    self.textLabel.text = [supportArea name];
    
    return TRUE;
}


@end
