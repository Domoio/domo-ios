//
//  DOCommunityChooserVC.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/13/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOCommunityChooserVC.h"
#import <QuartzCore/QuartzCore.h>
#import "NICellFactory.h"
#import "UIResponder+FirstResponder.h"


@interface DOCommunityChooserVC ()
-(NSPredicate *) searchPredicate;
-(void) updateSearch;
@end

@implementation DOCommunityChooserVC

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"DOCommunityChooserVC-iPhone" bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.communityChooserView.layer.cornerRadius = 2;
    self.communityChooserView.layer.shadowRadius = 8;
    self.communityChooserView.layer.shadowColor = UIColor.blackColor.CGColor;
	self.communityChooserView.layer.shadowOffset = CGSizeMake(0, 1);
	self.communityChooserView.layer.shadowOpacity = 0.3f;
    
    UIBezierPath * coolPath = nil;
    
    
    coolPath = [UIBezierPath bezierPath];
    [coolPath moveToPoint:CGPointZero];
    [coolPath addLineToPoint:CGPointMake(self.communityChooserView.width, 0)];
    [coolPath addLineToPoint:CGPointMake(self.communityChooserView.width, self.communityChooserView.height)];
    [coolPath addQuadCurveToPoint:CGPointMake(0, self.communityChooserView.height) controlPoint:CGPointMake(self.communityChooserView.width/2.0f, self.communityChooserView.height/1.072f)];
    [coolPath addLineToPoint:CGPointZero];
    [coolPath closePath];

    self.communityChooserView.layer.shadowPath = coolPath.CGPath;
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self.tvModel];
    
    if ([self.tableView respondsToSelector:@selector(separatorInset)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //wait till we know the onboarding pathway to jump to conclusions like this..
//    [self.communityNameTextField becomeFirstResponder];
}


-(DOCommunityChooserCodeEntryVC*)codeEntryVC{
    if (_codeEntryVC == nil){
        _codeEntryVC = [[DOCommunityChooserCodeEntryVC alloc] init];
        [_codeEntryVC.view setFrame:self.communityChooserView.bounds];
        [_codeEntryVC setDelegate:self];
    }
    return _codeEntryVC;
}


- (IBAction)communityChooserBackgroundViewTapped:(UITapGestureRecognizer *)sender {
    [self.delegate communityChooserDidFinish:self];
}

- (IBAction)communityNameTextFieldChanged:(id)sender {

    [self updateSearch];
}

- (IBAction)domoInfoButtonTapped:(id)sender {
    [self.delegate domoInfoButtonTappedOnCommunityChooser:self];
}

-(void) updateSearch{
    [self.fetchController.fetchRequest setPredicate:[self searchPredicate]];
    [self.fetchController performFetch:nil];
    _displayedObjects = [self.fetchController fetchedObjects];
	self.tvModel = nil;
	
	[self.tableView setDataSource:self.tvModel];
	[self.tableView reloadData];
}



#pragma mark - data and table

-(NITableViewModel*)tvModel{
	if (_tvModel == nil){
		NSMutableArray * array = [NSMutableArray array];
		[array addObjectsFromArray:self.displayedObjects];
		
		self.displayedObjects = array;
		_tvModel = [[NITableViewModel alloc] initWithSectionedArray:array delegate:self];
		
	}
	return _tvModel;
}

-(NSPredicate *) searchPredicate{
    
    NSString * searchQuery = self.communityNameTextField.text;
    
    NSMutableArray * preds = [@[] mutableCopy];

    NSPredicate * searchQueryPredicate = nil;
    if (StringHasText(searchQuery) && [searchQuery length] > 0){
        searchQueryPredicate = [NSPredicate predicateWithFormat:@"( displayName contains[cd] %@ OR urlFragment contains[cd] %@ )", searchQuery,searchQuery];
        [preds addObject:searchQueryPredicate];
    }
    
    else{
        searchQueryPredicate = [NSPredicate predicateWithFormat:@"displayName.length > 0"];
        [preds addObject:searchQueryPredicate];
    }
    
    NSPredicate * isActivePredicate = [NSPredicate predicateWithFormat:@"(isCurrentActive == TRUE)"];
    [preds addObject:isActivePredicate];
    
    NSPredicate * hasCodeEnteredPredicate = [NSPredicate predicateWithFormat:@"(usersAuthCode != nil)"];
    [preds addObject:hasCodeEnteredPredicate];
    
    NSPredicate * pred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];
    
    return pred;
}

