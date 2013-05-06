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

@implementation PPView {
  CALayer *backgroundLayer;
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

- (void)drawContext: (CGContextRef)context {
  for (PPStroke *stroke in self.strokes) {
    for (PPPointAndPressure *pp in stroke.pointsAndPressures) {
      CGPoint p = pp.point;
      CGFloat r = pp.pressure;
      CGContextSetRGBFillColor(context, 0, 0, 0, r);
      CGContextFillRect(context, CGRectMake(p.x - 2, p.y - 2, 4, 4));
    }
  }
}

#pragma mark - Public Methods

- (void)drawLayer: (CALayer *)layer inContext: (CGContextRef)context {
  [self drawContext: context];
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
