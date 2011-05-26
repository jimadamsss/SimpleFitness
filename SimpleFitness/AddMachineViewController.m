//
//  AddMachineViewController.m
//  SimpleFitness
//
//  Created by James Adams on 3/26/11.
//  Copyright 2011 SAS. All rights reserved.
//

#import "AddMachineViewController.h"
#import <CoreData/CoreData.h>
#import "SimpleFitnessAppDelegate.h"
#import "Equipment.h"
#import "Journal.h"


@implementation AddMachineViewController
@synthesize equipName;
@synthesize allowReps;
@synthesize allowSets;
@synthesize allowSetsLabel;
@synthesize allowRepsLabel;
@synthesize equipmentType;
@synthesize helpLabel;
@synthesize accessoryToolbar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    equipName.delegate = self;
    helpLabel.text = @"This type of equipment is for weight lifting activities using things like BarBells or Free Weights.";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.equipName.text = @"";
    self.allowReps.selectedSegmentIndex = 0;
    self.allowSets.selectedSegmentIndex = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)save:(id)sender
{
    NSManagedObjectContext *managedObjectContext = [(SimpleFitnessAppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];

    if (equipmentType.selectedSegmentIndex == 0)
    {
        // weights
        Equipment* weight = (Equipment*)[NSEntityDescription insertNewObjectForEntityForName:@"Equipment" inManagedObjectContext:managedObjectContext];
        weight.name = self.equipName.text;
        weight.Type = @"Weights";
        BOOL allowingSets = self.allowSets.selectedSegmentIndex == 0;
        BOOL allowingReps = self.allowReps.selectedSegmentIndex == 0;
        weight.allowReps = [NSNumber numberWithBool:allowingReps];
        weight.allowSets = [NSNumber numberWithBool:allowingSets];
    }
    else
    {
        // cardio
        Equipment* fitness = (Equipment*)[NSEntityDescription insertNewObjectForEntityForName:@"Equipment" inManagedObjectContext:managedObjectContext];
        fitness.name = self.equipName.text;
        fitness.Type =@"Cardio";
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)toggleType:(id)sender
{
    UISegmentedControl *typeControl = (UISegmentedControl*)sender;
    if (typeControl.selectedSegmentIndex == 0)
    {
        // weights
        allowSetsLabel.hidden = NO;
        allowSets.hidden = NO;
        allowRepsLabel.hidden = NO;
        allowReps.hidden = NO;
        helpLabel.text = @"This type of equipment is for weight lifting activities using things like BarBells or Free Weights.";
    }
    else
    {
        // Road equipment
        allowSetsLabel.hidden = YES;
        allowSets.hidden = YES;
        allowRepsLabel.hidden = YES;
        allowReps.hidden = YES;
        helpLabel.text = @"This type of equipment is for cardio activites using machines like a Treadmill or an Elliptical.";
    }
}

#pragma mark textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

//-(void)keyboardDidShow:(NSNotification*)n
//{
//    NSDictionary* info = [n userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your application might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height+scrollView.frame.origin.y;
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y); //-kbSize.height);
//        [scrollView setContentOffset:scrollPoint animated:YES];
//    }
//}

//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//}

-(IBAction)doneEditing:(id)sender
{
    [activeField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [activeField resignFirstResponder];
    activeField = textField;
    textField.inputAccessoryView = accessoryToolbar;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}


@end
