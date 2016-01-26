//
//  Floor.h
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"

@import CoreGraphics;

@interface Floor : NSObject

@property (nonatomic, strong, readonly) NSArray<Beacon *> *beacons;

- (void)addBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor xCoord:(double)x yCoord:(double)y;
- (void)addBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor xCoord:(double)x yCoord:(double)y zCoord:(double)z;

- (void)addBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor inPosition:(CGPoint)point;

- (BOOL)hasBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor;
- (Beacon *)beaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor;

- (void)removeAllBeacons;
- (void)removeBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor;

@end
