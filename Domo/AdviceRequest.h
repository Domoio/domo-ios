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



static NSString * const AdviceRequestStatusCodeEditing = @"EDITING";
static NSString * const AdviceRequestStatusCodePendingSubmission = @"PSUB"; //local flag
static NSString * const AdviceRequestStatusCodePendingApproval = @"PAPP";
static NSString * const AdviceRequestStatusCodePendingResponse = @"PRES";


@class Organization;

@interface AdviceRequest : NSManagedObject <NICellObject>

@property (nonatomic, retain) NSString * accessToken; //the access code given to users for future access
@property (nonatomic, retain) NSString * adviceRequestID;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * requestContent;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * subscriberID;
@property (nonatomic, retain) NSNumber * isExpanded;
@property (nonatomic, retain) NSSet *responses;
@property (nonatomic, retain) NSString * statusCode; //AdviceRequestStatusCode NSString
@property (nonatomic, retain) NSString * supportAreaIdentifier;
@property (nonatomic, retain) NSDate * lastUpdatedDate;
@property (nonatomic, retain) Organization *organization;
@property (nonatomic, retain) SupportArea *supportArea;
@property (nonatomic, retain) NSString * organizationID;



+(AdviceRequest*) currentEditingAdviceRequestForOrganization:(Organization*)organization;
+(AdviceRequest*) currentEditingAdviceRequestForActiveOrganization;


+(RKEntityMapping*) entityMapping;
+(RKObjectMapping*) requestMapping;

-(void) generateTempUUID;
@end


@interface AdviceRequest (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(NSManagedObject *)value;
- (void)removeResponsesObject:(NSManagedObject *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;

@end
