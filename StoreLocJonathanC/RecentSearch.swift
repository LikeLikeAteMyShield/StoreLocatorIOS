//
//  RecentSearch.swift
//  StoreLocJonathanC
//
//  Created by Jonny Cameron on 03/02/2016.
//  Copyright © 2016 Jonny Cameron. All rights reserved.
//

import Foundation

class RecentSearch: NSObject, NSCoding {
    
    let searchPhrase: String
    let timeStamp: NSDate
    
    struct PropertyKey {
        
        static let searchPhraseKey = "searchPhrase"
        static let timeStampKey = "timeStamp"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("recentSearches")
    
    init(searchPhrase: String, timeStamp: NSDate) {
        
        self.searchPhrase = searchPhrase
        self.timeStamp = timeStamp
        
        super.init()
    }
    
    internal func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(searchPhrase, forKey: PropertyKey.searchPhraseKey)
        aCoder.encodeObject(timeStamp, forKey: PropertyKey.timeStampKey)
    }
    
    required convenience internal init?(coder aDecoder: NSCoder) {
        
        let searchPhrase = aDecoder.decodeObjectForKey(PropertyKey.searchPhraseKey) as! String
        let timeStamp = aDecoder.decodeObjectForKey(PropertyKey.timeStampKey) as! NSDate
        
        self.init(searchPhrase: searchPhrase, timeStamp: timeStamp)
    }
}