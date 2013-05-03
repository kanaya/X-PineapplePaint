//
//  PPViewController.m
//  PineapplePaint
//
//  Created by Ichi Kanaya on 4/29/13.
//  Copyright (c) 2013 Pineapple.cc. All rights reserved.
//

#import "PPViewController.h"
#import "PPView.h"
#import "PPStroke.h"

@implementation PPViewController

- (IBAction)writeStrokes: (id)sendor {
  NSString *filename = [@"~/PineapplePaintOut.txt" stringByExpandingTildeInPath];
  [self writeStrokesToFilename: filename];
}

- (void)writeStrokesToFilename: (NSString *)filename {
  const char *filenameInCStyle = [filename UTF8String];
  FILE *fout = fopen(filenameInCStyle, "w");
  // is fout opened collectrly?
  PPView *v = (PPView *)_view;
  for (PPStroke *s in v.strokes) {
    [s writeStrokeToFile: fout];
  }
  fclose(fout);
}

@end
