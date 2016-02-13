//
//  Utils.h
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"

@interface Utils : NSObject

+ (double *)valuesFromBeaconArray:(NSArray<Beacon *> *)beacons withKeyPath:(NSString *)keyPath;

+ (double)realDistanceFromBeaconRssi:(NSInteger)rssi defaultRssi:(NSInteger)defaultRssi;

+ (NSString *)randomString;

@end
