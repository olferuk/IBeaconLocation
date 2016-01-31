//
//  CustomTrilaterationImplementor.h
//  IBeaconLocation
//
//  Created by Ольферук Александр on 31/01/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconLocation.h"

@interface CustomTrilaterationImplementor : NSObject<TrilaterationAlgorithm>

- (CGPoint)locationWithBeacons:(NSArray<Beacon *> *)beacons;

@end
