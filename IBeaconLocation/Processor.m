//
//  Processor.m
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import "Processor.h"

#import "AlgorithmPowerCenter.h"
#import "AlgorithmEPTA.h"
#import "AlgorithmSphereIntersection.h"

@import UIKit;

@interface Processor ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *algorithmTrusts;
@property (nonatomic, strong) NSMutableArray< id<TrilaterationAlgorithm> > *algorithmImplements;

@end


@implementation Processor

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        _customAlgorithm = nil;
        _algorithmTrusts = [NSMutableDictionary dictionaryWithDictionary:@{ @(AlgorithmTypePowerCenter): @(1) }];
        _algorithmImplements = [NSMutableArray array];
        [self createAlgorithmsIfNeeded];
    }
    return self;
}

#pragma mark - Getters

- (NSMutableDictionary<NSNumber *, NSNumber *> *)algorithmTrusts {
    return _algorithmTrusts;
}

- (NSMutableArray< id<TrilaterationAlgorithm> > *)algorithmImplements {
    return _algorithmImplements;
}

#pragma mark - Algorithm choosing

- (void)setAlgorithm:(AlgorithmType)algorithmType {
    [self.algorithmTrusts removeAllObjects];
    self.algorithmTrusts[@(algorithmType)] = @(1);
    [self createAlgorithmsIfNeeded];
}

- (void)setAlgorithms:(NSArray<NSNumber *> *)algorithmTypes {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSNumber *n in algorithmTypes) {
        dict[n] = @(1);
    }
    [self setAlgorithmsAndTrusts:dict];
}

- (void)setAlgorithmsAndTrusts:(NSDictionary<NSNumber *, NSNumber *> * _Nonnull)algorithms {
    // 1. Garbage in - garbage out
    NSAssert(algorithms.count > 0,
             @"You must provide at least one algorithm");
    
    NSAssert([[[algorithms allValues] valueForKeyPath:@"@min.self"] doubleValue] >= 0,
             @"Trusts can not be nagative values");
    
    NSAssert(([[[algorithms allKeys] valueForKeyPath:@"@min.self"] intValue] >= 0) &&
             ([[[algorithms allKeys] valueForKeyPath:@"@max.self"] intValue] <= AlgorithmTypeCount),
             @"Algorithm type must exists in AlgorithmType enum");
    
    // 2. Add algorithms
    [self.algorithmTrusts removeAllObjects];
    self.algorithmTrusts = [NSMutableDictionary dictionaryWithDictionary:algorithms];
    [self createAlgorithmsIfNeeded];

    // 3. Set trusts and do normalization
    if ([self isAllValuesAreZero:[algorithms allValues]]) {
        double eachTrust = 1.0 / [algorithms count];
        for (NSNumber *key in [algorithms allKeys]) {
            self.algorithmTrusts[key] = @(eachTrust);
        }
    }
    else {
        NSNumber *sum = [[self.algorithmTrusts allValues] valueForKeyPath:@"@sum.self"];
        for (NSNumber *key in [algorithms allKeys]) {
            self.algorithmTrusts[key] = @([self.algorithmTrusts[key] doubleValue] / [sum doubleValue]);
        }
    }
}

- (void)createAlgorithmsIfNeeded {
    [self.algorithmImplements removeAllObjects];
    for (NSNumber *algType in [self.algorithmTrusts allKeys]) {
        switch ([algType intValue]) {
            case AlgorithmTypePowerCenter:
                [self.algorithmImplements addObject:[[AlgorithmPowerCenter alloc] init]];
                break;
            case AlgorithmTypeEPTA:
                [self.algorithmImplements addObject:[[AlgorithmEPTA alloc] init]];
                break;
            case AlgorithmTypeSphereIntersection:
                [self.algorithmImplements addObject:[[AlgorithmSphereIntersection alloc] init]];
                break;
            case AlgorithmTypeCustom:
                NSAssert(self.customAlgorithm != nil, @"Custom algorithm must be initialized before enabling");
                [self.algorithmImplements addObject:self.customAlgorithm];
                break;
        }
    }
}

#pragma mark - Calculating user position

- (CGPoint)calculateUserPosition {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSArray<NSNumber *> *trusts = [self.algorithmTrusts allValues];
    for (id<TrilaterationAlgorithm> algorithm in self.algorithmImplements) {
        NSArray<Beacon *> *beacons = self.floor.beacons;
        [results addObject:[NSValue valueWithCGPoint:[algorithm locationWithBeacons:beacons]]];
    }
    
    CGPoint result = CGPointMake(0, 0);
    for (size_t i = 0; i < results.count; ++i) {
        result = CGPointMake(result.x + [results[i] CGPointValue].x * [trusts[i] doubleValue],
                             result.y + [results[i] CGPointValue].y * [trusts[i] doubleValue]);
    }
    return result;
}

#pragma mark - Extra methods

- (BOOL)isAllValuesAreZero:(NSArray<NSNumber *> *)array {
    for (NSNumber *n in array) {
        if (fabs([n doubleValue]) > Eps) {
            return NO;
        }
    }
    return YES;
}

@end
