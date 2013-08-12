//
//  SupportArea.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/12/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "SupportArea.h"
#import "Organization.h"


@implementation SupportArea

@dynamic identifier;
@dynamic name;
@dynamic organization;
@dynamic adviceRequests;

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


@end
