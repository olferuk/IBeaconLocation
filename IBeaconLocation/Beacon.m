//
//  Beacon.m
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import "Beacon.h"

@implementation Beacon


- (instancetype)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor x:(double)x y:(double)y z:(double)z {
    self = [super init];
    if (self) {
        _major = major;
        _minor = minor;
        
        _x = x;
        _y = y;
        _z = z;
    }
    return self;
}

@end
