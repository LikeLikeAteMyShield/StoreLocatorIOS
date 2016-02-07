//
//  MappingService.swift
//  StoreLocJonathanC
//
//  Created by Jonny Cameron on 01/02/2016.
//  Copyright © 2016 Jonny Cameron. All rights reserved.
//

import Foundation
import MapKit

class MappingService {

    var mapView: MKMapView
    var searchResults: [MKMapItem]
    
    init(mapView:MKMapView) {
        self.mapView = mapView
        self.searchResults = [MKMapItem]()
    }
    
    func zoomToUserLocation() {

        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 15000, 15000)
        mapView.setRegion(region, animated: false)
    }
    
    func performSearch(searchPhrase: String) {
        
        clearAllPins()
        
        let spinner = UIActivityIndicatorView()
        spinner.color = UIColor.blackColor()
        spinner.center = mapView.center
        
        let transform = CGAffineTransformMakeScale(2, 2)
        spinner.transform = transform
        
        spinner.startAnimating()
        
        mapView.addSubview(spinner)
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchPhrase
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { response, error in
            
            guard let response = response else {
                print("No results found")
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                return
            }
            
            for item in response.mapItems {
                self.searchResults.append(item)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                
                self.mapView.addAnnotation(annotation)
            }
            
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
    
    func clearAllPins() {
        
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        searchResults.removeAll()
    }
    
    func getDirectionsToLocation(destination: MKMapItem) {
    
        let request = MKDirectionsRequest()
        
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = destination
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { response, error in
            if error != nil {
                print("Error getting directions")
            } else {
                for route in response!.routes {
                    self.mapView.addOverlay(route.polyline, level: .AboveRoads)
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = destination.placemark.coordinate
                annotation.title = destination.name
                
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}