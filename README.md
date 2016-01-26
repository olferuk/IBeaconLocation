# IBeaconLocation

This is a project contains both library files and example to demostrate its usage.
> P.s. Библиотечка будет оформлена как фреймворк позже, а Example project пустой пока :(

## Library overview

Library contains following classes:

```
  / .
    |  BeaconLocation
    |  Floor
    |  Beacon
    |  Utils
    |  Processor
    / Algorithms
      |  AlgorithmPowerCenter
      |  AlgorithmEPTA
      |  AlgorithmSphereIntersection
```

### BeaconLocation

`BeaconLocation` is an entry point for the library and you should start working with the initialization of this class:

```objc
- (instancetype)initWithUUID:(NSUUID *)uuid identifier:(NSString *)identifier;
- (instancetype)initWithUUIDString:(NSString *)uuidString identifier:(NSString *)identifier;
```

After the initialization, the library creates nessesary CoreLocation files (`CLBeaconRegion`, `CLLocationManager`) and handles `CLLocationManager`'s delegate. Moreover, it creates `Floor` object, which stores beacon identifiers and coordinates; and creates `Processor` object, which takes responsibility for the calculation of user position with beacons stored in `Floor` and their accuracies. 

`BeaconLocation` has a delegate of type `BeaconLocationDelegate`, which should contain the following selector:

```objc
@protocol BeaconLocationDelegate <NSObject>
- (void)onUpdateUserPosition:(CGPoint)position;
@end
```

### Floor

`Floor` class contains following methods for adding, getting and removing beacons:

```objc
- (void)addBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor xCoord:(double)x yCoord:(double)y;
- (void)addBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor xCoord:(double)x yCoord:(double)y zCoord:(double)z;

- (void)addBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor inPosition:(CGPoint)point;

- (BOOL)hasBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor;
- (Beacon *)beaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor;

- (void)removeAllBeacons;
- (void)removeBeaconWithMajor:(NSUInteger)major minor:(NSUInteger)minor;
```

We assume that you provide coordinates in meters, as the CoreLocation framework itself uses default RSSI and measured RSSI to calculate `accuracy` in meters.

### Beacon

`Beacon` is a storage for beacon's location and its identifiers. 

```objc
@property (nonatomic, assign) NSUInteger major;
@property (nonatomic, assign) NSUInteger minor;

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) double z;

- (instancetype)initWithMajor:(NSUInteger)major minor:(NSUInteger)minor x:(double)x y:(double)y z:(double)z;
```

### Processor

`Processor` is the core of the library. By default, it subscribes to `-locationManager:didRangeBeacons:inRegion` event, and calcutates user position with every call.

As declared in `BeaconLocation.h`, the framework offers you 3 different algorithms to choose from, and also you can specify your own method with `customAlgorithm` property stored in `Processor`. 

Every algorithm or even the combination of algorithms can be chosen to achieve the best results. Consider the following interface:

```objc
- (void)setAlgorithm:(AlgorithmType)algorithmType;
- (void)setAlgorithmsAndTrusts:(NSDictionary<NSNumber *, NSNumber *> *)algorithms;
```

The first method enables only one algorithm type: `AlgorithmTypeEPTA`, `AlgorithmTypePowerCenter`, `AlgorithmTypeSphereIntersection`, and `AlgorithmTypeCustom` (which are declared in `AlgorithmType` enum in `BeaconLocation.h`). 
> **Pay attention**: you must provide a `customAlgorithm` instance _before_ calling any of `-setAlgorithm:...` methods!

The second one is more tricky. `NSDictionary` that takes the method as the input argument should contain pair with `AlgorithmType` (boxed in a `NSNumber *` object) and the value called _trust_ (also a `NSNumber *`). _Trusts_ assigned to different algorithms show the importance of the result calculated with each of the enabled algorithm.

Let us say we have algorithm (1) and (2). The first one calculates user position to be `(1;1)`, while the second one suggests `(5;5)`. Then if _trusts_ are equal, the result will be averaged, and we will have `(3;3)`. If the second algorithm is twice as important as the first, we will have `0.66 * (5;5) + 0.33 * (1;1) == (3.66; 3.66)`.

Now back to usage. You may choose any positive values you want, as the library performs normalization by 1. Consider the following example:

```objc
self.lib = [[BeaconLocation alloc] initWith...];
[self.lib.processor setAlgorithmsAndTrusts:@{ @(AlgorithmTypeEPTA): @(1),
                                              @(AlgorithmTypePowerCenter): @(3) // power center type is 3 times more important
                                              }];
```

> **Note**: if all trusts were assigned to zero, it will be treated as even values.

### Algorithms

The `Algorithm` group contains different implementations of the trilateration algorithms.

1. **EPTA** (Enhanced Positioning Trilateration Algorithm)
   Implementation of the algorithm based on the research of Peter Brida and Juraj Machaj "A Novel Enhanced Positioning Trilateration Algorithm Implemented for Medical Implant In-Body Localization" which can be found [on this web-page](http://www.hindawi.com/journals/ijap/2013/819695/).

2. **Power Center**
   Implementation of the algorithm based on the research of V. Pierlot, M. Urbin-Choffray, and M. Van Droogenbroeck "A new three object triangulation algorithm based on the power center of three circles", which can be found [here](http://www.telecom.ulg.ac.be/publi/publications/pierlot/Pierlot2011ANewThreeObject/index.html).

3. **Sphere Intersection**
   The algorithm is based on the Wikipedia article devoted to [Trilateration](https://en.wikipedia.org/wiki/Trilateration) problem. 

## Example

So, let us write a simple example demonstrating the possible usage of the framework:

```objc
#import <BeaconLocation/BeaconLocation.h>
@import CoreGraphics;

// ...

@property (nonatomic, strong) BeaconLocation *library;

// ...

@interface MyClass: NSObject <BeaconLocationDelegate>

// ...

- (void)init {
  self = [super init];
  if (self) {
    //init
    _library = [[BeaconLocation alloc] initWithUUIDString:@"12345678-1234-0000-4321-876543210000" 
                                               identifier:@"My region"];
    
    //beacons
    [_library.floor addBeaconWithMajor:0 minor:0 inPosition:CGPointMake(1, 2)];
    [_library.floor addBeaconWithMajor:0 minor:1 inPosition:CGPointMake(2, 3)];
    [_library.floor addBeaconWithMajor:0 minor:2 inPosition:CGPointMake(1, 3)];
    
    //method
    [_library.processor setAlgorithm:AlgorithmTypeSphereIntersection];
    
    //delegate
    _library.delegate = self;
  }
  return self;
}

- (void)onUpdateUserPostion:(CGPoint)position {
  // do fancy stuff
}
```

So that's it.
