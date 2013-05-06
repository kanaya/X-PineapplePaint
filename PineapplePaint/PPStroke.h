//
//  PPStroke.h
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPStroke: NSObject
@property NSBezierPath *path;
@property NSMutableArray *points;
@property NSMutableArray *pressures;
- (id)initWithInitialPoint: (NSPoint)initialPoint pressure: (CGFloat)initialPressure;
- (void)addPoint: (NSPoint)point pressure: (CGFloat)pressure;
- (void)draw;
- (void)drawVelocity;
- (void)writeStrokeToFile: (FILE *)fout;
@end
