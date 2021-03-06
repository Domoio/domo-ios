//
//  Response.h
//  Domo
//
//  Created by Alexander Hoekje List on 8/1/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NICellFactory.h"

@class AdviceRequest;

@interface Response : NSManagedObject <NICellObject>

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * responseID;
@property (nonatomic, retain) NSString * responseContent;
@property (nonatomic, retain) NSString * responderDisplayName;
@property (nonatomic, retain) NSNumber * isHelpful;
@property (nonatomic, retain) NSNumber * responderThanked;
@property (nonatomic, retain) NSNumber * isExpanded;
@property (nonatomic, retain) AdviceRequest *adviceRequest;

+(RKEntityMapping*) entityMapping;
+(RKObjectMapping*) requestMapping;
@end
