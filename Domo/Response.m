//
//  Response.m
//  Domo
//
//  Created by Alexander Hoekje List on 8/1/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "Response.h"
#import "AdviceRequest.h"
#import "DOMyQuestionsResponseCell.h"


@implementation Response

@dynamic modifiedDate;
@dynamic responseID;
@dynamic responseContent;
@dynamic responderDisplayName;
@dynamic isHelpful;
@dynamic responderThanked;
@dynamic isExpanded;
@dynamic adviceRequest;


- (Class)cellClass{
	return [DOMyQuestionsResponseCell class];
}


+(RKEntityMapping*) entityMapping{
    
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(Response.class) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    
    [mapping addAttributeMappingsFromArray:@[@"isHelpful",@"modifiedDate",@"responderDisplayName",@"responderThanked",@"responseContent",@"responseID"]];
    mapping.identificationAttributes = @[ @"responseID" ];

    return mapping;
}

+(RKObjectMapping*) requestMapping{
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"isHelpful",@"modifiedDate",@"responderDisplayName",@"responderThanked",@"responseContent",@"responseID"]];
    
    
    return requestMapping;
}


@end
