//
//  OfflineMap.swift
//  anti-piracy-iOS-app
//
//  Created by Travis Baumgart on 2/10/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

import Foundation
import MapKit

class OfflineMap {
    
    let path = NSBundle.mainBundle().pathForResource("ne_50m_land.simplify0.2", ofType: "geojson")
    var polygons: [MKPolygon] = [];
    
    init()
    {
        var geoJson: NSDictionary = self.generateDictionaryFromGeoJson()
        var features: NSArray = geoJson["features"] as! NSArray
        generateExteriorPolygons(features)
    }
    
    func generateDictionaryFromGeoJson() -> NSDictionary
    {
        let fileContent = NSData(contentsOfFile: path!)
        var error: NSError?
        var jsonDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(fileContent!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        return jsonDict
    }
    
    func generateExteriorPolygons(features: NSArray) {
        
        //add ocean polygons
        var ocean1Coordinates = [
            CLLocationCoordinate2DMake(90, 0),
            CLLocationCoordinate2DMake(90, -180.0),
            CLLocationCoordinate2DMake(-90.0, -180.0),
            CLLocationCoordinate2DMake(-90.0, 0)]
        
        var ocean2Coordinates = [
            CLLocationCoordinate2DMake(90, 0),
            CLLocationCoordinate2DMake(90, 180.0),
            CLLocationCoordinate2DMake(-90.0, 180.0),
            CLLocationCoordinate2DMake(-90.0, 0)
        ]
        
        var ocean1 = MKPolygon(coordinates: &ocean1Coordinates, count: ocean1Coordinates.count)
        var ocean2 = MKPolygon(coordinates: &ocean2Coordinates, count: ocean2Coordinates.count)
        
        ocean1.title = "ocean"
        ocean2.title = "ocean"
        
        polygons.append(ocean1)
        polygons.append(ocean2)
        
        //add feature polygons
        for feature in features
        {
            
            var geometry = feature["geometry"] as! NSDictionary
            var geometryType = geometry["type"]! as! String
            
            if "MultiPolygon" == geometryType {
                var subPolygons = geometry["coordinates"] as! NSArray
                for subPolygon in subPolygons
                {
                    var subPolygon = generatePolygon(subPolygon as! NSArray)
                    polygons.append(subPolygon)
                }
                
            }
            
        }
        
    }
    
    func generatePolygon(coordinates: NSArray) -> MKPolygon {
        
        var exteriorPolygonCoordinates = coordinates[0] as! NSArray;
        var exteriorCoordinates: [CLLocationCoordinate2D] = [];
        
        //build out Array of coordinates
        for coordinate in exteriorPolygonCoordinates {
            var y = coordinate[0] as! Double;
            var x = coordinate[1] as! Double;
            var exteriorCoordinate = CLLocationCoordinate2DMake(x, y);
            exteriorCoordinates.append(exteriorCoordinate)
        }
        
        //build Polygon
        var exteriorPolygon = MKPolygon(coordinates: &exteriorCoordinates, count: exteriorCoordinates.count)
        exteriorPolygon.title = "land"
        
        return exteriorPolygon
        
    }
    
}