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

+(RKEntityMapping*) entityMapping{
    RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(SupportArea.class) inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];
    [mapping addAttributeMappingsFromArray:@[@"identifier",@"name"]];
    
    return mapping;
}

@end
