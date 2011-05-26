//
//  FitnessDetailViewContoller.m
//  SimpleFitness
//
//  Created by James Adams on 3/6/11.
//  Copyright 2011 SAS. All rights reserved.
//

#import "FitnessDetailViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation FitnessDetailViewController
@synthesize durationField;
@synthesize speedField;
@synthesize inclineField;
@synthesize commentsField;
@synthesize previousButton;
@synthesize nextButton;
@synthesize saveButton;
@synthesize scrollView;

@synthesize accessoryToolbar;
@synthesize toolbar;

@synthesize journalEntry;
@synthesize newDurationValue;
@synthesize newSpeedValue;
@synthesize newInclineValue;
@synthesize newCommentsValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
//        self.navigation
    }
    return self;
}

- (void)dealloc
{
    [durationField release];
    [speedField release];
    [inclineField release];
    [commentsField release];
    [journalEntry release];
    [newDurationValue release];
    [newSpeedValue release];
    [newInclineValue release];
    [previousButton release];
    [nextButton release];
    [saveButton release];
    [scrollView release];
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
    durationField.delegate = self;
    speedField.delegate = self;
    inclineField.delegate = self;
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
    durationField.text = @"";
    speedField.text = @"";
    inclineField.text = @"";
    [durationField resignFirstResponder];
    [speedField resignFirstResponder];
    [inclineField resignFirstResponder];
    [commentsField resignFirstResponder];
    
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
    NSInteger value;
    if ([[NSScanner scannerWithString:durationField.text] scanInt:&value] == YES)
        newEntry.duration = [NSNumber numberWithInteger:value];
    
    if ([[NSScanner scannerWithString:speedField.text] scanInt:&value] == YES)
        newEntry.speed = [NSNumber numberWithInteger:value];
    
    if ([[NSScanner scannerWithString:inclineField.text] scanInt:&value] == YES)
        newEntry.incline = [NSNumber numberWithInteger:value];
    
    newEntry.date = [NSDate date];
    newEntry.comments = commentsField.text;
    
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
        self.newDurationValue = durationField.text;
        self.newSpeedValue = speedField.text;
        self.newInclineValue = inclineField.text;
        self.newCommentsValue = commentsField.text;
    }
    --currentIndex;
    if (currentIndex == 0) {
        previousButton.enabled = NO;
    }
    if (currentIndex < [journalEntry.entries count])
        nextButton.enabled = YES;
    
    // set the indexed values
    EquipmentEntry *entry = [journalEntry getEntryAtIndex:currentIndex];
    durationField.text = [entry.duration stringValue];
    speedField.text = [entry.speed stringValue];
    inclineField.text = [entry.incline stringValue];
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
        durationField.text = newDurationValue;
        speedField.text = newSpeedValue;
        inclineField.text = newInclineValue;
        commentsField.text = newCommentsValue;
        dateItem = [[UIBarButtonItem alloc] initWithTitle:[dateFormatter stringFromDate:[NSDate date]] style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    else
    {
        // set the indexed values
        saveButton.enabled = NO;
        EquipmentEntry *entry = [journalEntry getEntryAtIndex:currentIndex];
        durationField.text = [entry.duration stringValue];
        speedField.text = [entry.speed stringValue];
        inclineField.text = [entry.incline stringValue];
        commentsField.text = entry.comments;
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

@end