-(NSArray*)displayedObjects{
	if (_displayedObjects == nil){
        //compound predicate by name or if is current is true
        //sort by first is active then by name
		self.fetchController = [Organization fetchAllGroupedBy:nil withPredicate:[self searchPredicate] sortedBy:nil ascending:FALSE delegate:self];
        [self.fetchController.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"isCurrentActive" ascending:FALSE],[NSSortDescriptor sortDescriptorWithKey:@"usersAuthCode" ascending:FALSE],[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:TRUE]]];
		[self.fetchController performFetch:nil];
		_displayedObjects = [self.fetchController fetchedObjects];
	}
	return _displayedObjects;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
	self.displayedObjects = [self.fetchController fetchedObjects];
    
    for (Organization * org in self.displayedObjects){
        if ([org.isCurrentActive boolValue] == TRUE){
            NSMutableArray * mut = [self.displayedObjects mutableCopy];
            [mut removeObject:org];
            [mut insertObject:org atIndex:0];
            self.displayedObjects = mut;
            break;
        }
    }
    
	self.tvModel = nil;
	
	[self.tableView setDataSource:self.tvModel];
	[self.tableView reloadData];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //unset "active" community, set "active" community, then tell delegate
//    [self.delegate communityChooserDidFinish:self];
    
    
    double delayInSeconds = 0.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        Organization * selectedOrganization = [[self displayedObjects] objectAtIndex:indexPath.row];
//        if ([[selectedOrganization isCurrentActive] boolValue] == FALSE){
            //unset "active" community, set "active" community
            
            __block DOCommunityChooserVC * bself = self;
            updateAndDismissBlock = ^ {
                Organization * currentActive = [Organization findFirstByAttribute:@"isCurrentActive" withValue:@(YES)];
                [currentActive setIsCurrentActive:@(NO)];
                
                [selectedOrganization setIsCurrentActive:@(YES)];
                [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *saveError) {
                    if (saveError){
                        EXLog(@"darn, a save error. %@",saveError);
                    }
                }];
                
                
                [bself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:activeOrganizationChangedNotification object:selectedOrganization];
                [bself.delegate communityChooserDidSelectOrganization:selectedOrganization withChooser:bself];
                [bself.delegate communityChooserDidFinish:bself];
            };
            
            [self.codeEntryVC setEvaluatingOrganization:selectedOrganization];
            [UIView beginAnimations:@"flip" context:nil];
            
            [self.communityChooserView addSubview:self.codeEntryVC.view];
            
            [UIView setAnimationDuration:.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.communityChooserView cache:FALSE];
            [UIView commitAnimations];
            
//        }

    });
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[[[UIResponder new] currentFirstResponder] resignFirstResponder];
}

#pragma mark - NITableViewCell
- (UITableViewCell *)tableViewModel: (NITableViewModel *)tableViewModel
                   cellForTableView: (UITableView *)tableView
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id <NSObject>)object{
	
	UITableViewCell * cell =  [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
    
    if ([[[[self displayedObjects] objectAtIndex:indexPath.row] isCurrentActive] boolValue]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = tableView.rowHeight;
	id object = [(NITableViewModel *)tableView.dataSource objectAtIndexPath:indexPath];
	id class = [object cellClass];
	
	const double spacing = 0;
	
	if ([class respondsToSelector:@selector(heightForObject:atIndexPath:tableView:)]) {
		height = [class heightForObject:object atIndexPath:indexPath tableView:tableView] + spacing;
	}
	return height;
}


//other

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark delegation
-(void) codeEntryVCDidCancel:(DOCommunityChooserCodeEntryVC*)vc{
    [UIView beginAnimations:@"flip" context:nil];
    
    [self.codeEntryVC.view removeFromSuperview];
    
    [UIView setAnimationDuration:.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.communityChooserView cache:FALSE];
    [UIView commitAnimations];
    

}
-(void) codeEntryVCDidCompleteSuccesfull:(DOCommunityChooserCodeEntryVC*)vc{
    [self codeEntryVCDidCancel:vc];
    
    double delayInSeconds = .5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        updateAndDismissBlock();
        updateAndDismissBlock = nil;
    });
    
}



@end

