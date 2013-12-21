//
//  DOUpdater.m
//  Domo
//
//  Created by Alexander Hoekje List on 10/14/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "DOUpdater.h"
#import "Organization.h"
#import "AdviceRequest.h"
#import "UIDevice+Hardware.h"

@implementation DOUpdater
@synthesize subscriberId = _subscriberId;
@synthesize pushNotificationID = _pushNotificationID;
@synthesize deviceId = _deviceId;
@synthesize adviceRequestUpdateController = _adviceRequestUpdateController;

+(BOOL) pushNotificationsActive{
    return ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] > UIRemoteNotificationTypeNone);
}

+(void) registerForNotificationsIfPushNotificationsActive{
    if ([DOUpdater pushNotificationsActive]){
        [self registerForNotificationsAndAskPermission];
    }

}
+(void) registerForNotificationsAndAskPermission{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
}

+(NSString*) localSubscriberID{
   return [[[DOUpdater alloc] init] subscriberId];
}
-(NSString*) pushNotificationID{
    if (_pushNotificationID == nil){
        _pushNotificationID = [[NSUserDefaults standardUserDefaults] valueForKey:pushNotificationTokenUserConstant];
    }
    return _pushNotificationID;
}

-(void) setPushNotificationID:(NSString *)pushNotificationID{
    _pushNotificationID = pushNotificationID;
    [[NSUserDefaults standardUserDefaults] setValue:pushNotificationID forKey:pushNotificationTokenUserConstant];
}

-(NSString*) subscriberId{
    if (_subscriberId == nil){
        _subscriberId = [[NSUserDefaults standardUserDefaults] valueForKey:subscriberTokenUserConstant];
        
    }
    return _subscriberId;
}

-(void) setSubscriberId:(NSString *)subscriberId{
    _subscriberId = subscriberId;
    [[NSUserDefaults standardUserDefaults] setValue:subscriberId forKey:subscriberTokenUserConstant];
}

-(NSString*) deviceId{
    if (_deviceId == nil){
        _deviceId = [[NSUserDefaults standardUserDefaults] valueForKey:deviceIdUserConstant];
        
    }
    return _deviceId;
}

-(void) setDeviceId:(NSString *)deviceId{
    _deviceId = deviceId;
    [[NSUserDefaults standardUserDefaults] setValue:deviceId forKey:deviceIdUserConstant];
}


#pragma mark - updates
-(NSArray*) adviceRequestsToUpdateByOrganization{
    if (_adviceRequestUpdateController == nil){
        NSDate * beforeDate = [NSDate dateWithTimeIntervalSinceNow:-60];
        NSPredicate * updatedBeforePredicate = [NSPredicate predicateWithFormat:@"(lastUpdatedDate < %@ OR lastUpdatedDate == nil)",beforeDate];
        NSPredicate * notLocalPredicate = [NSPredicate predicateWithFormat:@"accessToken != nil" argumentArray:nil];
        _adviceRequestUpdateController = [AdviceRequest fetchAllSortedBy:@"lastUpdatedDate" ascending:TRUE withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[updatedBeforePredicate,notLocalPredicate]] groupBy:@"organization" delegate:self];
        NSError * error = nil;
        [_adviceRequestUpdateController performFetch:&error];
        if (error){
            EXLog(@"Fetch error %@",error);
        }
    }
    
    
    NSMutableArray * objectsBySection = [@[] mutableCopy];
    for (NSObject<NSFetchedResultsSectionInfo> * section in [_adviceRequestUpdateController sections]){
        [objectsBySection addObject:[section objects]];
    }
    
    return objectsBySection;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
}

-(void) updateFromServer:(BOOL)force{
    
    NSDate * lastUpdateDate = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdateDateUserDefault];
    if (abs([lastUpdateDate timeIntervalSinceNow]) < 60  && lastUpdateDate != nil){
        if (force == FALSE){
            return;
        }else{ //forcing, but make sure it didn't JUST happen
            if (abs([lastUpdateDate timeIntervalSinceNow]) < 3 ){
                return;
            }else{
                //force but greater 5 secs, so perhaps not incidental
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:lastUpdateDateUserDefault];
    
    
    NSArray * objectsBySection = [self adviceRequestsToUpdateByOrganization];
    for (NSArray * sectionObjects in objectsBySection){
        Organization * orgForSection = [[sectionObjects firstObject] organization];
        
        NSMutableArray * requestsToUpdate = [@[] mutableCopy];
        
        for (AdviceRequest * adviceRequest in sectionObjects){
            //accessToken is often nil
            [requestsToUpdate addObject:@{@"adviceRequestId": adviceRequest.adviceRequestID, @"accessToken":adviceRequest.accessToken}];
        }
        
        
        NSString* requestPath = [NSString stringWithFormat:@"/api/v1/organizations/%@/advicerequest/getall?code=%@", orgForSection.urlFragment, orgForSection.usersAuthCode];

        RKObjectManager *objectManager = [RKObjectManager sharedManager];

        NSDictionary * requestBody = @{@"adviceRequestList": requestsToUpdate};
        
        [objectManager postObject:nil path:requestPath parameters:requestBody success:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
            
            
            if (force)
                [CSNotificationView showInViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] style:CSNotificationViewStyleSuccess message:NSLocalizedString(@"Updated advice requests!", @"updatedAdviceRequestsSuccessfully")];
            
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            EXLog(@"Requested: %@", operation);
            EXLog(@"failed: %@", [error description]);
            
            if (error.domain == NSURLErrorDomain){
                [CSNotificationView showInViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] style:CSNotificationViewStyleError message:NSLocalizedString(@"The server connection failed.\nYour request is safe here!", @"serverConnectionFailedButDataSaved")];
            }
            
            if ([error.domain isEqualToString:@"org.restkit.RestKit.ErrorDomain"] && error.code == 1001){
                [CSNotificationView showInViewController:[[[UIApplication sharedApplication] keyWindow] rootViewController] style:CSNotificationViewStyleSuccess message:NSLocalizedString(@"Posted (but still need to implement response handler)!\nCheck back for responses soon!", @"serverConnectionFailedButDataSaved")];
            }
            
        }];

        
    }

}

