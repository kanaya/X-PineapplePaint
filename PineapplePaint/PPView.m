//
//  PPView.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import "PPView.h"
#import "PPStroke.h"

@interface PPView ()
@property NSMutableArray *strokes;
@end

@implementation PPView

#pragma mark - Init Methods

- (id)initWithFrame: (NSRect)frame {
  self = [super initWithFrame: frame];
  if (self) {
    _strokes = [NSMutableArray array];
  }
  return self;
}

#pragma mark - Public Methods

- (void)drawRect: (NSRect)rect {
  [[NSColor whiteColor] set];
  NSRectFill(rect);
  
  [self.strokes enumerateObjectsUsingBlock:
   ^(PPStroke *stroke, NSUInteger index, BOOL *stop) { [stroke draw]; }];
}

#pragma mark - Mouse Event Methods

- (void)mouseDown: (NSEvent *)event {
  NSPoint locationInView = [self convertPoint: event.locationInWindow
                                     fromView: nil];
  PPStroke *newStroke = [[PPStroke alloc] initWithInitialPoint: locationInView];
  [self.strokes addObject: newStroke];
  [self setNeedsDisplay: YES];
}

- (void)mouseDragged: (NSEvent *)event {
  NSPoint locationInView = [self convertPoint: event.locationInWindow
                                     fromView: nil];
  PPStroke *currentStroke = [self.strokes lastObject];
  [currentStroke addPoint: locationInView];
  [self setNeedsDisplay: YES];
}

#pragma mark - NSView display optimization

- (BOOL)isOpaque {
  return YES;
}

@end
