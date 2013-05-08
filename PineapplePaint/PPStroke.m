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

@implementation PPStroke

#pragma mark - Init Methods

- (id)initWithInitialPoint: (CGPoint)initialPoint pressure: (CGFloat)initialPressure date: (NSTimeInterval)initialDate {
  self = [super init];
  if (self) {
    _pointsAndPressures = [NSMutableArray arrayWithCapacity: 1024];
    PPPointAndPressure *pointAndPressure = [[PPPointAndPressure alloc] initWithPoint: initialPoint
                                                                            pressure: initialPressure
                                                                                date: initialDate];
    [_pointsAndPressures addObject: pointAndPressure];
  }
  return self;
}

#pragma mark - Public Methods

- (void)addPoint: (CGPoint)point pressure: (CGFloat)pressure date: (NSTimeInterval)date {
  PPPointAndPressure *pointAndPressure = [[PPPointAndPressure alloc] initWithPoint: point
                                                                          pressure: pressure
                                                                              date: date];
  [self.pointsAndPressures addObject: pointAndPressure];
}

@end
