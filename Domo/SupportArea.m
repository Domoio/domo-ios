//
//  SupportArea.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/12/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "SupportArea.h"
#import "Organization.h"
#import "DOSupportAreaCell.h"

@implementation SupportArea

@dynamic identifier;
@dynamic isCurrentActive;
@dynamic name;
@dynamic organization;
@dynamic adviceRequests;


+(SupportArea*) activeSupportAreaForOrganization:(Organization*)organization{
    NSPredicate * isActivePredicate = [NSPredicate predicateWithFormat:@"(isCurrentActive == TRUE)"];
    NSPredicate * communityPred = [NSPredicate predicateWithFormat:@"(organization == %@)",organization];
   
    NSPredicate * pred = [NSCompoundPredicate andPredicateWithSubpredicates:@[communityPred,isActivePredicate]];
    
    NSArray * activeAreas = [SupportArea findAllSortedBy:@"name" ascending:TRUE withPredicate:pred];
    NSAssert(([activeAreas count] <= 1), @"too many active areas aren't healthy, coder");
    
    if ([activeAreas count] ==1){
        return activeAreas[0];
    }
    
    return nil;
}


+(SupportArea*) activeSupportAreaForActiveOrganization{
    return [self activeSupportAreaForOrganization:[Organization activeOrganization]];
}

+(RKEntityMapping*) entityMapping{
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(SupportArea.class) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"identifier",@"name"]];
    
    return mapping;
}

+(RKObjectMapping*) requestMapping{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"identifier",@"name"]];
    
    return requestMapping;
}


- (Class)cellClass{
	return [DOSupportAreaCell class];
}


@end
