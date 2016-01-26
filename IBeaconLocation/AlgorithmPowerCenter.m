//
//  AlgorithmPowerCenter.m
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import "AlgorithmPowerCenter.h"
#import "PowerCenter.h"
#import "Utils.h"

@implementation AlgorithmPowerCenter

- (CGPoint)locationWithBeacons:(NSArray<Beacon *> *)beacons {
    double *result = calculateUserPositionPowerCenter([Utils valuesFromBeaconArray:beacons withKeyPath:@"x"],
                                                      [Utils valuesFromBeaconArray:beacons withKeyPath:@"y"],
                                                      [Utils valuesFromBeaconArray:beacons withKeyPath:@"accuracy"]);
    return CGPointMake(result[0], result[1]);}

@end
