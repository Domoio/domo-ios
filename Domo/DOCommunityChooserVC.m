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
    
}


- (IBAction)communityChooserBackgroundViewTapped:(UITapGestureRecognizer *)sender {
    [self.delegate communityChooserDidFinish:self];
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

-(NSArray*)displayedObjects{
	if (_displayedObjects == nil){
        //compound predicate by name or if is current is true
        //sort by first is active then by name
		self.fetchController = [Organization fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"displayName" ascending:TRUE delegate:self];
		[self.fetchController performFetch:nil];
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //unset "active" community, set "active" community, then tell delegate
//    [self.delegate communityChooserDidFinish:self];
    
    
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        Organization * selectedOrganization = [[self displayedObjects] objectAtIndex:indexPath.row];
        if ([[selectedOrganization isCurrentActive] boolValue] == FALSE){
            //unset "active" community, set "active" community
            Organization * currentActive = [Organization findFirstByAttribute:@"isCurrentActive" withValue:@(YES)];
            [currentActive setIsCurrentActive:@(NO)];
            
            [selectedOrganization setIsCurrentActive:@(YES)];
            
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



@end



@implementation communityChooserBackgroundView //shout-outs to SIAlertView
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