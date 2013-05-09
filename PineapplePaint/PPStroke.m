//
//  PPStroke.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <math.h>
#import "PPStroke.h"
#import "PPPointAndPressure.h"

@implementation PPStroke {
  BOOL _cached;
}

#pragma mark - Init Methods

- (id)init {
  self = [super init];
  if (self) {
    _pointsAndPressures = [NSMutableArray arrayWithCapacity: 1024];
    _cached = NO;
  }
  return self;
}

#pragma mark - Public Methods

- (id)addPointAndPressure: (PPPointAndPressure *)pointAndPressure {
  [self.pointsAndPressures addObject: pointAndPressure];
  return self;
}

- (BOOL)cached {
  return _cached;
}

- (void)drawLayer: (CALayer *)layer inContext: (CGContextRef)context {
  NSEnumerator *enumerator = self.pointsAndPressures.objectEnumerator;
  PPPointAndPressure *pointAndPressure = enumerator.nextObject;
  while (pointAndPressure) {
    PPPointAndPressure *nextPointAndPressure = [enumerator nextObject];
    if (nextPointAndPressure) {
      CGPoint p1 = pointAndPressure.point;
      CGFloat r1 = pointAndPressure.pressure;
      CGPoint p2 = nextPointAndPressure.point;
      CGFloat r2 = nextPointAndPressure.pressure;
      CGContextBeginPath(context);
      CGContextMoveToPoint(context, p1.x, p1.y);
      CGContextAddLineToPoint(context, p2.x, p2.y);
      CGContextSetRGBStrokeColor(context, 0, 0, 0, (r1 + r2) / 2.0);
      CGContextStrokePath(context);
    }
    pointAndPressure = nextPointAndPressure;
  }
}

@end
