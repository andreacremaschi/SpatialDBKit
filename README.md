SpatialDBKit
============

An Objective-C lightweight spatial RDBMS (based on SQLite/SpatiaLite).
The project extends the capabilities of FMDB allowing to perform spatial SQL queries to obtain easy-to-use Cocoa objects.
You should be familiar with [FMDB](https://github.com/ccgus/fmdb) and [ShapeKit](https://github.com/andreacremaschi/ShapeKit) before attempting to use this!

## How to use ##

Since importing C libraries is a sort of nightmare, SpatialDBKit has been thought to be used with [CocoaPods](http://cocoapods.org) that should address all the boring stuff for you.

```
platform :ios, '5.0'
pod 'SpatialDBKit'
```

Of course now you should ```#import <SpatialDBKit/SpatialDatabase.h>```

## Features ##

With SpatialDBKit you will be able to:

* Open a spatialite database:

```Objective-C
    // Open a spatialite database
    SpatialDatabase *db = [SpatialDatabase databaseWithPath: [[NSBundle mainBundle] pathForResource:@"test" ofType:@"sqlite"]];
    [db open];
```

* fetch geometries (that will be returned in form of Shapekit objects):

```Objective-C    
    FMResultSet *rs = [db executeQuery:@"select AsText(geometry) AS text FROM Regions"];
    while ([rs next])
    {
        id object = [rs resultDict];
        
        NSLog(@"%@", object);
    }
```

* filtering by distance if you need to:

```Objective-C    
    FMResultSet *rs = [db executeQuery:@"select distance(geometry, MakePoint(45.694216,9.676909,4326)) AS text FROM Regions"];
```

Check [spatialite SQL functions reference list](http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.1.0.html) to be sure you don't miss anything!



## License ##

 * [PROJ.4](http://trac.osgeo.org/proj/) is under the MIT license.

 * [GEOS](http://trac.osgeo.org/geos/) is available under the terms of  [GNU Lesser General Public License (LGPL)](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html), and is a project of  [OSGeo](http://www.osgeo.org).
 * [ShapeKit](https://github.com/andreacremaschi/ShapeKit), being a GEOS wrapper, is under the terms of GNU Lesser General Public License.

 * [spatialite](https://www.gaia-gis.it/fossil/libspatialite/index) is developed and maintained by Alessandro Furieri  and are licensed under the [MPL tri-license](http://www.mozilla.org/MPL/boilerplate-1.1/mpl-tri-license-html) terms.
 * SpatialDBKit itself is licensed under the same MPL tri-license terms.

 * [SQLite](http://www.sqlite.org/copyright.html) has been dedicated to the public domain by the authors (thanks!).
 * Its Objective-C wrapper, [FMDB](https://github.com/ccgus/fmdb) by Gus Mueller, is under the MIT License.

**License note: Be aware that LGPL v2.1 (GEOS license) and Apple Store compatibility is at least controversial** ([Ragi Burhum's blog post](http://blog.burhum.com/post/38236943467/your-lgpl-license-is-completely-destroying-ios-adoption) explains why - I join his appeal to open up the license, anyway).
