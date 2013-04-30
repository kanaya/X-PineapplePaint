//
//  PPStroke.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <math.h>
#import "PPStroke.h"

static CGFloat distance(NSPoint a, NSPoint b) {
  CGFloat dx = a.x - b.x;
  CGFloat dy = a.y - b.y;
  return (CGFloat)sqrt(dx * dx + dy * dy);
}

@implementation PPStroke {
  NSMutableArray *_times;
  NSDate *_lastTime;
  NSMutableArray *_points;
  NSPoint _lastPoint;
}

#pragma mark - Init Methods

- (id)initWithInitialPoint: (NSPoint)initialPoint {
  self = [super init];
  if (self) {
    _points = [NSMutableArray arrayWithCapacity: 1000];
    _lastPoint = initialPoint;
    [_points addObject: [NSValue valueWithPoint: _lastPoint]];
    
    _path = [NSBezierPath bezierPath];
    [_path moveToPoint: _lastPoint];
    
    _times = [NSMutableArray arrayWithCapacity: 1000];
    _lastTime = [NSDate date];
    [_times addObject: _lastTime];
  }
  return self;
}

#pragma mark - Public Methods

- (void)addPoint: (NSPoint)point {
  _lastPoint = point;
  _lastTime = [NSDate date];
  [self.path lineToPoint: _lastPoint];
  [_points addObject: [NSValue valueWithPoint: _lastPoint]];
  [_times addObject: _lastTime];
}

- (void)draw {
  [[NSColor blackColor] set];
  [self.path stroke];
}

- (void)drawPath {
  // for (id point in _points) {
  NSEnumerator *pointEnumerator = [_points objectEnumerator];
  NSValue *point;
  NSPoint p0 = [[_points objectAtIndex: 0] pointValue];
  while (point = [pointEnumerator nextObject]) {
    NSPoint p = [point pointValue];
    CGFloat s = distance(p, p0);
    NSRect r = NSMakeRect(p.x - s / 2, p.y - s / 2, s, s);
    [NSBezierPath strokeRect: r];
    p0 = p;
  }
}

@end
