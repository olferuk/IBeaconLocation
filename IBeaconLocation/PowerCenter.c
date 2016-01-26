//
//  PowerCenter.c
//  IBeaconLocation
//
//  Created by Ольферук Александр on 26/01/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#include "PowerCenter.h"

double * calculateUserPositionPowerCenter(double *xs, double *ys, double *accs) {
    int size = 3;
    double *result = (double *)malloc(sizeof(double) * size);
    for (size_t i = 0; i < size; ++i) {
        result[i] = i;
    }
    return result;
}