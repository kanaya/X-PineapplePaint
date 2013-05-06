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
  NSPoint _lastPoint;
}

#pragma mark - Init Methods

- (id)initWithInitialPoint: (NSPoint)initialPoint pressure: (CGFloat)initialPressure {
  self = [super init];
  if (self) {
    _points = [NSMutableArray arrayWithCapacity: 1000];
    _lastPoint = initialPoint;
    [_points addObject: [NSValue valueWithPoint: _lastPoint]];
    
    _path = [NSBezierPath bezierPath];
    [_path moveToPoint: _lastPoint];

    _pressures = [NSMutableArray arrayWithCapacity: 1000];
    [_pressures addObject: [NSNumber numberWithFloat: (float)initialPressure]];
    
    _times = [NSMutableArray arrayWithCapacity: 1000];
    _lastTime = [NSDate date];
    [_times addObject: _lastTime];
  }
  return self;
}

#pragma mark - Public Methods

- (void)addPoint: (NSPoint)point pressure: (CGFloat)pressure {
  _lastPoint = point;
  _lastTime = [NSDate date];
  [self.path lineToPoint: _lastPoint];
  [self.points addObject: [NSValue valueWithPoint: _lastPoint]];
  [self.pressures addObject: [NSNumber numberWithFloat: (float)pressure]];
  [_times addObject: _lastTime];
}

- (void)draw {
  [[NSColor blackColor] set];
  [self.path stroke];
}

- (void)drawVelocity {
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

- (void)writeStrokeToFile: (FILE *)fout {
  NSUInteger n_points = [_points count];
  for (NSUInteger i = 0; i < n_points; ++i) {
    NSPoint p = [[_points objectAtIndex: i] pointValue];
    float r = [[_pressures objectAtIndex: i] floatValue];
    NSDate *d = [_times objectAtIndex: i];
    NSTimeInterval t = [d timeIntervalSinceReferenceDate];
    NSString *stringToWrite = [NSString stringWithFormat: @"%f %f %f %f\n", t, p.x, p.y, r];
    const char *stringToWriteInCStyle = [stringToWrite UTF8String];
    fputs(stringToWriteInCStyle, fout);
  }
  fputs("\n", fout);
}

@end
