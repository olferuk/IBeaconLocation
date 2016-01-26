//
//  BeaconLocation.h
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Floor.h"
#import "Beacon.h"

@import CoreLocation;

@class Processor;

typedef NS_ENUM(NSInteger, AlgorithmType) {
    AlgorithmTypeEPTA               = 0,
    AlgorithmTypePowerCenter        = 1,
    AlgorithmTypeSphereIntersection = 2,
    AlgorithmTypeCustom             = 3
};

static const int AlgorithmTypeCount = 3;
static const float Eps = 1e-5;

@protocol TrilaterationAlgorithm <NSObject>

- (CGPoint)locationWithBeacons:(NSArray<Beacon *> *)beacons;

@end

@interface BeaconLocation : NSObject <CLLocationManagerDelegate>

- (instancetype)initWithUUID:(NSUUID *)uuid identifier:(NSString *)identifier;
- (instancetype)initWithUUIDString:(NSString *)uuidString identifier:(NSString *)identifier;

@property (nonatomic, strong) Floor *floor;
@property (nonatomic, strong) Processor *processor;

@end
