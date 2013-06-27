//
//  EXDomoConstants.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//


#define DEV_MUTE 1
#define DEV_STATE_RESET 1

#ifdef RELEASE
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



#define MR_SHORTHAND
#import "UIViewAdditions+EX.h"
#import "NSDateAdditions+EX.h"
