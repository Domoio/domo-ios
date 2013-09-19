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
#import "DOCommunityCell.h"


@implementation Organization
@dynamic accessToken;
@dynamic organizationID;
@dynamic urlFragment;
@dynamic displayName;
@dynamic isCurrentActive;
@dynamic supportAreas;
@dynamic usersAuthCode;
@dynamic usageDescription;
@dynamic adviceRequests;


+(Organization*)activeOrganization{
    Organization * currentActive = [Organization findFirstByAttribute:@"isCurrentActive" withValue:@(YES)];
    return currentActive;
}

+(RKEntityMapping*) entityMapping{
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(Organization.class) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"accessToken",@"displayName",@"usageDescription"]];
    [mapping addAttributeMappingsFromDictionary:@{@"_id": @"organizationID"}]; //source, destination
    [mapping addAttributeMappingsFromDictionary:@{@"orgURL": @"urlFragment"}]; //source, destination
    [mapping addAttributeMappingsFromDictionary:@{@"code": @"usersAuthCode"}]; //source, destination
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

- (Class)cellClass{
	return [DOCommunityCell class];
}


@end
