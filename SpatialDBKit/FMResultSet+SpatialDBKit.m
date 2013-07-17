//
//  FMResultSet+SpatialDBKit.m
//  SpatialDBKit
//
//  Created by Andrea Cremaschi on 11/03/13.
//  Copyright (c) 2013 redcluster.eu. All rights reserved.
//

#import "FMResultSet+SpatialDBKit.h"
#import <ShapeKit/ShapeKit.h>
#import <FMDB/FMDatabase.h>
#import <spatialite/gaiageo.h>

@implementation FMResultSet (SpatialDBKit)

- (ShapeKitGeometry*)geometryForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type([_statement statement], columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
        return nil;
    }

    const void *blob;
    int blob_size;
    gaiaGeomCollPtr geom;
    ShapeKitGeometry * shapekitGeom;
    
    sqlite3_stmt *stmt = [_statement statement];
    
    blob = sqlite3_column_blob (stmt, columnIdx);
    blob_size = sqlite3_column_bytes (stmt, columnIdx);

    /* checking if this BLOB actually is a GEOMETRY */
    geom = gaiaFromSpatiaLiteBlobWkb (blob, blob_size);
    if (!geom)
    {   // not a geometry
        return nil;
    }
    else
    {
        shapekitGeom = [[ShapeKitFactory defaultFactory] geometryWithGEOSGeometry: gaiaToGeos(geom)];
        /* we have now to free the GEOMETRY */
        gaiaFreeGeomColl (geom);

    }
    return shapekitGeom;
}

- (id)_swizzleObjectForColumnIndex:(int)columnIdx {
    
    sqlite3_stmt *stmt = [_statement statement];

    int columnType = sqlite3_column_type(stmt, columnIdx);
    id obj;
    switch (columnType) {
        case SQLITE_BLOB:
            obj = [self geometryForColumnIndex:columnIdx];
            if (obj) break;
        default:
            obj = [self _swizzleObjectForColumnIndex:columnIdx];
    }
    return obj;
    
/*    } else if ([obj isKindOfClass:[NSString class]])
    {
        // If a valid geometry object, pack it using ShapeKit
        ShapeKitGeometry *geom = [[ShapeKitFactory defaultFactory] geometryWithWKT: obj];
        if (geom) obj=geom;
    }
    return obj;*/
}

@end
