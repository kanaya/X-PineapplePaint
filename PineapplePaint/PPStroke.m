//
//  PPStroke.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import "PPStroke.h"

@implementation PPStroke

#pragma mark - Init Methods

- (id)initWithInitialPoint: (NSPoint)initialPoint {
  self = [super init];
  if (self) {
    _path = [NSBezierPath bezierPath];
    
    [_path moveToPoint: initialPoint];
  }
  return self;
}

#pragma mark - Public Methods

- (void)addPoint: (NSPoint)point {
  [self.path lineToPoint: point];
}

- (void)draw {
  [[NSColor blackColor] set];
  [self.path stroke];
}

@end
