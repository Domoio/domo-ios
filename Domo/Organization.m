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
@dynamic displayName;
@dynamic supportAreas;
@dynamic usersAuthCode;
@dynamic usageDescription;
@dynamic adviceRequests;


+(RKEntityMapping*) entityMapping{
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(Organization.class) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"accessToken",@"displayName",@"organizationID",@"usageDescription"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"supportAreas" mapping:[SupportArea entityMapping]];
    mapping.identificationAttributes = @[ @"organizationID" ];
    
    return mapping;
}

+(RKObjectMapping*) requestMapping{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"accessToken",@"displayName",@"organizationID",@"usageDescription"]];
    [requestMapping addRelationshipMappingWithSourceKeyPath:@"responses" mapping:[SupportArea requestMapping]];

    return requestMapping;
}


@end
