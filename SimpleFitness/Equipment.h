//
//  Equipment.h
//  SimpleFitness
//
//  Created by James Adams on 5/7/11.
//  Copyright (c) 2011 SAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EquipmentEntry.h"

@class  Journal;

@interface Equipment : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * allowSets;
@property (nonatomic, retain) NSString * Type;
@property (nonatomic, retain) NSNumber * allowReps;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Journal * journal;
@property (nonatomic, retain) NSSet* entries;


-(NSArray*)sortedEntries;
-(NSDecimalNumber*)overallHigh;
-(NSDecimalNumber*)overallLow;
-(EquipmentEntry*)getEntryAtIndex:(int)index;

@end
