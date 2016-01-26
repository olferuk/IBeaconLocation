//
//  AlgorithmSphereIntersection.m
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 25/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import "AlgorithmSphereIntersection.h"
#import "SphereIntersection.h"
#import "Utils.h"

@implementation AlgorithmSphereIntersection

-(CGPoint)locationWithBeacons:(NSArray<Beacon *> *)beacons {
    double *result = calculateUserPositionSphereIntersection([Utils valuesFromBeaconArray:beacons withKeyPath:@"x"],
                                                             [Utils valuesFromBeaconArray:beacons withKeyPath:@"y"],
                                                             [Utils valuesFromBeaconArray:beacons withKeyPath:@"accuracy"]);
    return CGPointMake(result[0], result[1]);}

@end
