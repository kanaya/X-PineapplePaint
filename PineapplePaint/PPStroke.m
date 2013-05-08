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

- (id)init {
  self = [super init];
  if (self) {
    _pointsAndPressures = [NSMutableArray arrayWithCapacity: 1024];
  }
  return self;
}

#pragma mark - Public Methods

- (id)addPointAndPressure: (PPPointAndPressure *)pointAndPressure {
  [self.pointsAndPressures addObject: pointAndPressure];
  return self;
}

@end
