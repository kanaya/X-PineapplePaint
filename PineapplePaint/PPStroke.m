//
//  PPStroke.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import "PPStroke.h"

@implementation PPStroke {
  NSMutableArray *_times;
  NSDate *_lastTime;
  NSPoint _lastPoint;
}

#pragma mark - Init Methods

- (id)initWithInitialPoint: (NSPoint)initialPoint {
  self = [super init];
  if (self) {
    _path = [NSBezierPath bezierPath];
    _lastPoint = initialPoint;
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
  [_times addObject: _lastTime];
}

- (void)draw {
  [[NSColor blackColor] set];
  [self.path stroke];
}

@end
