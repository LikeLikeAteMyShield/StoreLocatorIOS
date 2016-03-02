//
//  RouteViewController.swift
//  StoreLocJonathanC
//
//  Created by Jonny Cameron on 05/02/2016.
//  Copyright © 2016 Jonny Cameron. All rights reserved.
//

import UIKit
import MapKit

class RouteViewController: UIViewController, MKMapViewDelegate, MappingServiceDelegate, MapSettingsDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var routeDestination: MKMapItem!
    var mappingService: MappingService?
    
    var isFirstLoad = true
    
    var routeLineColor = UIColor.magentaColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsTraffic = true
        
        mappingService = MappingService(mapView: mapView, delegate: self)
        
        mappingService?.getDirectionsToLocation(routeDestination)
        
        loadingView.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        if isFirstLoad {
            mappingService?.zoomToUserLocation()
            isFirstLoad = false
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = routeLineColor
        renderer.lineWidth = 5.0
        
        return renderer
    }

    @IBAction func changedMapType(sender: UISegmentedControl) {
        
        switch (self.mapTypeControl.selectedSegmentIndex) {
            
        case 0:
            self.mapView.mapType = .Standard
            
        case 1:
            self.mapView.mapType = .HybridFlyover
            
        default:
            self.mapView.mapType = .Standard
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showSteps" {
            let routeSteps = mappingService?.routeSteps
            let nav = segue.destinationViewController as! UINavigationController
            let stepsController = nav.topViewController as! DirectionStepsTableViewController
        
            stepsController.routeSteps = routeSteps!
        }
    }
    
    func didChangeLineColor(color: UIColor) {
        
        routeLineColor = color
        mappingService?.getDirectionsToLocation(routeDestination)
    }
    
    func didBeginActivity() {
        
        loadingView.hidden = false
        indicator.startAnimating()
    }
    
    func didCompleteActivity() {
        
        indicator.stopAnimating()
        loadingView.hidden = true
    }
}
