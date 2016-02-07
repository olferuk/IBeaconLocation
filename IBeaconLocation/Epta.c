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

struct point {
    double x;
    double y;
    double r;
};

double getDistance(double x1, double y1, double x2, double y2) {
    return sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
}

int isPointBelongToAllCircles(double x, double y, struct point *points, size_t size) {
    int belongs = 1;
    for (size_t i = 0; i < size; ++i) {
        double dist = getDistance(x, y, points[i].x, points[i].y);
        if (dist > (points[i].r + 1e-2)) {
            belongs = 0;
            break;
        }
    }
    return belongs;
}

struct point *getCenter(struct point *points, size_t size) {
    struct point *center = (struct point *)malloc(sizeof(struct point));
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

struct point *getCircleCircleIntersection(struct point *pointA, struct point *pointB, int *cnt) {
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
    struct point *result = (struct point *)malloc(*cnt * sizeof(struct point *));
    result[0].x = x0 + rx;
    result[0].y = y0 - ry;
    result[1].x = x0 - rx;
    result[1].y = y0 + ry;
    return result;
}

struct point *getIntersectionPoints(struct point *points, size_t size, int *cnt) {
    size_t e = 20;
    struct point *result = (struct point *)malloc(e * sizeof(struct point *));
    
    size_t indexToAdd = 0;
    for (size_t i = 0; i < size; ++i) {
        for (size_t j = 1; j < size; ++j) {
            int cnt = 0;
            struct point *intersects = getCircleCircleIntersection(&points[i], &points[j], &cnt);
            if (cnt > 0) {
                for (size_t k = 0; k < cnt; ++k) {
                    result[indexToAdd++] = intersects[k]; // todo: what if we adding a duplicate?
                }
            }
        }
    }
    
    return result;
}

int isOneTooBig(struct point *points, size_t size) {
    // shit.
//    int result = 1;
//    for (size_t i = 0; i < size; ++i) {
//        int isAllIn = 1;
//        for (size_t j = 1; j < size; ++j) {
//            if (&points[i] == &points[j]) {
//                continue;
//            }
//            
//            if (getDistance(points[i].x, points[i].y, points[j].x, points[j].y) >= points[i].r) {
//                isAllIn = 0;
//                break;
//            }
//        }
//        result *= isAllIn;
////        if (result) {
////            return 1;
////        }
//    }
//    return result;
    return 0;
}


double * calculateUserPositionEpta(double *xs, double *ys, double *accs) {
    double *result = (double *)malloc(sizeof(double) * DIMENSIONS);

    int isCenterInitialized = 0;
//    int iterations = 0;
    while (1) {
        struct point *points = getIntersectionPoints(xs, ys, accs);
        
    }
    
    return result;
}

