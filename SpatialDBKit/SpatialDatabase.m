//
//  SpatialDatabase.m
//  SpatialDBKit
//
//  Created by Andrea Cremaschi on 11/03/13.
//
// * This is free software; you can redistribute and/or modify it under
// the terms of the Mozilla Public License Version 1.1
//
// Alternatively, the contents of this file may be used under the terms of
// either the GNU General Public License Version 2 or later (the "GPL"), or
// the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
// See the LICENSE file for more information.


#import "SpatialDatabase.h"
#import <objc/runtime.h>
#import <FMDB/FMResultSet.h>
#import <FMDB/FMDatabase.h>
#import "FMResultSet+SpatialDBKit.h"

@interface FMResultSet (MyCategory)
- (id)objectForColumnIndex:(int)columnIdx;
- (id)_swizzleObjectForColumnIndex:(int)columnIdx;
@end

static char const * const SpatialiteTagKey = "SpatialiteTagKey";

static NSUInteger SpatialDatabaseInstances = 0;


void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

@implementation SpatialDatabase

+ (NSString*)spatialiteLibVersion
{
    return [NSString stringWithFormat:@"%d", spatialite_version()];
}


- (id)initWithPath:(NSString *)inPath
{
    self = [super initWithPath:(NSString *)inPath];
    if (self)
    {
        SpatialDatabaseInstances++;
        if (SpatialDatabaseInstances==1)
        {
            NSLog(@"Spatialite initialization");
            spatialite_init(TRUE);
            Swizzle([FMResultSet class], @selector(objectForColumnIndex:), @selector(_swizzleObjectForColumnIndex:));
        }
    }
    return self;
}

-(void)dealloc
{
    // remove reference to dummyObject
    SpatialDatabaseInstances--;
    if (SpatialDatabaseInstances == 0)
    {
        NSLog(@"Terminating spatialite");
        spatialite_cleanup();
    }
}

@end

