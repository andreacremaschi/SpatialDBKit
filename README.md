SpatialDBKit
============

An Objective-C lightweight spatial RDBMS (based on SQLite/SpatiaLite).
The project manages a whole stack of technologies that allow combined together to perform spatial SQL queries (i.e. queries based on distance, intersection between geometries etc.) to obtain easy-to-use Cocoa objects.

While fully working, the project is in alpha stage, please be careful using this in production projects.

## Features ##

With SpatialDBKit you will be able to:

* Open a spatialite database:

```Objective-C
    // Open a spatialite database
    SpatialDatabase *db = [SpatialDatabase databaseWithPath: [[NSBundle mainBundle] pathForResource:@"test" ofType:@"sqlite"]];
    [db open];
```

* fetch geometries in form of Shapekit objects:

```Objective-C    
    FMResultSet *rs = [db executeQuery:@"select Name, geometry FROM Regions"];
        while ([rs next]) {
        NSLog(@"%@", [resultSet resultDictionary]);
    }
```    
    
* or in textual form:

```Objective-C    
    FMResultSet *rs = [db executeQuery:@"select Name, AsText(geometry) as geom_text FROM Regions"];
```

* calculating distance from a point if you need to:

```Objective-C    
    FMResultSet *rs = [db executeQuery:@"select distance(geometry, MakePoint(45.694216,9.676909,4326)) AS text FROM Regions"];
```

* or filtering points by distance:

```Objective-C    
    FMResultSet *resultSet= [db executeQuery:@"SELECT astext(geometry) as geometry, distance(geometry, MakePoint(45.694216,9.676909,4326)) as geometry, Name FROM Towns where distance(geometry, MakePoint(45.694216,9.676909,4326)) < 5000"];
```


This is just the point of the iceberg.. check [spatialite SQL functions reference list](https://www.gaia-gis.it/fossil/libspatialite/index) to be sure you don't miss anything of this awesome library!

## How to use it ##

Since importing C libraries is a sort of nightmare, SpatialDBKit has been thought to be used with [CocoaPods](http://cocoapods.org) that should address all the boring stuff for you.
But before you must install the [GNU build system](http://en.wikipedia.org/wiki/GNU_build_system) if you haven't already:

```
brew install automake autoconf libtool
```

Now you can create your Podfile as usual: 

```
platform :ios, '5.0'
pod 'SpatialDBKit'
```

Of course now you should ```#import <SpatialDBKit/SpatialDatabase.h>```

Now ___two extra step are required___: 

1. rename your main file main.m to main.mm 
The long story is that SpatialDBKit dependencies reside on C++ libraries, so we should tell the compiler that our project files should be treated as Objective-C++. The podspec correctly sets C++ Standard Library project's build setting to libstdc++ (GNU c++ standard library), but XCode 5.1 can't find any Objective-C++ file in the main project, so ignores the setting and links with libc++. Renaming a file with .mm extension does the trick.

2. manually open ```spatialite.c``` and replace (line 87):

```
#include <spatialite/spatialite.h>
```

with:

```
#include <spatialite/spatialite/spatialite.h>
```

This is a workaround to fix the issue tracked here: https://github.com/andreacremaschi/SpatialDBKit/issues/12 (while I figure out something better, or it is fixed in CocoaPods, or in the spatialite's pod specification).

## Documentation ##

Since SpatialDBKit actually sits on a stack of technology, you should refer to the submodules documentation. The most relevant are:

- [spatialite](https://www.gaia-gis.it/fossil/libspatialite/index)
- [ShapeKit](https://github.com/andreacremaschi/ShapeKit) 
- [FMDB](https://github.com/ccgus/fmdb)


## License ##

 * [PROJ.4](http://trac.osgeo.org/proj/) is under the MIT license.

 * [GEOS](http://trac.osgeo.org/geos/) is available under the terms of  [GNU Lesser General Public License (LGPL)](http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html), and is a project of  [OSGeo](http://www.osgeo.org).
 * [ShapeKit](https://github.com/andreacremaschi/ShapeKit), being a GEOS wrapper, is under the terms of GNU Lesser General Public License.

 * [spatialite](https://www.gaia-gis.it/fossil/libspatialite/index) is developed and maintained by Alessandro Furieri  and are licensed under the [MPL tri-license](http://www.mozilla.org/MPL/boilerplate-1.1/mpl-tri-license-html) terms.
 * SpatialDBKit itself is licensed under the same MPL tri-license terms.

 * [SQLite](http://www.sqlite.org/copyright.html) has been dedicated to the public domain by the authors (thanks!).
 * Its Objective-C wrapper, [FMDB](https://github.com/ccgus/fmdb) by Gus Mueller, is under the MIT License.

**License note: Be aware that LGPL v2.1 (GEOS license) and Apple Store compatibility is at least controversial** (search for "LGPL iOS" on Google to know why).