-(void) updateSubscriberIDWithPushNotificationID:(NSString*)pushNotificationID{
    if ([self.pushNotificationID isEqualToString:pushNotificationID] == NO | self.subscriberId == nil){
        self.pushNotificationID = pushNotificationID;
        
        if (self.subscriberId == nil){
            [self registerForSubscriberID];
        }else{
            if (self.subscriberId == nil || self.deviceId == nil || self.pushNotificationID == nil){
                EXLog(@"pushNotificationID, deviceId, or subscriberId == nil! (re-regging for subscriber id): %@,%@,%@" , self.subscriberId,self.deviceId,self.pushNotificationID);
                
                [self registerForSubscriberID];
            }
            
            NSString* requestPath = @"/api/v1/push/devicetoken";
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[[RKObjectManager sharedManager] baseURL]];
            NSMutableURLRequest * registerSubscriberURLRequest =  [httpClient requestWithMethod:@"POST" path:requestPath parameters:@{@"subscriberId": self.subscriberId, @"deviceId": self.deviceId, @"deviceToken": self.pushNotificationID }];
            
            [[NSOperationQueue mainQueue] addOperation:[AFJSONRequestOperation JSONRequestOperationWithRequest:registerSubscriberURLRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* JSON) {
                EXLog(@"JSON update subscriberID response: %@", [JSON description]);
                self.deviceId = [[JSON valueForKey:@"response"] valueForKey:@"deviceId"];
                
                //[[[UIAlertView alloc] initWithTitle:nil message:@"Updated your push notification endpoint! \nEmail the developer at domo@domo.io, this means something to them :-)" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil] show];

                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                EXLog(@"JSON fail subscriberID response: %@ with error: %@", [JSON description], error);

                [[[UIAlertView alloc] initWithTitle:nil message:@"failed updating push endpoint! Sorry :/\nEmail the developer at domo@domo.io, this means something to them :-)" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil] show];
                
            }]];
        }
    }
    
    //0 Only if pushNotifcationID != oldPNID or subscriberId is nil
        //if subscriberId == nil
            //->registerForSubscriberID
        //else do this function, goto 1
    // else return
        
    //1 Get out old subscriberId and deviceId
    
}

-(void) registerForSubscriberID{
    if (self.subscriberId != nil){
        EXLog(@"Exiting, subscriber Id != nil! %@", self.subscriberId);
        return;
    }
    if (self.pushNotificationID == nil){
        EXLog(@"pushNotificationID == nil! %@", @"ARG");
        return;
    }
    
    Organization * org = [Organization activeOrganization];
    
    //1 get current active org
    //2 make request to /api/v1/push/register?token=mit%7Cmit9
    //3 retrieve and store subscriberId and deviceId
    //4 submit subscriberId with advice request whenever needed
    //5 listen to changes in deviceToken
    
    NSString* requestPath = [NSString stringWithFormat:@"/api/v1/push/register?token=%@%%7c%@",org.urlFragment,org.usersAuthCode];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[[RKObjectManager sharedManager] baseURL]];
    NSMutableURLRequest * registerSubscriberURLRequest =  [httpClient requestWithMethod:@"POST" path:requestPath parameters:@{@"deviceType": @"ios", @"deviceMeta": @{ @"model": [[UIDevice currentDevice] hardwareDescription] }, @"deviceToken": self.pushNotificationID }];
    
    [[NSOperationQueue mainQueue] addOperation:[AFJSONRequestOperation JSONRequestOperationWithRequest:registerSubscriberURLRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* JSON) {
        EXLog(@"JSON register response: %@", [JSON description]);
        self.subscriberId = [[JSON valueForKey:@"response"] valueForKey:@"subscriberId"];
        self.deviceId = [[JSON valueForKey:@"response"] valueForKey:@"deviceId"];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        EXLog(@"JSON fail register response: %@ with error: %@", [JSON description], error);
    }]];
    
}





@end
