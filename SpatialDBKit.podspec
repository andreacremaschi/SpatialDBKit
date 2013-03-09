Pod::Spec.new do |s|
  s.name	= "SpatialDBKit"
  s.version	= "0.0.1"
  s.summary	= "SpatialDBKit is the spatial RDBMS for iOS."
  s.description = "SpatialDBKit is actually an Objective-C wrapper of SpatiaLite, the smallest and simplest while powerful Spatial RDBMS in the world!"
  s.homepage	= ""
  s.license	= { :type => "Mozilla Public License v1.1",
		    :file => "LICENSE" }
  s.author	= { "Andrea Cremaschi" => "andrea.cremaschi@midainformatica.it" }

  s.ios.deployment_target = "4.0"
  s.osx.deployment_target = "10.6"

  s.dependency 'spatialite'
  s.dependency 'FMDB'
  s.dependency 'ShapeKit'

# this config will hijack FMDB includes (#include "sqlite3.h"), so that it will include the header defined by spatialite
# this way FMDB will become a wrapper of spatialite's embedded sqlite code!! (ugh)
# TODO: -lsqlite3 Linker Flag, defined by FMDB pod, should be removed. 
  s.xcconfig = { 'USER_HEADER_SEARCH_PATHS' => '${PODS_ROOT}/spatialite/headers/spatialite' }

end
