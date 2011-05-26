//
//  WeightsDetailViewController.m
//  SimpleFitness
//
//  Created by James Adams on 3/6/11.
//  Copyright 2011 SAS. All rights reserved.
//


#import "WeightsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation WeightsDetailViewController
@synthesize weightField;
@synthesize setsField;
@synthesize repsField;
@synthesize commentsField;
@synthesize previousButton;
@synthesize nextButton;
@synthesize saveButton;
@synthesize scrollView;
@synthesize accessoryToolbar;
@synthesize toolbar;
@synthesize setsLabel;
@synthesize repsLabel;
@synthesize weightType;

@synthesize journalEntry;
@synthesize newRepsValue;
@synthesize newSetsValue;
@synthesize newWeightsValue;
@synthesize newCommentsValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [weightField release];
    [setsField release];
    [repsField release];
    [commentsField release];
    [journalEntry release];
    [newSetsValue release];
    [newRepsValue release];
    [newWeightsValue release];
    [previousButton release];
    [nextButton release];
    [saveButton release];
    [scrollView release];
    [weightType release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)setJournalEntry:(Equipment *)je
{
    [je retain];
    [journalEntry release];
    journalEntry = je;
    nextButton.enabled = NO;
    previousButton.enabled = NO;
    if ([je.entries count] > 1)
        previousButton.enabled = YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    weightField.delegate = self;
    repsField.delegate = self;
    setsField.delegate = self;
    commentsField.delegate = self;
    
    commentsField.layer.borderColor = [UIColor grayColor].CGColor;
    commentsField.layer.borderWidth = 1;
    commentsField.layer.cornerRadius = 4;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardDidShow:) 
                                                 name:UIKeyboardDidShowNotification 
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillBeHidden:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:self.view.window];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil];  
}
-(void)viewWillAppear:(BOOL)animated
{
    nextButton.enabled = NO;
    previousButton.enabled = NO;
    currentIndex = [journalEntry.entries count];
    if (currentIndex > 0)
        previousButton.enabled = YES;
    weightField.text = @"";
    repsField.text = @"";
    setsField.text = @"";
    [repsField resignFirstResponder];
    [setsField resignFirstResponder];
    [weightField resignFirstResponder];
    [commentsField resignFirstResponder];
    
    repsField.hidden = ![journalEntry.allowReps boolValue];
    repsLabel.hidden = ![journalEntry.allowReps boolValue];
    setsField.hidden = ![journalEntry.allowSets boolValue];
    setsLabel.hidden = ![journalEntry.allowSets boolValue];
    
    weightType.selectedSegmentIndex = 0;
    
    UIBarButtonItem *dateItem = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];

    dateItem = [[UIBarButtonItem alloc] initWithTitle:[dateFormatter stringFromDate:[NSDate date]] style:UIBarButtonItemStylePlain target:nil action:nil];

    NSMutableArray *items = [toolbar.items mutableCopy];
    [items replaceObjectAtIndex:2 withObject:dateItem];
    [toolbar setItems:items animated:YES];
    
    
    self.navigationItem.title = journalEntry.name;

    [dateFormatter release];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)save:(id)sender
{
    EquipmentEntry *newEntry = (EquipmentEntry*)[NSEntityDescription insertNewObjectForEntityForName:@"EquipmentEntry" inManagedObjectContext:journalEntry.managedObjectContext];
    newEntry.index_ = [NSNumber numberWithInt:[journalEntry.entries count]];
    newEntry.equipment = journalEntry;
    float fvalue;
    if ([[NSScanner scannerWithString:weightField.text] scanFloat:&fvalue] == YES)
    {   
        if (weightType.selectedSegmentIndex == 0)
        {
            // lbs - no change
            newEntry.weight = [NSNumber numberWithFloat:fvalue];
        }
        else
        {
            // kgs
            float n = fvalue * 0.45359237;
            newEntry.weight = [NSNumber numberWithFloat:n] ;
        }
        
    }
    
    NSInteger value;

    if ([[NSScanner scannerWithString:setsField.text] scanInt:&value] == YES)
        newEntry.sets = [NSNumber numberWithInteger:value];
    
    if ([[NSScanner scannerWithString:repsField.text] scanInt:&value] == YES)
        newEntry.reps = [NSNumber numberWithInteger:value];
    
    newEntry.date = [NSDate date];
    newEntry.comments = commentsField.text;
    newEntry.weightInKg = [NSNumber numberWithBool:(weightType.selectedSegmentIndex != 0)];
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(IBAction)previous:(id)sender
{
    UIBarButtonItem *dateItem = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    if (currentIndex == [journalEntry.entries count])
    {
        // grab the current values for later
        self.newRepsValue = repsField.text;
        self.newSetsValue = setsField.text;
        self.newWeightsValue = weightField.text;
        self.newCommentsValue = commentsField.text;
        newWeightTypeValue = (weightType.selectedSegmentIndex != 0);
    }
    --currentIndex;
    if (currentIndex == 0) {
        previousButton.enabled = NO;
    }
    if (currentIndex < [journalEntry.entries count])
        nextButton.enabled = YES;
    
    // set the indexed values
    EquipmentEntry *entry = [journalEntry getEntryAtIndex:currentIndex];
    repsField.text = [entry.reps stringValue];
    setsField.text = [entry.sets stringValue];
    weightType.selectedSegmentIndex = [entry.weightInKg boolValue];
    if (![entry.weightInKg boolValue])
    {
        // lbs
        weightField.text = [[NSNumber numberWithFloat:[entry.weight floatValue]] stringValue];
    }
    else
    {
        // kgs
        float n = [entry.weight floatValue] * 2.20462262;
        weightField.text = [[NSNumber numberWithFloat:n] stringValue];
    }

//    weightField.text = [entry.weight stringValue];
    commentsField.text = entry.comments;
    
    
    dateItem = [[UIBarButtonItem alloc] initWithTitle:[dateFormatter stringFromDate:entry.date] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSMutableArray *items = [toolbar.items mutableCopy];
    [items replaceObjectAtIndex:2 withObject:dateItem];
    [toolbar setItems:items animated:YES];
    
    [dateFormatter release];
    
    saveButton.enabled = NO;
    
}
-(IBAction)next:(id)sender
{
    UIBarButtonItem *dateItem = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];

    ++currentIndex;
    if (currentIndex > 0) {
        previousButton.enabled = YES;
    }
    if (currentIndex == [journalEntry.entries count])
    {
        nextButton.enabled = NO;
        saveButton.enabled = YES;
        repsField.text = newRepsValue;
        setsField.text = newSetsValue;
        weightField.text = newWeightsValue;
        commentsField.text = newCommentsValue;
        weightType.selectedSegmentIndex = newWeightTypeValue;
        dateItem = [[UIBarButtonItem alloc] initWithTitle:[dateFormatter stringFromDate:[NSDate date]] style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    else
    {
        // set the indexed values
        saveButton.enabled = NO;
        EquipmentEntry *entry = [journalEntry getEntryAtIndex:currentIndex];
        repsField.text = [entry.reps stringValue];
        setsField.text = [entry.sets stringValue];
        if (![entry.weightInKg boolValue])
        {
            // lbs
            weightField.text = [[NSNumber numberWithFloat:[entry.weight floatValue]] stringValue];
        }
        else
        {
            // kgs
            float n = [entry.weight floatValue] * 2.20462262;
            weightField.text = [[NSNumber numberWithFloat:n] stringValue];
        }
        
        //    weightField.text = [entry.weight stringValue];
        commentsField.text = entry.comments;
        weightType.selectedSegmentIndex = [entry.weightInKg boolValue];
        dateItem = [[UIBarButtonItem alloc] initWithTitle:[dateFormatter stringFromDate:entry.date] style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    NSMutableArray *items = [toolbar.items mutableCopy];
    [items replaceObjectAtIndex:2 withObject:dateItem];
    [toolbar setItems:items animated:YES];
    
    [dateFormatter release];

}

-(void)keyboardDidShow:(NSNotification*)n
{
    NSDictionary* info = [n userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height+scrollView.frame.origin.y;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y); //-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

-(IBAction)doneEditing:(id)sender
{
    [activeField resignFirstResponder];
}

#pragma mark textFieldDelegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textField
{
    [activeField resignFirstResponder];
    activeField = textField;
    textField.inputAccessoryView = accessoryToolbar;
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    activeField = nil;
}

-(IBAction)switchWeight:(id)sender
{
    // store weight in lbs
    UISegmentedControl *c = (UISegmentedControl*)sender;
    float currentValue = 0;
    BOOL validValue = NO;
    float value;
    if ([[NSScanner scannerWithString:weightField.text] scanFloat:&value] == YES)
    {    
        currentValue = value;
        validValue = YES;
    }
    if (validValue)
    {
        if (c.selectedSegmentIndex == 0)
        {
            // lbs
            float n = currentValue * 2.20462262;
            weightField.text = [[NSNumber numberWithFloat:n] stringValue];
        }
        else
        {
            // kgs
            float n = currentValue / 2.20462262;
            weightField.text = [[NSNumber numberWithFloat:n] stringValue];
        }
    }
}

@end
