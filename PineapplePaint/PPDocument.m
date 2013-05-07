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
  [super windowControllerDidLoadNib:aController];
  // Add any code here that needs to be executed once the windowController has loaded the document's window.
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
      fprintf(f, "%f %f %f\n", p.x, p.y, r);  // WE NEED DATES
    }
    fputc('\n', f);
  }
  fclose(f);
  return YES;
}

- (BOOL)readFromData: (NSData *)data ofType: (NSString *)typeName error: (NSError **)outError {
  // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
  // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
  // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
  NSException *exception = [NSException exceptionWithName: @"UnimplementedMethod"
                                                   reason: [NSString stringWithFormat: @"%@ is unimplemented",
                                                            NSStringFromSelector(_cmd)]
                                                 userInfo: nil];
  @throw exception;
  return YES;
}

@end
