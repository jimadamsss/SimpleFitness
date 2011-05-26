//
//  JournalViewController.h
//  SimpleFitness
//
//  Created by James Adams on 3/6/11.
//  Copyright 2011 SAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FitnessDetailViewController.h"
#import "WeightsDetailViewController.h"
#import "BodyWeightDetailViewController.h"

@interface JournalViewController : UIViewController<NSFetchedResultsControllerDelegate, UITableViewDelegate> {
  
    IBOutlet UITableView *table;
    IBOutlet UIViewController *addMachineController;
    IBOutlet WeightsDetailViewController *weightsDetailController;
    IBOutlet BodyWeightDetailViewController *bodyWeightDetailController;
    IBOutlet FitnessDetailViewController *cardioDetailController;
@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
	NSFetchRequest *fetchRequest;

}

@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) UIViewController *addMachineController;
@property (nonatomic, retain) WeightsDetailViewController *weightsDetailController;
@property (nonatomic, retain) BodyWeightDetailViewController *bodyWeightDetailController;
@property (nonatomic, retain) FitnessDetailViewController *cardioDetailController;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;

-(IBAction)add:(id)sender;
-(IBAction)info:(id)sender;

@end
