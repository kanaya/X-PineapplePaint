//
//  PPDocument.h
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PPDocument: NSDocument {
  IBOutlet NSObject *_viewController;
}
@property NSMutableArray *strokes;  // new

@end
