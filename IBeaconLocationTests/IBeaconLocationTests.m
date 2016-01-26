//
//  IBeaconLocationTests.m
//  IBeaconLocationTests
//
//  Created by Alexander Olferuk on 25/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BeaconLocation.h"

@interface IBeaconLocationTests : XCTestCase

@property (nonatomic, strong) BeaconLocation *lib;

@end

@implementation IBeaconLocationTests

- (void)setUp {
    [super setUp];
    
    self.lib = [[BeaconLocation alloc] initWithUUIDString:@"6665542b-41a1-5e00-931c-6a82db9b78c1" identifier:@"Surf"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test00_Init {
    XCTAssertNotNil(self.lib);
}

- (void)test01_AddBeacons {
    [self.lib.floor addBeaconWithMajor:0 minor:0 inPosition:CGPointMake(0, 0)];
    XCTAssertEqual(self.lib.floor.beacons.count, 1);
}

@end
