//
//  RecentSearchesTableViewController.swift
//  StoreLocJonathanC
//
//  Created by Jonny Cameron on 03/02/2016.
//  Copyright © 2016 Jonny Cameron. All rights reserved.
//

import UIKit

class RecentSearchesTableViewController: UITableViewController {
    
    var delegate: RecentSearchDelegate?
    var recentSearches = [RecentSearch]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let searches = loadRecentSearches() {
            self.recentSearches += searches
        }
    }
    
    func loadRecentSearches() -> [RecentSearch]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(RecentSearch.ArchiveURL.path!) as? [RecentSearch]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recentSearches.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentSearchCell", forIndexPath: indexPath) as! RecentSearchTableViewCell

        let index = indexPath.row
            
        let search = self.recentSearches[index]
        
        cell.searchPhraseLabel.text = search.searchPhrase

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let mainViewController = self.navigationController?.viewControllers[0]
        self.delegate = mainViewController as? RecentSearchDelegate
        
        delegate?.didSelectRecentSearch(recentSearches[indexPath.row].searchPhrase)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
