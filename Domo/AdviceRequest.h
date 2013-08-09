//
//  AdviceRequest.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/1/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AdviceRequest : NSManagedObject

@property (nonatomic, retain) NSString * adviceRequestID;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * supportArea;
@property (nonatomic, retain) NSString * requestContent;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * accessCode;
@property (nonatomic, retain) NSSet *responses;
@property (nonatomic, retain) NSManagedObject *organization;

+(RKEntityMapping*) entityMapping;
@end


@interface AdviceRequest (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(NSManagedObject *)value;
- (void)removeResponsesObject:(NSManagedObject *)value;
- (void)addResponses:(NSSet *)values;
- (void)removeResponses:(NSSet *)values;

@end
