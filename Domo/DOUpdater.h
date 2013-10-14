//
//  DOUpdater.h
//  Domo
//
//  Created by Alexander Hoekje List on 10/14/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOUpdater : NSObject{
    
}

@property (nonatomic, strong) NSString * subscriberId;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * pushNotificationID;


-(void) updateSubscriberIDWithPushNotificationID:(NSString*)pushNotificationID;
-(void) registerForSubscriberID; //registers for a SubscriberID if one is needed

+(BOOL) pushNotificationsActive;
+(void) registerForNotificationsIfPushNotificationsActive;
+(void) registerForNotificationsAndAskPermission;

+(NSString*) localSubscriberID;

@end
