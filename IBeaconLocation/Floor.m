//
//  Floor.m
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import "Floor.h"
#import "Beacon.h"

@interface Floor ()

@property (nonatomic, strong) NSMutableArray<Beacon *> *localBeacons;

@end

@implementation Floor

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self) {
        _localBeacons = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Adding beacons

- (void)addBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor xCoord:(double)x yCoord:(double)y {
    [self addBeaconWithMajor:major minor:minor xCoord:x yCoord:y zCoord:0];
}

- (void)addBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor inPosition:(CGPoint)point {
    [self addBeaconWithMajor:major minor:minor xCoord:point.x yCoord:point.y zCoord:0];
}

// designited
- (void)addBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor xCoord:(double)x yCoord:(double)y zCoord:(double)z {
    NSAssert(![self hasBeaconWithMajor:major minor:minor], @"You can not create a beacon with the same major and minor values");
    
    [self.localBeacons addObject:[[Beacon alloc] initWithMajor:major minor:minor x:x y:y z:z]];
}

- (BOOL)hasBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor {
    for (Beacon *b in self.beacons) {
        if (b.major == major && b.minor == minor) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Getting beacons

-(NSArray *)beacons {
    return self.localBeacons;
}

@end
