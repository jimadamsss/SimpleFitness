//
//  AddMachineViewController.h
//  SimpleFitness
//
//  Created by James Adams on 3/26/11.
//  Copyright 2011 SAS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddMachineViewController : UIViewController<UITextFieldDelegate> {

    IBOutlet UITextField *equipName;
    IBOutlet UISegmentedControl *allowSets;
    IBOutlet UISegmentedControl *allowReps;
    IBOutlet UISegmentedControl *equipmentType;
    IBOutlet UILabel *allowRepsLabel;
    IBOutlet UILabel *allowSetsLabel;
    IBOutlet UITextView *helpLabel;
}
@property (nonatomic, retain) UITextField *equipName;
@property (nonatomic, retain) UISegmentedControl *allowSets;
@property (nonatomic, retain) UISegmentedControl *allowReps;
@property (nonatomic, retain) UISegmentedControl *equipmentType;
@property (nonatomic, retain) UILabel *allowRepsLabel;
@property (nonatomic, retain) UILabel *allowSetsLabel;
@property (nonatomic, retain) UITextView *helpLabel;

-(IBAction)save:(id)sender;
-(IBAction)toggleType:(id)sender;


@end
