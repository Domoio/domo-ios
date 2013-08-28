//
//  DOSupportAreaChooserVC.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/27/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOSupportAreaChooserVC.h"
#import <QuartzCore/QuartzCore.h>
#import "NICellFactory.h"
#import "Organization.h"

@interface DOSupportAreaChooserVC ()
-(NSPredicate *) searchPredicate;
-(void) updateSearch;
@end


@implementation DOSupportAreaChooserVC

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"DOSupportAreaChooserVC-iPhone" bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.chooserView.layer.cornerRadius = 2;
    self.chooserView.layer.shadowRadius = 8;
    self.chooserView.layer.shadowColor = UIColor.blackColor.CGColor;
	self.chooserView.layer.shadowOffset = CGSizeMake(0, 1);
	self.chooserView.layer.shadowOpacity = 0.3f;
    
    UIBezierPath * coolPath = nil;
    
    
    coolPath = [UIBezierPath bezierPath];
    [coolPath moveToPoint:CGPointZero];
    [coolPath addLineToPoint:CGPointMake(self.chooserView.width, 0)];
    [coolPath addLineToPoint:CGPointMake(self.chooserView.width, self.chooserView.height)];
    [coolPath addQuadCurveToPoint:CGPointMake(0, self.chooserView.height) controlPoint:CGPointMake(self.chooserView.width/2.0f, self.chooserView.height/1.072f)];
    [coolPath addLineToPoint:CGPointZero];
    [coolPath closePath];
    
    self.chooserView.layer.shadowPath = coolPath.CGPath;
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self.tvModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeOrganizationUpdated:) name:activeOrganizationChangedNotification object:nil];
    
}

-(void) activeOrganizationUpdated:(id)sender{
    [self updateSearch];
}


- (IBAction)chooserBackgroundViewTapped:(UITapGestureRecognizer *)sender {
    [self.delegate supportAreaChooserDidFinish:self];
}

-(NSFetchedResultsController*)fetchController{
    //compound predicate by name or if is current is true
    //sort by first is active then by name
    if (_fetchController == nil){
        self.fetchController = [SupportArea fetchAllGroupedBy:nil withPredicate:[self searchPredicate] sortedBy:nil ascending:FALSE delegate:self];
        [self.fetchController.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:TRUE]]];
        [self.fetchController performFetch:nil];
    }
    return _fetchController;
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
    
    
    NSMutableArray * preds = [@[] mutableCopy];
        
    NSPredicate *searchQueryPredicate = [NSPredicate predicateWithFormat:@"name.length > 0"];
    [preds addObject:searchQueryPredicate];
    
    NSPredicate * isActivePredicate = [NSPredicate predicateWithFormat:@"(isCurrentActive == TRUE)"];
    [preds addObject:isActivePredicate];
    
    NSPredicate * communityPred = [NSPredicate predicateWithFormat:@"(organization == %@)",[Organization activeOrganization]];
    
    NSPredicate * pred = [NSCompoundPredicate andPredicateWithSubpredicates:@[communityPred,[NSCompoundPredicate orPredicateWithSubpredicates:preds]]];
    
    return pred;
}

-(NSArray*)displayedObjects{
	if (_displayedObjects == nil){
		_displayedObjects = [self.fetchController fetchedObjects];
	}
	return _displayedObjects;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
	self.displayedObjects = [self.fetchController fetchedObjects];
    
    for (SupportArea * sArea in self.displayedObjects){
        if ([sArea.isCurrentActive boolValue] == TRUE){
            NSMutableArray * mut = [self.displayedObjects mutableCopy];
            [mut removeObject:sArea];
            [mut insertObject:sArea atIndex:0];
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
    
    
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        SupportArea * selectedSupportArea = [[self displayedObjects] objectAtIndex:indexPath.row];
        if ([[selectedSupportArea isCurrentActive] boolValue] == FALSE){
            //unset "active" community, set "active" community
            
            SupportArea * currentActive = [SupportArea activeSupportAreaForActiveOrganization];

            [currentActive setIsCurrentActive:@(NO)];
            
            [selectedSupportArea setIsCurrentActive:@(YES)];
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
        }
        
    });
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



@implementation chooserBackgroundView //shout-outs to SIAlertView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.backgroundColor = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t locationsCount = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) ;
    CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

@end