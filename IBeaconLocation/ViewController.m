//
//  ViewController.m
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import "ViewController.h"
#import "BeaconLocation.h"

#define START CFTimeInterval ___time___ = CACurrentMediaTime();
#define FINISH NSLog(@"Total runtime: %g s", CACurrentMediaTime() - ___time___);

@interface ViewController ()

@property (nonatomic, strong) BeaconLocation *lib;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];

    START
    int y = 5;
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:10000];
    for (size_t i = 0; i < 10000; ++i) {
        [a addObject:@(y)];
    }
    FINISH
    
    self.lib = [[BeaconLocation alloc] initWithUUIDString:@"6665542b-41a1-5e00-931c-6a82db9b78c1" identifier:@"Surf"];
    
    [self.lib.floor addBeaconWithMajor:0 minor:2 xCoord:0 yCoord:0 zCoord:0];
}

@end
