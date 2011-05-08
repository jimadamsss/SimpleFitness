//
//  Journal.m
//  SimpleFitness
//
//  Created by James Adams on 5/7/11.
//  Copyright (c) 2011 SAS. All rights reserved.
//

#import "Journal.h"
#import "Equipment.h"


@implementation Journal
@dynamic entries;

- (void)addEntriesObject:(Equipment *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"entries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"entries"] addObject:value];
    [self didChangeValueForKey:@"entries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEntriesObject:(Equipment *)value {
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


@end
