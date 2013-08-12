//
//  AdviceRequest.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/1/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "AdviceRequest.h"
#import "Response.h"
#import "Organization.h"

@implementation AdviceRequest

@dynamic adviceRequestID;
@dynamic modifiedDate;
@dynamic supportArea;
@dynamic requestContent;
@dynamic createdDate;
@dynamic accessCode;
@dynamic responses;
@dynamic organization;


+(RKEntityMapping*) entityMapping{
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(AdviceRequest.class) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"accessCode",@"adviceRequestID",@"createdDate",@"modifiedDate",@"requestContent",@"supportAreaIdentifier"]];
    mapping.identificationAttributes = @[ @"adviceRequestID" ];
    [mapping addRelationshipMappingWithSourceKeyPath:@"organizationID" mapping:[Organization entityMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"responses" mapping:[Response entityMapping]];
    
    return mapping;
}

+(RKObjectMapping*) requestMapping{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"accessCode",@"adviceRequestID",@"createdDate",@"modifiedDate",@"requestContent",@"supportAreaIdentifier"]];
    [requestMapping addRelationshipMappingWithSourceKeyPath:@"organizationID" mapping:[Organization requestMapping]];
    [requestMapping addRelationshipMappingWithSourceKeyPath:@"responses" mapping:[Response requestMapping]];
    
    return requestMapping;
}


@end
