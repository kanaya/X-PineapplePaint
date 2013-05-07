//
//  PPView.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PPView.h"
#import "PPStroke.h"
#import "PPPointAndPressure.h"

@implementation PPView {
  CALayer *backgroundLayer;  // should be anonymous category
}

#pragma mark - Init Methods

- (id)initWithFrame: (NSRect)frame {
  self = [super initWithFrame: frame];
  if (self) {
    _strokes = [NSMutableArray array];
    backgroundLayer = [CALayer layer];
    CGColorRef white = CGColorCreateGenericGray(1.0f, 1.0f);
    backgroundLayer.backgroundColor = white;
    CGColorRelease(white);
    backgroundLayer.delegate = self;
    [self setLayer: backgroundLayer];
    [self setWantsLayer: YES];
  }
  return self;
}

#pragma mark - Private Methods

- (void)drawInContext: (CGContextRef)context {
  for (PPStroke *stroke in self.strokes) {
    NSEnumerator *enumerator = stroke.pointsAndPressures.objectEnumerator;
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
}

#pragma mark - Public Methods

- (void)drawLayer: (CALayer *)layer inContext: (CGContextRef)context {
  [self drawInContext: context];
}

-(void)writeStrokeToFile: (FILE *)fout {
  [self.strokes enumerateObjectsUsingBlock:
   ^(PPStroke *stroke, NSUInteger index, BOOL *stop) {
     [stroke writeStrokeToFile: fout];
   }];
}

#pragma mark - Mouse Event Methods

- (void)mouseDown: (NSEvent *)event {
  NSPoint locationInView = [self convertPoint: event.locationInWindow
                                     fromView: nil];
  CGFloat pressure = (CGFloat)event.pressure;
  PPStroke *newStroke = [[PPStroke alloc] initWithInitialPoint: locationInView
                                                      pressure: pressure];
  [self.strokes addObject: newStroke];
  // [self setNeedsDisplay: YES];
  [backgroundLayer setNeedsDisplay];
}

- (void)mouseDragged: (NSEvent *)event {
  NSPoint locationInView = [self convertPoint: event.locationInWindow
                                     fromView: nil];
  CGFloat pressure = (CGFloat)event.pressure;
  PPStroke *currentStroke = [self.strokes lastObject];
  [currentStroke addPoint: locationInView pressure: pressure];
  // [self setNeedsDisplay: YES];
  [backgroundLayer setNeedsDisplay];
}

#pragma mark - NSView display optimization

- (BOOL)isOpaque {
  return YES;
}

@end
