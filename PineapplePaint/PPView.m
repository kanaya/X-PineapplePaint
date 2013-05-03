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

- (void)draw: (NSRect)rect {
  [[NSColor whiteColor] set];
  NSRectFill(rect);
  
  [self.strokes enumerateObjectsUsingBlock:
   ^(PPStroke *stroke, NSUInteger index, BOOL *stop) {
     [stroke draw];
   }];
}

#pragma mark - Public Methods

// For non-CA drawing
//
// - (void)drawRect: (NSRect)rect {
//   [self draw: rect];
// }

- (void)drawLayer: (CALayer *)layer inContext: (CGContextRef)context {
  NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort: context
                                                                                    flipped: NO];
  [NSGraphicsContext saveGraphicsState];
  [NSGraphicsContext setCurrentContext: nsGraphicsContext];
  
  NSRect rect = self.frame;
  [self draw: rect];
  
  [NSGraphicsContext restoreGraphicsState];
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
  PPStroke *newStroke = [[PPStroke alloc] initWithInitialPoint: locationInView];
  [self.strokes addObject: newStroke];
  // [self setNeedsDisplay: YES];
  [backgroundLayer setNeedsDisplay];
}

- (void)mouseDragged: (NSEvent *)event {
  NSPoint locationInView = [self convertPoint: event.locationInWindow
                                     fromView: nil];
  PPStroke *currentStroke = [self.strokes lastObject];
  [currentStroke addPoint: locationInView];
  // [self setNeedsDisplay: YES];
  [backgroundLayer setNeedsDisplay];
}

#pragma mark - NSView display optimization

- (BOOL)isOpaque {
  return YES;
}

@end
