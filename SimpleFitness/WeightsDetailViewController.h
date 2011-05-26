//
//  WeightsDetailViewController.h
//  SimpleFitness
//
//  Created by James Adams on 3/6/11.
//  Copyright 2011 SAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Equipment.h"
#import "EquipmentEntry.h"

@interface WeightsDetailViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate> {
    IBOutlet UITextField *weightField;
    IBOutlet UITextField *setsField;
    IBOutlet UITextField *repsField;
    IBOutlet UITextView *commentsField;
    IBOutlet UIBarButtonItem *previousButton;
    IBOutlet UIBarButtonItem *nextButton;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UILabel *setsLabel;
    IBOutlet UILabel *repsLabel;
    IBOutlet UISegmentedControl *weightType;
    
    IBOutlet UIToolbar *accessoryToolbar;

    Equipment *journalEntry;
    int currentIndex;
    NSString *newWeightsValue;
    NSString *newSetsValue;
    NSString *newRepsValue;
    NSString *newCommentsValue;
    BOOL newWeightTypeValue;
    
    UIView *activeField;
}

@property (nonatomic, retain) IBOutlet UITextField *weightField;
@property (nonatomic, retain) IBOutlet UITextField *setsField;
@property (nonatomic, retain) IBOutlet UITextField *repsField;
@property (nonatomic, retain) IBOutlet UITextView *commentsField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *previousButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIToolbar *accessoryToolbar;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UILabel *setsLabel;
@property (nonatomic, retain) IBOutlet UILabel *repsLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *weightType;

@property (nonatomic, retain) Equipment *journalEntry;
@property (nonatomic, retain) NSString *newWeightsValue;
@property (nonatomic, retain) NSString *newSetsValue;
@property (nonatomic, retain) NSString *newRepsValue;
@property (nonatomic, retain) NSString *newCommentsValue;

-(IBAction)previous:(id)sender;
-(IBAction)next:(id)sender;
-(IBAction)save:(id)sender;

-(IBAction)doneEditing:(id)sender;
-(IBAction)switchWeight:(id)sender;

@end
