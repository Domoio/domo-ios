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
#import "SupportArea.h"
#import "DOMyQuestionsRequestCell.h"

@implementation AdviceRequest

@dynamic adviceRequestID;
@dynamic modifiedDate;
@dynamic requestContent;
@dynamic createdDate;
@dynamic accessCode;
@dynamic responses;
@dynamic statusCode;
@dynamic organization;
@dynamic supportArea;
@dynamic organizationID;
@dynamic supportAreaIdentifier;
@dynamic isExpanded;



- (Class)cellClass{
	return [DOMyQuestionsRequestCell class];
}


-(void) awakeFromInsert{
    [super awakeFromInsert];

    [self setStatusCode:@(AdviceRequestStatusCodeEditing)];
    [self setCreatedDate:[NSDate date]];
    [self setModifiedDate:[self createdDate]];
}

+(AdviceRequest*) currentEditingAdviceRequestForActiveOrganization{
    return [self currentEditingAdviceRequestForOrganization:[Organization activeOrganization]];
}

+(AdviceRequest*) currentEditingAdviceRequestForOrganization:(Organization*)organization{
    NSPredicate * statusPredicate = [NSPredicate predicateWithFormat:@"(statusCode == %@)",@(AdviceRequestStatusCodeEditing)];
    NSPredicate * communityPred = [NSPredicate predicateWithFormat:@"(organization == %@)",organization];

    AdviceRequest* ar = [AdviceRequest findFirstWithPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[statusPredicate,communityPred]]];
    
    return ar;
}

+(RKEntityMapping*) entityMapping{
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(AdviceRequest.class) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"accessCode",@"adviceRequestID",@"createdDate",@"modifiedDate",@"organizationID",@"requestContent",@"supportAreaIdentifier"]];
    mapping.identificationAttributes = @[ @"adviceRequestID" ];

    RKConnectionDescription *organizationConnection = [[RKConnectionDescription alloc] initWithRelationship:([mapping.entity relationshipsByName][@"organization"]) attributes:@{ @"organizationID": @"organizationID" }];
    [mapping addConnection:organizationConnection];
    
    RKConnectionDescription *supportAreaConnection = [[RKConnectionDescription alloc] initWithRelationship:([mapping.entity relationshipsByName][@"supportArea"]) attributes:@{ @"supportAreaIdentifier": @"identifier" }];
    [mapping addConnection:supportAreaConnection];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"responses" mapping:[Response entityMapping]];
    
    return mapping;
}

+(RKObjectMapping*) requestMapping{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"accessCode",@"adviceRequestID",@"createdDate",@"modifiedDate",@"requestContent",@"supportAreaIdentifier"]];
    [requestMapping addRelationshipMappingWithSourceKeyPath:@"organization" mapping:[Organization requestMapping]];
    [requestMapping addRelationshipMappingWithSourceKeyPath:@"responses" mapping:[Response requestMapping]];
    
    return requestMapping;
}


@end
