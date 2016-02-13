//
//  Epta.c
//  IBeaconLocation
//
//  Created by Ольферук Александр on 26/01/16.
//  Copyright © 2016 Ольферук Александр. All rights reserved.
//

#include "Epta.h"
#include "CalculationUtils.h"

extern double fabs(double);
extern double sqrt(double);
extern void * malloc(size_t sizeMem);

#define MAX_ITERATIONS  500
#define Points          struct point *
#define enoughPoints    7
#define step            0.1f

/**
 *  Struct represents a beacon or a point
 */
struct point {
    double x;
    double y;
    double r;
};

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

/**
 *  Checks whether the point belongs to all three circles
 *
 *  @param x      x
 *  @param y      y
 *  @param points Beacons
 *
 *  @return 1 if true, 0 otherwise
 */
int isPointBelongToAllCircles(double x, double y, Points points) { //, size_t size) {
    int belongs = 1;
    for (size_t i = 0; i < MIN_BEACONS; ++i) {
        double dist = getDistance(x, y, points[i].x, points[i].y);
        if (dist > (points[i].r + 1e-2)) {
            belongs = 0;
            break;
        }
    }
    return belongs;
}

/**
 *  Returns the centroid coordinate of given points
 *
 *  @param points Array of points
 *  @param size   Its size
 *
 *  @return Centroid coordinates
 */
Points getCenter(Points points, size_t size) {
    Points center = (Points )malloc(sizeof(struct point));
    center->x = 0;
    center->y = 0;
    
    for (size_t i = 0; i < size; ++i) {
        center->x += points[i].x;
        center->y += points[i].y;
    }
    center->x /= size;
    center->y /= size;
    
    return center;
}

/**
 *  Calculates all circle-circle intersections and return an array of resulting point
 *
 *  @param pointA Circle A
 *  @param pointB Circle B
 *  @param cnt    Reference to the resulting array's size
 *
 *  @return Array of points
 */
Points getCircleCircleIntersection(Points pointA, Points pointB, int *cnt) {
    *cnt = 0;
    double r1 = pointA->r;
    double r2 = pointB->r;
    double p1x = pointA->x;
    double p1y = pointA->y;
    double p2x = pointB->x;
    double p2y = pointB->y;
    double d = getDistance(p1x, p1y, p2x, p2y);
    
    // if too far away, or self contained - can't be done
    if ((d >= (r1 + r2)) || (d <= fabs(r1 - r2))) {
        return 0;
    }
    
    double a = (r1*r1 - r2*r2 + d*d)/(2*d);
    double h = sqrt(r1*r1 - a*a);
    double x0 = p1x + a*(p2x - p1x)/d;
    double y0 = p1y + a*(p2y - p1y)/d;
    double rx = -(p2y - p1y)*(h/d);
    double ry = -(p2x - p1x)*(h/d);
    
    *cnt = 2;
    Points result = (Points )malloc(*cnt * sizeof(struct point));
    result[0].x = x0 + rx;
    result[0].y = y0 - ry;
    result[1].x = x0 - rx;
    result[1].y = y0 + ry;
    return result;
}

/**
 *  Returns an array of circle intersections
 *
 *  @param points Beacons
 *  @param size   Size of the array
 *  @param cnt    Reference to the size of the resuting array
 *
 *  @return Array of points
 */
Points getIntersectionPoints(Points points, size_t size, int *cnt) {
    size_t e = 20;
    Points result = (Points )malloc(e * sizeof(struct point));
    
    size_t indexToAdd = 0;
    for (size_t i = 0; i < size; ++i) {
        for (size_t j = 1; j < size; ++j) {
            int cnt = 0;
            Points intersects = getCircleCircleIntersection(&points[i], &points[j], &cnt);
            if (cnt > 0) {
                for (size_t k = 0; k < cnt; ++k) {
                    result[indexToAdd++] = intersects[k]; // todo: what if we adding a duplicate?
                }
            }
        }
    }
    
    return result;
}

/**
 *  Selects only common points from the circles intersection
 *
 *  @param points Intersection points
 *  @param size   Size of that array *  @param beacons The given beacons and their accuracies
 *  @param cnt    Reference to the resulting array's count
 *
 *  @return Array of points
 */
Points getCommonPoints(Points points, size_t size, Points beacons, int *cnt) {
    Points result = (Points)malloc(sizeof(struct point) * enoughPoints);
    
    int k = 0;
    for (size_t i = 0; i < size; ++i) {
        if (!isPointBelongToAllCircles(points[i].x, points[i].y, beacons)) {
            continue;
        }
        
        result[k].x = points[i].x;
        result[k].y = points[i].y;
        result[k].r = points[i].r;
        ++k;
    }
    *cnt = k;
    
    return result;
}

/**
 *  Mutates three arrays of coordinates into one array of points
 *
 *  @param xs   xs
 *  @param ys   ys
 *  @param accs accs
 *
 *  @return Array of points
 */
Points createPoints(double *xs, double *ys, double *accs) {
    Points points = (Points )malloc(MIN_BEACONS * sizeof(struct point));
    for (size_t i = 0; i < MIN_BEACONS; ++i) {
        points[i].x = xs[i];
        points[i].y = ys[i];
        points[i].r = accs[i];
    }
    return points;
}

/**
 *  Enlarges the beacons' accuracies proportionally
 *
 *  @param beacons Array of beacons
 */
void enlargeAccuracies(Points beacons) {
    for (size_t i = 0; i < MIN_BEACONS; ++i) {
        beacons[i].r *= (1 + step);
    }
}

//************************************************************************

double * calculateUserPositionEpta(double *xs, double *ys, double *accs) {
    double *result = (double *)malloc(sizeof(double) * DIMENSIONS);

    Points beacons = createPoints(xs, ys, accs);

    int iterations = 0;
    while (1) {
        if (++iterations > MAX_ITERATIONS) {
            return result;
        }
        
        int intersectionCount = 0;
        Points intersections = getIntersectionPoints(beacons, MIN_BEACONS, &intersectionCount);
        
        if (intersectionCount == 0) {
            return result;
        }
        
        int commonCount = 0;
        Points common = getCommonPoints(intersections, intersectionCount, beacons, &commonCount);
        
        if (commonCount == 2 || commonCount == 3) {
            Points center = getCenter(common, commonCount);
            result[0] = center[0].x;
            result[1] = center[0].y;
            return result;
        }
        
        enlargeAccuracies(beacons);
    }
    
    return result;
}

