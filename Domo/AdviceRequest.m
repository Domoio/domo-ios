//
//  AdviceRequest.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/1/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "AdviceRequest.h"
#import "Response.h"


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
    [mapping addAttributeMappingsFromArray:@[@"accessCode",@"adviceRequestID",@"createdDate",@"modifiedDate",@"organizationID",@"requestContent",@"supportAreaIdentifier"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"responses" mapping:[Response entityMapping]];
    
    return mapping;
}
@end
