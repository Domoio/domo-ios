//
//  SupportArea.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/12/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NICellFactory.h"

@class Organization;

@interface SupportArea : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isCurrentActive;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Organization *organization;
@property (nonatomic, retain) NSSet *adviceRequests;


+(SupportArea*) activeSupportAreaForOrganization:(Organization*)organization;
+(SupportArea*) activeSupportAreaForActiveOrganization;

+(RKEntityMapping*) entityMapping;
+(RKObjectMapping*) requestMapping;
@end
