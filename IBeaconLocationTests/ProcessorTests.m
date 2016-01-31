//
//  ProcessorTests.m
//  IBeaconLocation
//
//  Created by Ольферук Александр on 31/01/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BeaconLocation.h"
#import "Processor.h"
#import "CustomTrilaterationImplementor.h"

@interface ProcessorTests : XCTestCase

@property (nonatomic, strong) BeaconLocation *lib;

@end

@implementation ProcessorTests

- (void)setUp {
    [super setUp];
    self.lib = [[BeaconLocation alloc] initWithUUIDString:@"6665542b-41a1-5e00-931c-6a82db9b78c1" identifier:@"Surf"];
}

- (void)test00_Init {
    XCTAssertNotNil(self.lib.processor);
    XCTAssertNotNil(self.lib.processor.floor);
}

- (void)test01_ChooseOne {
    [self.lib.processor setAlgorithm:AlgorithmTypeEPTA];
    XCTAssertEqual(1, self.lib.processor.algorithmTrusts.count);
    XCTAssertEqual(1, self.lib.processor.algorithmImplements.count);
    
    NSNumber *trust = self.lib.processor.algorithmTrusts[@(AlgorithmTypeEPTA)];
    id<TrilaterationAlgorithm> logic = [self.lib.processor.algorithmImplements firstObject];
    XCTAssertEqualWithAccuracy([trust doubleValue], 1, Eps);
    XCTAssertNotNil(logic);
}

- (void)test02_ChooseCustom {
    self.lib.processor.customAlgorithm = [[CustomTrilaterationImplementor alloc] init];
    [self.lib.processor setAlgorithm:AlgorithmTypeCustom];
    XCTAssertEqual(1, self.lib.processor.algorithmTrusts.count);
    XCTAssertEqual(1, self.lib.processor.algorithmImplements.count);
    
    NSNumber *trust = self.lib.processor.algorithmTrusts[@(AlgorithmTypeCustom)];
    id<TrilaterationAlgorithm> logic = [self.lib.processor.algorithmImplements firstObject];
    XCTAssertEqualWithAccuracy([trust doubleValue], 1, Eps);
    XCTAssertNotNil(logic);
}

- (void)test03_SetAlgTrusts_Garbage {
    XCTAssertThrows([self.lib.processor setAlgorithmsAndTrusts:@{}]);
    XCTAssertThrows([self.lib.processor setAlgorithmsAndTrusts:@{@(AlgorithmTypePowerCenter): @(-1)}]);
    XCTAssertThrows([self.lib.processor setAlgorithmsAndTrusts:@{@(100): @(1)}]);
}

- (void)test04_SetAlgTrusts {
    [self.lib.processor setAlgorithmsAndTrusts:@{
                                                 @(AlgorithmTypeEPTA): @(2),
                                                 @(AlgorithmTypePowerCenter): @(6)
                                                 }];
    double firstTrust  = [self.lib.processor.algorithmTrusts[@(AlgorithmTypeEPTA)] doubleValue];
    double secondTrust = [self.lib.processor.algorithmTrusts[@(AlgorithmTypePowerCenter)] doubleValue];
    XCTAssertEqualWithAccuracy(firstTrust, 2.0/8.0, Eps);
    XCTAssertEqualWithAccuracy(secondTrust, 6.0/8.0, Eps);
}

- (void)test05_EqualTrusts {
    [self.lib.processor setAlgorithmsAndTrusts:@{
                                                 @(AlgorithmTypePowerCenter): @(0),
                                                 @(AlgorithmTypeEPTA): @(0),
                                                 @(AlgorithmTypeSphereIntersection): @(0)
                                                 }];
    double firstTrust  = [self.lib.processor.algorithmTrusts[@(AlgorithmTypeEPTA)] doubleValue];
    double secondTrust = [self.lib.processor.algorithmTrusts[@(AlgorithmTypePowerCenter)] doubleValue];
    double thirdTrust  = [self.lib.processor.algorithmTrusts[@(AlgorithmTypeSphereIntersection)] doubleValue];
    XCTAssertEqualWithAccuracy(firstTrust, secondTrust, Eps);
    XCTAssertEqualWithAccuracy(secondTrust, thirdTrust, Eps);
    XCTAssertEqualWithAccuracy(thirdTrust, 1.0/3.0, Eps);
}

- (void)test06_Calculating {
    [self addTestBeacons];
    [self.lib.processor setAlgorithm:AlgorithmTypeSphereIntersection];
    CGPoint point = [self.lib.processor calculateUserPosition];
    XCTAssertEqualWithAccuracy(point.x, 0, Eps);
    XCTAssertEqualWithAccuracy(point.y, 1, Eps);
}

- (void)test07_CalculatingWithTwoMethods {
    [self addTestBeacons];
    self.lib.processor.customAlgorithm = [[CustomTrilaterationImplementor alloc] init];
    [self.lib.processor setAlgorithmsAndTrusts:@{
                                                 @(AlgorithmTypePowerCenter): @(1),
                                                 @(AlgorithmTypeCustom): @(1)
                                                 }];
    CGPoint point = [self.lib.processor calculateUserPosition];
    XCTAssertEqualWithAccuracy(point.x, 2.5, Eps);
    XCTAssertEqualWithAccuracy(point.y, 3.0, Eps);
}

- (void)test08_UnequalTrusts {
    [self addTestBeacons];
    self.lib.processor.customAlgorithm = [[CustomTrilaterationImplementor alloc] init];
    [self.lib.processor setAlgorithmsAndTrusts:@{
                                                 @(AlgorithmTypeEPTA): @(3),
                                                 @(AlgorithmTypeCustom): @(1)
                                                 }];
    CGPoint point = [self.lib.processor calculateUserPosition];
    XCTAssertEqualWithAccuracy(point.x, 1.25, Eps);
    XCTAssertEqualWithAccuracy(point.y, 2, Eps);
}

- (void)test09_SetAlgs {
    [self.lib.processor setAlgorithms:@[@(AlgorithmTypeEPTA), @(AlgorithmTypePowerCenter)]];
    double first = [self.lib.processor.algorithmTrusts[@(AlgorithmTypeEPTA)] doubleValue];
    double second = [self.lib.processor.algorithmTrusts[@(AlgorithmTypePowerCenter)] doubleValue];
    XCTAssertEqualWithAccuracy(first, second, Eps);
}

#pragma mark - Extra 

- (void)addTestBeacons {
    [self.lib.floor addBeaconWithMajor:0 minor:0 inPosition:CGPointZero];
    [self.lib.floor addBeaconWithMajor:0 minor:1 inPosition:CGPointMake(0, 4)];
    [self.lib.floor addBeaconWithMajor:0 minor:2 inPosition:CGPointMake(4, 0)];
}

@end
