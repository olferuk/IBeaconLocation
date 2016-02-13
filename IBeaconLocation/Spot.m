//
//  Spot.m
//  IBeaconLocation
//
//  Created by Ольферук Александр on 13/02/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#import "Spot.h"
#import "Utils.h"

@interface Spot ()

@property (nonatomic, assign) BOOL wasNameInitialized;

@end

@implementation Spot

#pragma mark - Init

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y name:(NSString *)name nameInitialized:(BOOL)initialized {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _name = name;
        _wasNameInitialized = initialized;
    }
    return self;

}

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y {
    return [self initWithX:x y:y name:[Utils randomString] nameInitialized:NO];
}

- (instancetype)initWithPoint:(CGPoint)point {
    return [self initWithX:point.x y:point.y name:[Utils randomString] nameInitialized:NO];
}

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y name:(NSString *)name {
    return [self initWithX:x y:y name:name nameInitialized:YES];
}

- (instancetype)initWithPoint:(CGPoint)point name:(NSString *)name {
    return [self initWithX:point.x y:point.y name:name nameInitialized:YES];
}

#pragma mark - Setters

- (void)setName:(NSString *)name {
    self.wasNameInitialized = YES;
    _name = name;
}

#pragma mark - NSObject

- (NSString *)description {
    if (self.wasNameInitialized) {
        return [NSString stringWithFormat:@"Spot named %@\t at X: %.2f\tY: %.2f", self.name, self.x, self.y];
    }
    return [NSString stringWithFormat:@"Spot at X: %.2f\tY: %.2f", self.x, self.y];
}

@end
