//
//  PPStroke.h
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPPointAndPressure.h"

@interface PPStroke: NSObject
@property NSMutableArray *pointsAndPressures;
- (id)init;
- (id)addPointAndPressure: (PPPointAndPressure *)pp;
@end
