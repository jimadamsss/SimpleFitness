//
//  FitnessDetailViewContoller.h
//  SimpleFitness
//
//  Created by James Adams on 3/6/11.
//  Copyright 2011 SAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Equipment.h"
#import "EquipmentEntry.h"

@interface FitnessDetailViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate> {
    IBOutlet UITextField *durationField;
    IBOutlet UITextField *speedField;
    IBOutlet UITextField *inclineField;
    IBOutlet UITextView *commentsField;
    IBOutlet UIBarButtonItem *previousButton;
    IBOutlet UIBarButtonItem *nextButton;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIToolbar *toolbar;

    IBOutlet UIToolbar *accessoryToolbar;
    
    Equipment *journalEntry;
    int currentIndex;
    NSString *newDurationValue;
    NSString *newSpeedValue;
    NSString *newinclineValue;
    NSString *newCommentsValue;
    
    UIView *activeField;
}

@property (nonatomic, retain) IBOutlet UITextField *durationField;
@property (nonatomic, retain) IBOutlet UITextField *speedField;
@property (nonatomic, retain) IBOutlet UITextField *inclineField;
@property (nonatomic, retain) IBOutlet UITextView *commentsField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *previousButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIToolbar *accessoryToolbar;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) Equipment *journalEntry;
@property (nonatomic, retain) NSString *newDurationValue;
@property (nonatomic, retain) NSString *newSpeedValue;
@property (nonatomic, retain) NSString *newInclineValue;
@property (nonatomic, retain) NSString *newCommentsValue;

-(IBAction)previous:(id)sender;
-(IBAction)next:(id)sender;
-(IBAction)save:(id)sender;

-(IBAction)doneEditing:(id)sender;

@end
