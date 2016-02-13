//
//  Spot.h
//  IBeaconLocation
//
//  Created by Ольферук Александр on 13/02/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreGraphics;

@interface Spot : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y;
- (instancetype)initWithPoint:(CGPoint)point;
- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y name:(NSString *)name;
- (instancetype)initWithPoint:(CGPoint)point name:(NSString *)name;

@end
