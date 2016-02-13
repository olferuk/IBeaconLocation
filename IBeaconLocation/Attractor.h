//
//  Attractor.h
//  IBeaconLocation
//
//  Created by Ольферук Александр on 13/02/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Spot.h"

@import CoreGraphics;

@interface Attractor : NSObject

@property (strong, nonatomic) NSMutableArray<Spot *> *spots;

- (void)addSpot:(Spot *)spot;
- (void)removeAllSpots;
- (void)removeLastSpot;
- (void)removeSpotNamed:(NSString *)name;
- (void)removeAllSpotsNamed:(NSString *)name;

- (CGPoint)updateUserPosition:(CGPoint)userPosition;

@property (nonatomic, assign) CGFloat attractionPower;
@property (nonatomic, assign) CGFloat deadZone;

@end
