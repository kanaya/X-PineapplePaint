//
//  PPView.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PPView.h"
#import "PPViewController.h"
#import "PPDocument.h"
#import "PPStroke.h"
#import "PPPointAndPressure.h"

@interface PPView ()
@property CALayer *backgroundLayer;
@end

@implementation PPView

#pragma mark - Init Methods

- (id)initWithFrame: (NSRect)frame {
  self = [super initWithFrame: frame];
  if (self) {
    _backgroundLayer = [CALayer layer];
    CGColorRef white = CGColorCreateGenericGray(1.0f, 1.0f);
    _backgroundLayer.backgroundColor = white;
    CGColorRelease(white);
    _backgroundLayer.delegate = self;
    [self setLayer: _backgroundLayer];
    [self setWantsLayer: YES];
  }
  return self;
}

#pragma mark - Private Methods

- (void)drawInContext: (CGContextRef)context {
  PPViewController *vc = (PPViewController *)_viewController;
  PPDocument *doc = (PPDocument *)[vc document];
  for (PPStroke *stroke in doc.strokes) {
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

- (void)requestRedraw {
  NSLog(@"Redraw");
  [self.backgroundLayer setNeedsDisplay];
}

#pragma mark - Mouse Event Methods

- (void)mouseDown: (NSEvent *)event {
  NSPoint locationInView = [self convertPoint: event.locationInWindow
                                     fromView: nil];
  CGFloat pressure = (CGFloat)event.pressure;
  NSDate *now = [NSDate date];
  
  PPViewController *vc = (PPViewController *)_viewController;
  PPDocument *doc = (PPDocument *)[vc document];
  PPStroke *newStroke = [[PPStroke alloc] init];
  [newStroke addPointAndPressure: [[PPPointAndPressure alloc] initWithPoint: locationInView
                                                                   pressure: pressure
                                                                       date: [now timeIntervalSinceReferenceDate]]];
  [doc.strokes addObject: newStroke];
  [self.backgroundLayer setNeedsDisplay];
}

- (void)mouseDragged: (NSEvent *)event {
  NSPoint locationInView = [self convertPoint: event.locationInWindow
                                     fromView: nil];
  CGFloat pressure = (CGFloat)event.pressure;
  NSDate *now = [NSDate date];
  
  PPViewController *vc = (PPViewController *)_viewController;
  PPDocument *doc = (PPDocument *)[vc document];
  PPStroke *currentStroke = [doc.strokes lastObject];
  [currentStroke addPointAndPressure: [[PPPointAndPressure alloc] initWithPoint: locationInView
                                                                       pressure: pressure
                                                                           date: [now timeIntervalSinceReferenceDate]]];
  [self.backgroundLayer setNeedsDisplay];
}

#pragma mark - NSView display optimization

- (BOOL)isOpaque {
  return YES;
}

@end
