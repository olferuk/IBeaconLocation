//
//  IBeaconLocationTests.m
//  IBeaconLocationTests
//
//  Created by Alexander Olferuk on 25/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BeaconLocation.h"
#import "AlgorithmEPTA.h"
#import "Beacon.h"
#import "Utils.h"

@interface FloorTests : XCTestCase

@property (nonatomic, strong) BeaconLocation *lib;

@end

@implementation FloorTests

- (void)setUp {
    [super setUp];
    self.lib = [[BeaconLocation alloc] initWithUUIDString:@"6665542b-41a1-5e00-931c-6a82db9b78c1" identifier:@"Surf"];
}

- (void)test00_Init {
    XCTAssertNotNil(self.lib);
}

- (void)test01_AddBeacon {
    [self.lib.floor addBeaconWithMajor:0 minor:0 inPosition:CGPointMake(0, 0)];
    XCTAssertEqual(self.lib.floor.beacons.count, 1);
}

- (void)test02_BeaconUpdates {
    [self.lib.floor addBeaconWithMajor:0 minor:0 inPosition:CGPointZero];
    Beacon *b = [[self.lib.floor beacons] firstObject];
    [b updateAccuracy:5];
    XCTAssertEqualWithAccuracy(b.accuracy, 5, Eps);
}

- (void)test03_BeaconRemove {
    [self.lib.floor addBeaconWithMajor:0 minor:0 xCoord:1 yCoord:1];
    [self.lib.floor addBeaconWithMajor:0 minor:1 xCoord:1 yCoord:1 zCoord:4];
    XCTAssertEqual(2, self.lib.floor.beacons.count);
    
    [self.lib.floor removeAllBeacons];
    XCTAssertEqual(0, self.lib.floor.beacons.count);
}

- (void)test04_ExistingBeacon {
    [self.lib.floor addBeaconWithMajor:0 minor:0 inPosition:CGPointZero];
    XCTAssertTrue([self.lib.floor hasBeaconWithMajor:0 minor:0]);
    XCTAssertFalse([self.lib.floor hasBeaconWithMajor:0 minor:1]);
}

- (void)test05_RemoveConcreteBeacon {
    [self.lib.floor addBeaconWithMajor:0 minor:5 inPosition:CGPointZero];
    [self.lib.floor removeBeaconWithMajor:0 minor:4];
    XCTAssertEqual(1, self.lib.floor.beacons.count);
    
    [self.lib.floor removeBeaconWithMajor:0 minor:5];
    XCTAssertEqual(0, self.lib.floor.beacons.count);
}

@end
