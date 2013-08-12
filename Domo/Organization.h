//
//  Organization.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/1/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AdviceRequest;

@interface Organization : NSManagedObject

@property (nonatomic, retain) NSString * organizationID;
@property (nonatomic, retain) NSString * displayNameString;
@property (nonatomic, retain) NSData * supportAreas;
@property (nonatomic, retain) NSString * usersAuthCode;
@property (nonatomic, retain) NSString * usageDescription;
@property (nonatomic, retain) NSSet *adviceRequests;


+(RKEntityMapping*) entityMapping;
@end

@interface Organization (CoreDataGeneratedAccessors)

- (void)addAdviceRequestsObject:(AdviceRequest *)value;
- (void)removeAdviceRequestsObject:(AdviceRequest *)value;
- (void)addAdviceRequests:(NSSet *)values;
- (void)removeAdviceRequests:(NSSet *)values;

@end
