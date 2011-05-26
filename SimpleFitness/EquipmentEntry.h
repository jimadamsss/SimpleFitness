//
//  EquipmentEntry.h
//  SimpleFitness
//
//  Created by James Adams on 5/7/11.
//  Copyright (c) 2011 SAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Equipment;

@interface EquipmentEntry : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * incline;
@property (nonatomic, retain) NSNumber * index_;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * sets;
@property (nonatomic, retain) NSNumber * speed;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * weightInKg;
@property (nonatomic, retain) NSNumber * graphValue;
@property (nonatomic, retain) Equipment * equipment;

@end
