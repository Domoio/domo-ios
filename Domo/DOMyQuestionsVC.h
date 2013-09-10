//
//  DOMyQuestionsVC.h
//  Domo
//
//  Created by Alexander List on 6/27/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NITableViewModel.h"
#import "NICellFactory.h"
#import "DOMyQuestionsRequestCell.h"
#import "DOMyQuestionsResponseCell.h"

@interface DOMyQuestionsVC : UIViewController <NITableViewModelDelegate, UITableViewDelegate,NSFetchedResultsControllerDelegate, DOMyQuestionsRequestCellDelegate, DOMyQuestionsResponseCellDelegate >

@property (nonatomic, strong) NSArray *			displayedObjects;
@property (nonatomic, strong) NITableViewModel*	tvModel;
@property (nonatomic, strong) NSFetchedResultsController * fetchController;
@property (nonatomic, strong) IBOutlet UITableView * tableView;

@end
