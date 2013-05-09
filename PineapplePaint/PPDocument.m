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
    _isEdited = NO;
  }
  return self;
}

- (NSString *)windowNibName {
  return @"PPDocument";
}

- (void)windowControllerDidLoadNib: (NSWindowController *)aController {
  [super windowControllerDidLoadNib: aController];
  [(PPViewController *)_viewController requestRedraw: self];
}

+ (BOOL)autosavesInPlace {
  return YES;
}

- (BOOL)isDocumentEdited {
  return self.isEdited;
}

- (BOOL)writeToURL: (NSURL *)url ofType: (NSString *)typeName error: (NSError *__autoreleasing *)outError {
  NSString *filename = [url path];
  FILE *f = fopen([filename UTF8String], "w");
  if (f) {
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
    self.isEdited = NO;
    return YES;
  }
  else {
    *outError = [NSError errorWithDomain: NSCocoaErrorDomain
                                    code: NSFileWriteUnknownError
                                userInfo: nil];
    return NO;
  }
}

- (BOOL)readFromURL: (NSURL *)url ofType: (NSString *)typeName error: (NSError *__autoreleasing *)outError {
  char readBuffer[1024];
  NSString *filename = [url path];
  FILE *f = fopen([filename UTF8String], "r");
  if (f) {
    PPStroke *stroke = [[PPStroke alloc] init];
    BOOL terminated;
    while (fgets(readBuffer, 1024, f) != NULL) {
      if (readBuffer[0] != '\n') {
        float t, px, py, r;
        sscanf(readBuffer, "%f %f %f %f\n", &t, &px, &py, &r);
        PPPointAndPressure *pp = [[PPPointAndPressure alloc] initWithPoint: CGPointMake(px, py)
                                                                  pressure: r
                                                                      date: t];
        [stroke addPointAndPressure: pp];
        terminated = NO;
      }
      else {
        [self.strokes addObject: stroke];
        stroke = [[PPStroke alloc] init];
        terminated = YES;
      }
    }
    if (!terminated) {
      // in case that the input file didn't end with an empty line
      [self.strokes addObject: stroke];
    }
    fclose(f);
    self.isEdited = NO;
    return YES;
  }
  else {
    *outError = [NSError errorWithDomain: NSCocoaErrorDomain
                                    code: NSFileReadUnknownError
                                userInfo: nil];
    return NO;
  }
}

@end
