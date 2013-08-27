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
    id nextObject = nil;
    if ([(NITableViewModel *)tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section] > indexPath.row + 1){
        nextObject = [(NITableViewModel *)tableView.dataSource objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    }
	id class = [object cellClass];
	
	double spacing = 0;
    if ([[nextObject class] isEqual:[AdviceRequest class]] || nextObject == nil){
        spacing = 320;
    }
	
	if ([class respondsToSelector:@selector(heightForObject:atIndexPath:tableView:)]) {
		height = [class heightForObject:object atIndexPath:indexPath tableView:tableView] + spacing;
	}
	return height;
}




@end
