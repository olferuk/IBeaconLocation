//
//  BeaconLocation.m
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import "BeaconLocation.h"
#import "Utils.h"
#import "Processor.h"

@interface BeaconLocation ()

@property (nonatomic, strong) CLBeaconRegion *region;
@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation BeaconLocation 

#pragma mark - Initializers

- (instancetype)initWithUUID:(NSUUID *)uuid identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _floor = [[Floor alloc] init];
        _processor = [[Processor alloc] init];
        _processor.floor = _floor;
        
        _region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:identifier];
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
        if ([_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_manager requestAlwaysAuthorization];
        }
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        [_manager startRangingBeaconsInRegion:_region];
        
    }
    return self;
}

- (instancetype)initWithUUIDString:(NSString *)uuidString identifier:(NSString *)identifier {
    return [self initWithUUID:[[NSUUID alloc] initWithUUIDString:uuidString] identifier:identifier];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
    // TODO: shit.
//    for (CLBeacon *beacon in beacons) {
//        NSLog(@"Accuracy: %.2f\tCalc: %.2f\tRSSI: %li", beacon.accuracy, [Utils realDistanceFromBeaconRssi:beacon.rssi defaultRssi:60], (long)beacon.rssi);
//    }
}

@end
