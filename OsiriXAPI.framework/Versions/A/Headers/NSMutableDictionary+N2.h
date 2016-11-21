/*=========================================================================
  Program:   OsiriX

  Copyright (c) OsiriX Team
  All rights reserved.
  Distributed under GNU - LGPL
  
  See http://www.osirix-viewer.com/copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.
=========================================================================*/

#import <Cocoa/Cocoa.h>


@interface NSMutableDictionary (N2)

-(void)removeObject:(id)obj;
-(void) setObjectIfNonNil: (id) obj forKey: (NSString*) key;
-(void)setBool:(BOOL)b forKey:(NSString*)key;

@end
