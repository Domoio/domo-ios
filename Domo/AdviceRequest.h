//
//  AdviceRequest.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/1/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SupportArea.h"
#import "NICellFactory.h"



@interface AdviceRequest : NSManagedObject <NICellObject>

@property (nonatomic, retain) NSString * adviceRequestID;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * requestContent;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * accessCode;
@property (nonatomic, retain) NSSet *responses;
@property (nonatomic, retain) NSManagedObject *organization;
@property (nonatomic, retain) SupportArea *supportArea;
@property (nonatomic, retain) NSString * organizationID;
@property (nonatomic, retain) NSString * supportAreaIdentifier;
@property (nonatomic, retain) NSNumber * isExpanded;


+(RKEntityMapping*) entityMapping;
+(RKObjectMapping*) requestMapping;
@end


@interface AdviceRequest (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(NSManagedObject *)value;
- (void)removeResponsesObject:(NSManagedObject *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;

@end
