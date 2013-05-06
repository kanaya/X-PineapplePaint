//
//  PPStroke.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <math.h>
#import "PPStroke.h"

static CGFloat distance(CGPoint a, CGPoint b) {
  CGFloat dx = a.x - b.x;
  CGFloat dy = a.y - b.y;
  return (CGFloat)sqrt(dx * dx + dy * dy);
}

@implementation PPStroke {
  NSMutableArray *_times;
  NSDate *_lastTime;
  CGPoint _lastPoint;
}

#pragma mark - Init Methods

- (id)initWithInitialPoint: (CGPoint)initialPoint pressure: (CGFloat)initialPressure {
  self = [super init];
  if (self) {
    _pointsAndPressures = [NSMutableArray arrayWithCapacity: 1024];
    PPPointAndPressure *pointAndPressure = [[PPPointAndPressure alloc] initWithPoint: initialPoint
                                                                            pressure: initialPressure];
    [_pointsAndPressures addObject: pointAndPressure];
        
    _times = [NSMutableArray arrayWithCapacity: 1000];
    _lastTime = [NSDate date];
    [_times addObject: _lastTime];
  }
  return self;
}

#pragma mark - Public Methods

- (void)addPoint: (CGPoint)point pressure: (CGFloat)pressure {
  _lastPoint = point;
  _lastTime = [NSDate date];
  PPPointAndPressure *pointAndPressure = [[PPPointAndPressure alloc] initWithPoint: point
                                                                          pressure: pressure];
  [self.pointsAndPressures addObject: pointAndPressure];
  [_times addObject: _lastTime];
}

- (void)writeStrokeToFile: (FILE *)fout {
  NSUInteger n_points = [self.pointsAndPressures count];
  for (NSUInteger i = 0; i < n_points; ++i) {
    PPPointAndPressure *pp = [self.pointsAndPressures objectAtIndex: i];
    CGPoint p = pp.point;
    CGFloat r = pp.pressure;
    NSDate *d = [_times objectAtIndex: i];
    NSTimeInterval t = [d timeIntervalSinceReferenceDate];
    NSString *stringToWrite = [NSString stringWithFormat: @"%f %f %f %f\n", t, p.x, p.y, r];
    const char *stringToWriteInCStyle = [stringToWrite UTF8String];
    fputs(stringToWriteInCStyle, fout);
  }
  fputs("\n", fout);
}

@end
