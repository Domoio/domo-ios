//
//  DOMyQuestionsVC.m
//  Domo
//
//  Created by Alexander List on 6/27/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOMyQuestionsVC.h"
#import "AdviceRequest.h"

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
		self.fetchController = [AdviceRequest fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"modifiedDate" ascending:FALSE delegate:self];
		[self.fetchController performFetch:nil];
        
        //now grab responses for each and place in here
		_displayedObjects = [self.fetchController fetchedObjects];
	}
	return _displayedObjects;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
	self.displayedObjects = [self.fetchController fetchedObjects];
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
	
	return  [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = tableView.rowHeight;
	id object = [(NITableViewModel *)tableView.dataSource objectAtIndexPath:indexPath];
	id class = [object cellClass];
	
	const double spacing = 320;
	
	if ([class respondsToSelector:@selector(heightForObject:atIndexPath:tableView:)]) {
		height = [class heightForObject:object atIndexPath:indexPath tableView:tableView] + spacing;
	}
	return height;
}




@end
