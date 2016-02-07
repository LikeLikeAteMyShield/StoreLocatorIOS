//
//  MainMapViewController.swift
//  StoreLocJonathanC
//
//  Created by Jonny Cameron on 01/02/2016.
//  Copyright © 2016 Jonny Cameron. All rights reserved.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, RecentSearchDelegate {

    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    var mappingService: MappingService?
    var recentSearches = [RecentSearch]()
    
    var isFirstLoad = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        searchBar.delegate = self
        
        mappingService = MappingService(mapView: mapView)
        
        if let searches = loadRecentSearches() {
            recentSearches += searches
        }
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        if isFirstLoad {
            mappingService?.zoomToUserLocation()
            isFirstLoad = false
        }
    }
    
    @IBAction func clearButtonTapped(sender: AnyObject) {
        
        mappingService?.clearAllPins()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "WhereToSegue" {
            let destination = segue.destinationViewController as! DestinationsTableViewController
            destination.destinations = (mappingService?.searchResults)!
        }
        
        /*if segue.identifier == "RecentSearchesSegue" {
            let destination = segue.destinationViewController as! RecentSearchesTableViewController
            destination.recentSearches = (NSKeyedUnarchiver.unarchiveObjectWithFile(RecentSearch.ArchiveURL.path!) as? [RecentSearch])!
        }*/
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        mappingService?.performSearch(searchBar.text!)
        searchBar.resignFirstResponder()
        
        let search = RecentSearch(searchPhrase: searchBar.text!, timeStamp: NSDate())
        
        self.recentSearches.insert(search, atIndex: 0)
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recentSearches, toFile: RecentSearch.ArchiveURL.path!)
        
        if isSuccessfulSave {
            print("Saved search")
        }
    }
    
    func loadRecentSearches() -> [RecentSearch]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(RecentSearch.ArchiveURL.path!) as? [RecentSearch]
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if motion == UIEventSubtype.MotionShake {
            mappingService?.clearAllPins()
        }
    }
    
    @IBAction func mapTypeChanged(sender: UISegmentedControl) {
        
        switch (self.mapTypeControl.selectedSegmentIndex) {
            
        case 0:
            self.mapView.mapType = .Standard
            
        case 1:
            self.mapView.mapType = .HybridFlyover
            
        default:
            self.mapView.mapType = .Standard
        }
    }
    
    func didSelectRecentSearch(searchPhrase: String) {
        
        mappingService?.performSearch(searchPhrase)
    }
}
