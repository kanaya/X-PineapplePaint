//
//  PPStroke.h
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPStroke: NSObject
@property NSMutableArray *pointsAndPressures;
- (id)initWithInitialPoint: (CGPoint)initialPoint
                  pressure: (CGFloat)initialPressure
                      date: (NSTimeInterval)initialDate;
- (void)addPoint: (CGPoint)point pressure: (CGFloat)pressure date: (NSTimeInterval)date;
@end
