//
//  AppDelegate.h
//  IBeaconLocation
//
//  Created by Alexander Olferuk on 23/01/16.
//  Copyright © 2016 Alexander Olferuk. All rights reserved.
//

#import <UIKit/UIKit.h>

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

