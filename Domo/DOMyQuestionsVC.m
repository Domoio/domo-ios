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
        
		self.fetchController = [AdviceRequest fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"(statusCode != %@)", AdviceRequestStatusCodeEditing] sortedBy:@"modifiedDate" ascending:FALSE delegate:self];
		[self.fetchController performFetch:nil];
        
        NSMutableArray * displayArray = [@[] mutableCopy];
        
        //now grab responses for each and place in here
        for (AdviceRequest * request in [self.fetchController fetchedObjects]){
            [displayArray addObject:request];
            [displayArray addObjectsFromArray:[[request responses] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"modifiedDate" ascending:FALSE]]]];
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
    NSLog(@"%@",@"didSelectRowAtIndexPath");

    id object = [(NITableViewModel *)tableView.dataSource objectAtIndexPath:indexPath];
    
    if ([object isKindOfClass:AdviceRequest.class]){
        [(AdviceRequest*)object setIsExpanded:@(!((AdviceRequest*)object).isExpanded.boolValue)];
    }else if ([object isKindOfClass:Response.class]){
        [(Response*)object setIsExpanded:@(!((Response*)object).isExpanded.boolValue)];
    }
    
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",@"accessoryButtonTappedForRowWithIndexPath");
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath  *)indexPath{
    NSLog(@"%@",@"shouldHighlightRowAtIndexPath");

    return TRUE;
}


#pragma mark - cells delegation
-(void) myQuestionsResponseCellCellWasTappedWithCell:(DOMyQuestionsResponseCell*)cell{
    NSLog(@"%@",@"myQuestionsResponseCellCellWasTappedWithCell");

}

-(void) myQuestionsRequestCellWasTappedWithCell:(DOMyQuestionsRequestCell *)cell{
    NSLog(@"%@",@"myQuestionsRequestCellWasTappedWithCell");
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
