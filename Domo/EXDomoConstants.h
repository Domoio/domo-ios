//
//  EXDomoConstants.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//


static NSString * const pushNotificationTokenUserConstant = @"pushNotificationTokenUserConstant";
static NSString * const subscriberTokenUserConstant = @"subscriberTokenUserConstant";
static NSString * const deviceIdUserConstant = @"deviceIdUserConstant";
static NSString * const lastUpdateDateUserDefault = @"lastUpdateDateUserDefault";
static NSString * const didDisplayIntroUserDefault = @"didDisplayIntroUserDefault";


static NSString * const shouldUpdateNewAdviceUINotification = @"shouldUpdateNewAdviceUINotification";



#define IS_SHIPPING 0
#define DEV_MUTE 0
#define DEV_STATE_RESET 0
#define DEV_MAKE_DB_SEED 0


#define DEBUG_MODE_ENABLED 1

#if DEBUG_MODE_ENABLED == 1
#if IS_SHIPPING == 0

#else
#error verbose outputs, eg EXOLog, enabled-- exoLib DEBUG_MODE_ENABLED == 1
#endif
#define EXLog NSLog
#else
#define EXOLog(format, ...)
#endif



#ifdef RELEASE
#ifdef DEBUG_MODE_ENABLED
#error "debug mode defined: DEBUG_MODE_ENABLED"
#endif
#ifdef DEV_STATE_RESET
#error "reset mode defined: DEV_STATE_RESET"
#endif
#ifdef DEV_MUTE
#error "mute mode defined: DEV_MUTE"
#endif
#endif


#define deviceIsIPhone5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define deviceIsPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define ArrayHasItems(array) (array != nil && [array count] > 0)
#define StringHasText(string) (string != nil && [string length] > 0)
#define SetHasItems(set) (set != nil && [set count] > 0)
#define orientationIsPortrait (UIDeviceOrientationIsLandscape( [UIApplication sharedApplication].statusBarOrientation) == FALSE)


#define MR_SHORTHAND
#import "MagicalRecord.h"
#import "CoreData+MagicalRecord.h"
#import "RestKit.h"
#import "CSNotificationView.h"


#import "UIViewAdditions+EX.h"
#import "NSDateAdditions+EX.h"
