//
//  SphereIntersection.c
//  IBeaconLocation
//
//  Created by Ольферук Александр on 26/01/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#include "SphereIntersection.h"
#include "CalculationUtils.h"

extern double fabs(double);
extern double sqrt(double);
extern void * malloc(size_t sizeMem);

double * calculateUserPositionSphereIntersection(double *xs, double *ys, double *accs) {
    double *result = (double *)malloc(sizeof(double) * DIMENSIONS);

    double temp = (xs[1] - xs[0])*(xs[1] - xs[0]) + (ys[1] - ys[0])*(ys[1] - ys[0]);
    double exx = (xs[1] - xs[0]) / sqrt(temp);
    double exy = (ys[1] - ys[0]) / sqrt(temp);
    
    double p3p1x = xs[2] - xs[0];
    double p3p1y = ys[2] - xs[0];
    
    double ival = exx * p3p1x + exy*p3p1y;
    
    double p3p1i = (xs[2] - xs[0] - exx)*(xs[2] - xs[0] - exx) + (ys[2] - ys[0] - exy)*(ys[2] - ys[0] - exy);
    
    double eyx = (xs[2] - xs[0] - exx) / sqrt(p3p1i);
    double eyy = (ys[2] - ys[0] - exy) / sqrt(p3p1i);
    
    double d = sqrt(temp);
    
    double jval = (eyx * p3p1x) + (eyy * p3p1y);
    
    double xval = (accs[0]*accs[0] - accs[1]*accs[1] + d*d) / (2*d);
    double yval = (accs[0]*accs[0] - accs[2]*accs[2] + ival*ival + jval*jval)/(2*jval) - (ival/jval)*xval;
    
    result[0] = xs[0] + exx*xval + eyx*yval;
    result[1] = ys[0] + exy*xval + eyy*yval;
    
    return result;
}