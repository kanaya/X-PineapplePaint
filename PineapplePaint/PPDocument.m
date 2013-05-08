//
//  PPDocument.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import "PPDocument.h"
#import "PPStroke.h"
#import "PPPointAndPressure.h"
#import "PPViewController.h"

@implementation PPDocument

- (id)init {
  self = [super init];
  if (self) {
    self.strokes = [NSMutableArray arrayWithCapacity: 1024];
  }
  return self;
}

- (NSString *)windowNibName {
  return @"PPDocument";
}

- (void)windowControllerDidLoadNib: (NSWindowController *)aController {
  [super windowControllerDidLoadNib: aController];
  // Add any code here that needs to be executed once the windowController has loaded the document's window.
  [(PPViewController *)_viewController requestRedraw];
}

+ (BOOL)autosavesInPlace {
  return YES;
}

- (BOOL)writeToURL: (NSURL *)url ofType: (NSString *)typeName error: (NSError *__autoreleasing *)outError {
  NSString *filename = [url path];
  FILE *f = fopen([filename UTF8String], "w");
  for (PPStroke *stroke in self.strokes) {
    for (PPPointAndPressure *pp in stroke.pointsAndPressures) {
      CGPoint p = pp.point;
      CGFloat r = pp.pressure;
      NSTimeInterval t = pp.date;
      fprintf(f, "%f %f %f %f\n", t, p.x, p.y, r);
    }
    fputc('\n', f);
  }
  fclose(f);
  return YES;
}

- (BOOL)readFromURL: (NSURL *)url ofType: (NSString *)typeName error: (NSError *__autoreleasing *)outError {
  char readBuffer[1024];
  NSString *filename = [url path];
  FILE *f = fopen([filename UTF8String], "r");
  // assert f != NULL
  PPStroke *stroke = [[PPStroke alloc] init];
  while (fgets(readBuffer, 1024, f) != NULL) {
    if (readBuffer[0] != '\0') {
      float t, px, py, r;
      sscanf(readBuffer, "%f %f %f %f\n", &t, &px, &py, &r);
      PPPointAndPressure *pp = [[PPPointAndPressure alloc] initWithPoint: CGPointMake(px, py)
                                                                pressure: r
                                                                    date: t];
      [stroke addPointAndPressure: pp];
    }
  }
  [self.strokes addObject: stroke];
  fclose(f);
  return YES;
}

@end
