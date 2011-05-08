//
//  Equipment.m
//  SimpleFitness
//
//  Created by James Adams on 5/7/11.
//  Copyright (c) 2011 SAS. All rights reserved.
//

#import "Equipment.h"
#import "Journal.h"


@implementation Equipment
@dynamic allowSets;
@dynamic allowReps;
@dynamic Type;
@dynamic name;
@dynamic journal;
@dynamic entries;


- (void)addEntriesObject:(EquipmentEntry *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"entries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"entries"] addObject:value];
    [self didChangeValueForKey:@"entries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEntriesObject:(EquipmentEntry *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"entries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"entries"] removeObject:value];
    [self didChangeValueForKey:@"entries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEntries:(NSSet *)value {    
    [self willChangeValueForKey:@"entries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"entries"] unionSet:value];
    [self didChangeValueForKey:@"entries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEntries:(NSSet *)value {
    [self willChangeValueForKey:@"entries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"entries"] minusSet:value];
    [self didChangeValueForKey:@"entries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


-(NSArray*)sortedEntries
{    
    NSSet *set = self.entries;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[set allObjects]];
    if ([array count] <= 1)
        return array;
    
    int n = [array count] -1;
    BOOL swapped = YES;
    int i;
    while(swapped)
    {
        swapped = NO;
        for(i=0;i<n;++i)
        {
            EquipmentEntry* obj1 = [array objectAtIndex:i];
            EquipmentEntry* obj2 = [array objectAtIndex:i+1];
            if ([obj1.index_ intValue] > [obj2.index_ intValue])
            {
                [array removeObjectAtIndex:i];
                [array removeObjectAtIndex:i];
                [array insertObject:obj1 atIndex:i];
                [array insertObject:obj2 atIndex:i];
                swapped = YES;
            }
        }
    }
    return array;
}

-(NSDecimalNumber*)overallHigh
{
    NSDecimalNumber *overallHigh = [NSDecimalNumber notANumber];
    
    
    for (EquipmentEntry*ent in self.entries) {
        NSDecimalNumber *weight = [NSDecimalNumber decimalNumberWithDecimal:[ent.graphValue decimalValue]];
        if ( [overallHigh isEqual:[NSDecimalNumber notANumber]] ) {
            overallHigh = weight;
        }
        
        if ( [weight compare:overallHigh] == NSOrderedDescending ) {
            overallHigh = weight;
        }
    }
    return overallHigh;
}

-(NSDecimalNumber*)overallLow
{
    NSDecimalNumber *overallLow = [NSDecimalNumber notANumber];
    
    
    for (EquipmentEntry*ent in self.entries) {
        NSDecimalNumber *weight = [NSDecimalNumber decimalNumberWithDecimal:[ent.graphValue decimalValue]];
		if ( [overallLow isEqual:[NSDecimalNumber notANumber]] ) {
            overallLow = weight;
        }
		
        if ( [weight compare:overallLow] == NSOrderedAscending )  {
            overallLow = weight;
        }
    }
    return overallLow;
}

-(EquipmentEntry*)getEntryAtIndex:(int)index
{
    NSNumber *indexNum = [NSNumber numberWithInt:index];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EquipmentEntry" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSExpression *lhs1 = [NSExpression expressionForKeyPath:@"equipment"];
    NSExpression *lhs2 = [NSExpression expressionForKeyPath:@"index_"];
    NSExpression *rhs1 = [NSExpression expressionForConstantValue:self];
    NSExpression *rhs2 = [NSExpression expressionForConstantValue:indexNum];
    
    NSPredicate *eq = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:[NSComparisonPredicate predicateWithLeftExpression:lhs1 rightExpression:rhs1 modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0],[NSComparisonPredicate predicateWithLeftExpression:lhs2 rightExpression:rhs2 modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0], nil]];
    [request setPredicate:eq];
    NSError* err;
    NSArray *finalResults = [self.managedObjectContext executeFetchRequest:request error:&err];
    return [finalResults lastObject];

}


@end
