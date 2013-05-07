//
//  PPPointAndPressure.h
//  PineapplePaint
//
//  Created by Ichi Kanaya on 5/6/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPPointAndPressure: NSObject
@property CGPoint point;
@property CGFloat pressure;

- (id)initWithPoint: (CGPoint)initialPoint pressure: (CGFloat)initialPressure;

@end
