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
- (id)initWithInitialPoint: (NSPoint)initialPoint;
- (void)addPoint: (NSPoint)point;
- (void)draw;
- (void)drawPath;
@end
