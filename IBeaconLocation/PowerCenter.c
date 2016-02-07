//
//  PowerCenter.c
//  IBeaconLocation
//
//  Created by Ольферук Александр on 26/01/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#include "PowerCenter.h"
#include "CalculationUtils.h"

extern double fabs(double);
extern void * malloc(size_t sizeMem);

double * calculateUserPositionPowerCenter(double *xs, double *ys, double *accs) {
    
    double *result = (double *)malloc(sizeof(double) * DIMENSIONS);

    // k[n] = ( B[n].x^2 + B[n].y^2 - dist[n]^2 )/2
    double *ks = (double *)malloc(sizeof(double) * MIN_BEACONS);
    for (size_t i = 0; i < MIN_BEACONS; ++i) {
        ks[i] = (xs[i]*xs[i] + ys[i]*ys[i] - accs[i]*accs[i])/2.0;
    }
    
    // D = | x1-x2  y1-y2 | = (x1-x2)*(y2-y3) - (y1-y2)*(x2-x3)
    //     | x2-x3  y2-y3 |
    double d = (xs[0] - xs[1])*(ys[1] - ys[2]) - (ys[0] - ys[1])*(xs[1] - xs[2]);
    
    if (fabs(d) < 1e-7) {
        result[0] = -1;
        return result;
    }
    
    // X = | k1-k2  y1-y2 | = (k1-k2)*(y2-y3) - (y1-y2)*(k2-k3)
    //     | k2-k3  y2-y3 |
    double x = (ks[0] - ks[1])*(ys[1] - ys[2]) - (ys[0] - ys[1])*(ks[1] - ks[2]);
    
    // Y = | x1-x2  k1-k2 | = (x1-x2)*(k2-k3) - (k1-k2)*(x2-x3)
    //     | x2-x3  k2-k3 |
    double y = (xs[0] - xs[1])*(ks[1] - ks[2]) - (ks[0] - ks[1])*(xs[1] - xs[2]);
    
    result[0] = x/d;
    result[1] = y/d;
    
    return result;
    
}