//
//  Beacon.h
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beacon : NSObject

@property (nonatomic, assign) NSUInteger major;
@property (nonatomic, assign) NSUInteger minor;

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) double z;

- (instancetype)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor x:(double)x y:(double)y z:(double)z;

@end
