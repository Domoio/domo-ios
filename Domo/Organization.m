//
//  Organization.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/1/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "Organization.h"
#import "AdviceRequest.h"
#import "SupportArea.h"


@implementation Organization

@dynamic organizationID;
@dynamic displayNameString;
@dynamic supportAreas;
@dynamic usersAuthCode;
@dynamic usageDescription;
@dynamic adviceRequests;


+(RKEntityMapping*) entityMapping{
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(Organization.class) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"accessToken",@"displayName",@"organizationID",@"usageDescription"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"SupportAreas" mapping:[SupportArea entityMapping]];
    mapping.identificationAttributes = @[ @"organizationID" ];
    
    return mapping;
}
@end
