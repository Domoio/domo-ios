//
//  Organization.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/1/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SupportArea.h"
#import "NICellFactory.h"

static NSString * const activeOrganizationChangedNotification = @"activeOrganizationChangedNotification";

@class AdviceRequest;

@interface Organization : NSManagedObject <NICellObject>
@property (nonatomic, retain) NSString * accessToken; //unused in Domoer app
@property (nonatomic, retain) NSString * organizationID;
@property (nonatomic, retain) NSString * urlFragment;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSNumber * isCurrentActive;
@property (nonatomic, retain) NSSet *supportAreas;
@property (nonatomic, retain) NSString * usersAuthCode; //the auth code for the user
@property (nonatomic, retain) NSString * usageDescription;
@property (nonatomic, retain) NSSet *adviceRequests;


+(Organization*) activeOrganization;

+(RKEntityMapping*) entityMapping;
+(RKObjectMapping*) requestMapping;
@end

@interface Organization (CoreDataGeneratedAccessors)

- (void)addSupportAreasObject:(SupportArea *)value;
- (void)removeSupportAreasObject:(SupportArea *)value;
- (void)addSupportAreas:(NSSet *)values;
- (void)removeSupportAreas:(NSSet *)values;

- (void)addAdviceRequestsObject:(AdviceRequest *)value;
- (void)removeAdviceRequestsObject:(AdviceRequest *)value;
- (void)addAdviceRequests:(NSSet *)values;
- (void)removeAdviceRequests:(NSSet *)values;

@end
