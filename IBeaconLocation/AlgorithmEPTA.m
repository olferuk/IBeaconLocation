//
//  AlgorithmEPTA.m
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import "AlgorithmEPTA.h"
#import "Utils.h"
#import "Epta.h"

@implementation AlgorithmEPTA

-(CGPoint)locationWithBeacons:(NSArray<Beacon *> *)beacons {
    double *result = calculateUserPositionEpta([Utils valuesFromBeaconArray:beacons withKeyPath:@"x"],
                                               [Utils valuesFromBeaconArray:beacons withKeyPath:@"y"],
                                               [Utils valuesFromBeaconArray:beacons withKeyPath:@"accuracy"]);
    return CGPointMake(result[0], result[1]);
}

@end
