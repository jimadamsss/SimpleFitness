//
//  Journal.h
//  SimpleFitness
//
//  Created by James Adams on 5/7/11.
//  Copyright (c) 2011 SAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Equipment;

@interface Journal : NSManagedObject {
@private
}
@property (nonatomic, retain) NSSet* entries;

@end
