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
    
    var routeSteps = [MKRouteStep]()
    
    var spinner: UIActivityIndicatorView?
    
    var delegate: MappingServiceDelegate
    
    init(mapView:MKMapView, delegate: MappingServiceDelegate) {
        self.mapView = mapView
        self.searchResults = [MKMapItem]()
        self.delegate = delegate
    }
    
    func zoomToUserLocation() {

        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 15000, 15000)
        mapView.setRegion(region, animated: false)
    }
    
    func performSearch(searchPhrase: String) {
        
        clearAllPins()
        
        delegate.didBeginActivity!()
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchPhrase
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { response, error in
            
            guard let response = response else {
                print("No results found")
                self.delegate.didFindZeroSearchResults!()
                self.delegate.didCompleteActivity!()
                return
            }
            
            for item in response.mapItems {
                self.searchResults.append(item)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                annotation.subtitle =  item.placemark.thoroughfare
                
                self.mapView.addAnnotation(annotation)
            }
            
            self.delegate.didCompleteActivity!()
        }
    }
    
    func clearAllPins() {
        
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        searchResults.removeAll()
    }
    
    func getDirectionsToLocation(destination: MKMapItem) {
        
        delegate.didBeginActivity!()
        
        let request = MKDirectionsRequest()
        
        request.source = MKMapItem.mapItemForCurrentLocation()
        request.destination = destination
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { response, error in
            if error != nil {
                print("Error getting directions")
                self.delegate.didCompleteActivity!()
            } else {
                for route in response!.routes {
                    self.mapView.addOverlay(route.polyline, level: .AboveRoads)
                    
                    for step in route.steps {
                        self.routeSteps.append(step)
                    }
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = destination.placemark.coordinate
                annotation.title = destination.name
                
                self.mapView.addAnnotation(annotation)
                
                self.delegate.didCompleteActivity!()
            }
        }
    }
}