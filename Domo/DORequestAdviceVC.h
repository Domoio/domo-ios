//
//  DORequestAdviceVC.h
//  Domo
//
//  Created by Alexander List on 6/25/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"

@interface DORequestAdviceVC : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) IBOutlet UIView * questionRequestContainerView;

@property (nonatomic, strong) IBOutlet NoteView * adviceRequestNoteView;
@end
