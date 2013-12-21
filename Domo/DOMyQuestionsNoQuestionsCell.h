//
//  DOMyQuestionsNoQuestionsCell.h
//  Domo
//
//  Created by Alexander Hoekje List on 12/21/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NICellCatalog.h"

@interface DOMyQuestionsNoQuestionsCell : UITableViewCell <NICell>
@property (strong, nonatomic) UIView * styleView;
@property (weak, nonatomic) IBOutlet UIView *contentDisplayView;
@property (weak, nonatomic) IBOutlet UILabel *nothingHereHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *nothingHereDetailLabel;
@property (assign, nonatomic) BOOL didRotateCutsiePoo;


+ (CGFloat)heightForObject:(NSObject*)request atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
@end



@interface DOMyQuestionsNoQuestionsCellObject : NSObject <NICellObject>

@end