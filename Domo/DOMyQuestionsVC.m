//
//  DOMyQuestionsVC.m
//  Domo
//
//  Created by Alexander List on 6/27/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOMyQuestionsVC.h"
#import "AdviceRequest.h"
#import "Response.h"
#import "Organization.h"

@interface DOMyQuestionsVC ()
@end

@implementation DOMyQuestionsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"DOMyQuestionsVC-iPhone" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.tableView setDataSource:self.tvModel];
    
    [self updateUIForUnreadCount:[UIApplication sharedApplication].applicationIconBadgeNumber animate:FALSE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateUnreadPostLaunch) name:shouldUpdateNewAdviceUINotification object:nil];
}    


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) _updateUnreadPostLaunch{
    [self updateUIForUnreadCount:[UIApplication sharedApplication].applicationIconBadgeNumber animate:TRUE];
}


-(NITableViewModel*)tvModel{
	if (_tvModel == nil){
		NSMutableArray * array = [NSMutableArray array];
		[array addObjectsFromArray:self.displayedObjects];
		
		self.displayedObjects = array;
		_tvModel = [[NITableViewModel alloc] initWithSectionedArray:array delegate:self];
		
	}
	return _tvModel;
}

-(NSArray*)displayedObjects{
	if (_displayedObjects == nil){
        
		self.fetchController = [AdviceRequest fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"(statusCode != %@)", AdviceRequestStatusCodeEditing] sortedBy:@"modifiedDate,createdDate" ascending:FALSE delegate:self];
		[self.fetchController performFetch:nil];
        
        NSMutableArray * displayArray = [@[] mutableCopy];
        
        //now grab responses for each and place in here
        for (AdviceRequest * request in [self.fetchController fetchedObjects]){
            [displayArray addObject:request];
            [displayArray addObjectsFromArray:[[request responses] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:TRUE],[NSSortDescriptor sortDescriptorWithKey:@"modifiedDate" ascending:TRUE]]]];
        }
        
		_displayedObjects = displayArray;
	}
	return _displayedObjects;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
	self.displayedObjects = nil;
	self.tvModel = nil;
	
	[self.tableView setDataSource:self.tvModel];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NITableViewCell
- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id <NSObject>)object{
	
    UITableViewCell * cell =  [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
    
    if ([cell isKindOfClass:[DOMyQuestionsRequestCell class]]){
        [(DOMyQuestionsRequestCell*)cell setDelegate:self];
    }if ([cell isKindOfClass:[DOMyQuestionsResponseCell class]]){
        [(DOMyQuestionsResponseCell*)cell setDelegate:self];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = tableView.rowHeight;
	id object = [(NITableViewModel *)tableView.dataSource objectAtIndexPath:indexPath];
    id nextObject = nil;
    if ([(NITableViewModel *)tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section] > indexPath.row + 1){
        nextObject = [(NITableViewModel *)tableView.dataSource objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    }
	id class = [object cellClass];
	
	double spacing = 0;
    if ([[nextObject class] isEqual:[AdviceRequest class]] || nextObject == nil){
        spacing = 280;
    }
	
	if ([class respondsToSelector:@selector(heightForObject:atIndexPath:tableView:)]) {
		height = [class heightForObject:object atIndexPath:indexPath tableView:tableView] + spacing;
	}
	return height;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EXLog(@"%@",@"didSelectRowAtIndexPath");

    id object = [(NITableViewModel *)tableView.dataSource objectAtIndexPath:indexPath];
    
    if ([object isKindOfClass:AdviceRequest.class]){
        [(AdviceRequest*)object setIsExpanded:@(!((AdviceRequest*)object).isExpanded.boolValue)];
    }else if ([object isKindOfClass:Response.class]){
        [(Response*)object setIsExpanded:@(!((Response*)object).isExpanded.boolValue)];
    }
    
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    EXLog(@"%@",@"accessoryButtonTappedForRowWithIndexPath");
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath  *)indexPath{
    EXLog(@"%@",@"shouldHighlightRowAtIndexPath");

    return TRUE;
}


#pragma mark - cells delegation
-(void) myQuestionsResponseCellCellWasTappedWithCell:(DOMyQuestionsResponseCell*)cell{
    
    EXLog(@"%@",@"myQuestionsResponseCellCellWasTappedWithCell");
    NSIndexPath * tappedIndexPath = [self.tableView indexPathForCell:cell];
    Response * response = [self.displayedObjects objectAtIndex:tappedIndexPath.row]; //not using any sections
    [response setIsExpanded:@(!response.isExpanded.boolValue)];
    
    [self.tableView reloadRowsAtIndexPaths:[self animationPartnerIndexPathsToIndexPath:tappedIndexPath] withRowAnimation:UITableViewRowAnimationFade];

}

-(void) helpfullButtonWasTappedWithMyQuestionsResponseCell:(DOMyQuestionsResponseCell*)cell{
    NSIndexPath * tappedIndexPath = [self.tableView indexPathForCell:cell];
    Response * response = [self.displayedObjects objectAtIndex:tappedIndexPath.row]; //not using any sections
    
    [self.tableView reloadRowsAtIndexPaths:[self animationPartnerIndexPathsToIndexPath:tappedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSNumber * newHelpfulValue = @(!response.isHelpful.boolValue);
    __block DOMyQuestionsVC * thisVC = self;
    
    
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSString * postPath = RKPathFromPatternWithObject(@"/api/v1/organizations/:adviceRequest.organization.urlFragment/advicerequest/:adviceRequest.adviceRequestID/advice/:responseID/advicehelpful?code=:adviceRequest.organization.usersAuthCode&token=:adviceRequest.accessToken", response);
    
    NSDictionary * params = @{@"helpful": newHelpfulValue.stringValue };
    [objectManager postObject:nil path:postPath parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        EXLog(@"Requested: %@", operation);
        EXLog(@"Posted: %@", [result array]);
        [response setIsHelpful:newHelpfulValue];
        [thisVC.tableView reloadRowsAtIndexPaths:[self animationPartnerIndexPathsToIndexPath:tappedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        EXLog(@"Requested: %@", operation);
        EXLog(@"failed: %@", [error description]);
        [thisVC.tableView reloadRowsAtIndexPaths:[self animationPartnerIndexPathsToIndexPath:tappedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (error.domain == NSURLErrorDomain){
            [CSNotificationView showInViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] style:CSNotificationViewStyleError message:NSLocalizedString(@"The server connection failed.\nIt'd be great if you'd try again later!", @"serverConnectionFailedNotSaved")];
        }else{
            [CSNotificationView showInViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] style:CSNotificationViewStyleError message:NSLocalizedString(@"Something in the app went wrong!\nIt'd be great if you'd try again later!", @"somethingInTheAppWentWrongNotSaved")];
        }
    }];
    
}



-(void) thankYouButtonWasTappedWithMyQuestionsResponseCell:(DOMyQuestionsResponseCell*)cell{
    NSIndexPath * tappedIndexPath = [self.tableView indexPathForCell:cell];
    Response * response = [self.displayedObjects objectAtIndex:tappedIndexPath.row]; //not using any sections
    
    
    NSNumber * newThankedValue = @(!response.responderThanked.boolValue);
    __block DOMyQuestionsVC * thisVC = self;
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSString * postPath = RKPathFromPatternWithObject(@"/api/v1/organizations/:adviceRequest.organization.urlFragment/advicerequest/:adviceRequest.adviceRequestID/advice/:responseID/advicethankyou?code=:adviceRequest.organization.usersAuthCode&token=:adviceRequest.accessToken", response);
    
    NSDictionary * params = @{@"thankyou": newThankedValue.stringValue};
    [objectManager postObject:nil path:postPath parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        EXLog(@"Requested: %@", operation);
        EXLog(@"Posted: %@", [result array]);
        [response setResponderThanked:newThankedValue];
        [thisVC.tableView reloadRowsAtIndexPaths:[self animationPartnerIndexPathsToIndexPath:tappedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        EXLog(@"Requested: %@", operation);
        EXLog(@"failed: %@", [error description]);
        [thisVC.tableView reloadRowsAtIndexPaths:[self animationPartnerIndexPathsToIndexPath:tappedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (error.domain == NSURLErrorDomain){
            [CSNotificationView showInViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] style:CSNotificationViewStyleError message:NSLocalizedString(@"The server connection failed.\nIt'd be great if you'd try again later!", @"serverConnectionFailedNotSaved")];
        }else{
            [CSNotificationView showInViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] style:CSNotificationViewStyleError message:NSLocalizedString(@"Something in the app went wrong!\nIt'd be great if you'd try again later!", @"somethingInTheAppWentWrongNotSaved")];
        }
    }];
}

-(void) myQuestionsRequestCellWasTappedWithCell:(DOMyQuestionsRequestCell *)cell{
    EXLog(@"%@",@"myQuestionsRequestCellWasTappedWithCell");
    NSIndexPath * tappedIndexPath = [self.tableView indexPathForCell:cell];
    AdviceRequest * request = [self.displayedObjects objectAtIndex:tappedIndexPath.row]; //not using any sections
    [request setIsExpanded:@(!request.isExpanded.boolValue)];
    
    [self.tableView reloadRowsAtIndexPaths:[self animationPartnerIndexPathsToIndexPath:tappedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(NSArray*)animationPartnerIndexPathsToIndexPath: (NSIndexPath*)path{

    // want to reload the cells beneath if necessary-- necessary to reload all cells underneath
    // need to 1) get index path of next cell 1.5) check if it's beyond array bounds 2) get object at that index path
    //    3)test cell as either AdviceRequest or AdviceResponse, if it's an AdviceResponse, add the index path to the array of animation partner, if it's an AdviceRequest, return the indexPath array
    
    NSMutableArray * setOfRefresehers = [@[path] mutableCopy];
    
    bool stillTesting = TRUE;
    NSIndexPath * nextIndexPath = path;
            nextIndexPath = [NSIndexPath indexPathForRow:nextIndexPath.row+1 inSection:nextIndexPath.section];
        if ([self.displayedObjects count] > nextIndexPath.row){
             NSObject * displayedObject = [self.displayedObjects objectAtIndex:nextIndexPath.row];
            if ([displayedObject isKindOfClass:[Response class]]){
                [setOfRefresehers addObject:nextIndexPath];
            }else{
                stillTesting = FALSE;
            }
        }
    
    return setOfRefresehers;
}


#pragma mark - based on unread count
-(void) updateUIForUnreadCount:(NSInteger)unreadCount animate:(BOOL)animated{
    
    
    __block DOMyQuestionsVC * bself = self;
    void (^updateBlock)(void) = ^{
        if (unreadCount == 0){
            bself.unreadResponsesLabel.alpha = 0;
        }else if (unreadCount > 0){
            bself.unreadResponsesLabel.alpha = 1;
        }
    };
    
    if (animated){
        UIColor * currentBGColor = self.view.backgroundColor;
        UIColor * flickerColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        
        [UIView animateWithDuration:.5 delay:.3 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationCurveEaseOut animations:^{
            updateBlock();
            
            if (unreadCount >0)
                [self.view setBackgroundColor:flickerColor];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionAllowAnimatedContent||UIViewAnimationCurveEaseIn animations:^{
                if (unreadCount >0)
                    [self.view setBackgroundColor:currentBGColor];
                
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        updateBlock();
    }
    
}

#pragma mark - custom paging tableview

-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    NSIndexPath* indexPath = nil;
    
        
    if (velocity.y > .1){
        //the issue is scrolling down when there is an AdviceResponse right before an AdviceRequest
        //soo, if we determine whether the advice request comes right before another response, we can make the offset enormous
        indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake((*targetContentOffset).x, (*targetContentOffset).y + scrollView.height/2)];
        NSIndexPath * fartherIndexPath = [self.tableView indexPathForRowAtPoint:CGPointMake((*targetContentOffset).x, (*targetContentOffset).y + scrollView.height/1.2)];
        if ( [(NSObject*)[(NITableViewModel *)self.tableView.dataSource objectAtIndexPath:fartherIndexPath] isKindOfClass:[AdviceRequest class]]){
            indexPath = fartherIndexPath;
        }
        
        //we don't futz if we're already scrolled all the way down
        if ((self.tableView.contentSize.height - (*targetContentOffset).y) > scrollView.height){
            (*targetContentOffset) = [self.tableView rectForRowAtIndexPath:indexPath].origin;
        }
    }else if (velocity.y < -.3){
        indexPath = [self.tableView indexPathForRowAtPoint:(*targetContentOffset)];
        (*targetContentOffset) = [self.tableView rectForRowAtIndexPath:indexPath].origin;
    }

}


@end
