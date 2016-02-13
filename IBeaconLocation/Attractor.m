//
//  Attractor.m
//  IBeaconLocation
//
//  Created by Ольферук Александр on 13/02/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#import "Attractor.h"
#import "CalculationUtils.h"

@interface Attractor ()

@property (nonatomic, weak) Spot *lastSpot;

@end

@implementation Attractor

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _spots = [NSMutableArray array];
        _lastSpot = nil;
        
        _attractionPower = 0.1f;
        _deadZone = 0.2f;
    }
    return self;
}

#pragma mark - Spots

- (void)addSpot:(Spot *)spot {
    [self.spots addObject:spot];
    self.lastSpot = spot;
}

- (void)removeAllSpots {
    [self.spots removeAllObjects];
    self.lastSpot = nil;
}

- (void)removeLastSpot {
    if (!self.lastSpot) {
        return;
    }
    [self.spots removeObject:self.lastSpot];
    self.lastSpot = nil;
}

- (void)removeSpotNamed:(NSString *)name {
    NSAssert(name != nil, @"Parameter can not be nil");
    Spot *toBeDeleted;
    for (Spot *s in self.spots) {
        if (![s.name isEqualToString:name]) {
            continue;
        }
        toBeDeleted = s;
        break;
    }
    if (!toBeDeleted) {
        return;
    }
    [self.spots removeObject:toBeDeleted];
}

- (void)removeAllSpotsNamed:(NSString *)name {
    NSMutableArray *toBeDeleted = [NSMutableArray array];
    for (Spot *s in self.spots) {
        if ([s.name isEqualToString:name]) {
            [toBeDeleted addObject:s];
        }
    }
    [self.spots removeObjectsInArray:toBeDeleted];
}

#pragma mark - User Position update

- (CGPoint)updateUserPosition:(CGPoint)userPosition {
    double totalShiftX = 0.0f;
    double totalShiftY = 0.0f;
    
    for (Spot *s in self.spots) {
        double distance = getDistance(userPosition.x, userPosition.y, s.x, s.y);
        if (distance < self.deadZone)
            continue;
        
        double shift = (1/(distance * distance * 100)) * 100 * self.attractionPower;
        double dx = (userPosition.x - s.x) / distance * shift;
        double dy = (userPosition.y - s.y) / distance * shift;
    
        double length = getDistance(0, 0, dx, dy);
        if (length > distance)
        {
            dx /= length / distance;
            dy /= length / distance;
        }
        
        totalShiftX += dx;
        totalShiftY += dy;
    }
    return CGPointMake(userPosition.x - totalShiftX, userPosition.y - totalShiftY);
}


@end
