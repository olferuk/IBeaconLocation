//
//  Utils.h
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (double)realDistanceFromBeaconRssi:(NSInteger)rssi defaultRssi:(NSInteger)defaultRssi;

@end
