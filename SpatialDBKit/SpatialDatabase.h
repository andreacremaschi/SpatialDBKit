//
//  SpatialDatabase.h
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


#import <FMDB/FMDatabase.h>

@interface SpatialDatabase : FMDatabase
+ (NSString*)spatialiteLibVersion;

@end
