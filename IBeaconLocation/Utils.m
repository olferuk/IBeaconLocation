//
//  Utils.m
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import "Utils.h"

@implementation Utils

static const int size = 3;

+ (double)realDistanceFromBeaconRssi:(NSInteger)rssi defaultRssi:(NSInteger)defaultRssi {
    if (rssi == 0) {
        return -1;
    }
    
    double ratio = fabs((double)rssi / (double)defaultRssi);
    if (ratio < 1) {
        return pow(ratio, 10);
    }
    
    return 0.89976 * pow(ratio, 7.7095) + 0.111;
}

+ (double *)valuesFromBeaconArray:(NSArray<Beacon *> *)beacons withKeyPath:(NSString *)keyPath {
    double *result = (double *)malloc(sizeof(double) * size);
    for (size_t i = 0; i < size; ++i) {
        Beacon *b = (Beacon *)beacons[i];
        result[i] = [[b valueForKeyPath:keyPath] doubleValue];
    }
    return result;
}


@end
