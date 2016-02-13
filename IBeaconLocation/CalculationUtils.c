//
//  CalculationUtils.c
//  IBeaconLocation
//
//  Created by Ольферук Александр on 07/02/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#include "CalculationUtils.h"

extern double sqrt(double);

/**
 *  Eucledian distance between two points
 *
 *  @param x1 x1
 *  @param y1 y1
 *  @param x2 x2
 *  @param y2 y2
 *
 *  @return Distance
 */
double getDistance(double x1, double y1, double x2, double y2) {
    return sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
}
