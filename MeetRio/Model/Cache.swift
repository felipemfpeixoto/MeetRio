//
//  EventCache.swift
//  MeetRio
//
//  Created by Luiz Seibel on 30/09/24.
//

import Foundation

class EventCache {
    static let shared = EventCache() // Singleton for global access
    
    private let cache = NSCache<NSString, NSArray>()
    
    private init() {
        // Optional: Set cache limits if necessary
        // cache.countLimit = 100 // Max number of categories stored
        // cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB, for example
    }
    
    // Retrieves events for a specific category
    func getEvents(forCategory category: String) -> [EventDetails]? {
        if let cachedArray = cache.object(forKey: category as NSString) as? [EventDetails] {
            return cachedArray
        }
        return nil
    }
    
    // Stores events for a specific category
    func setEvents(_ events: [EventDetails], forCategory category: String) {
        cache.setObject(events as NSArray, forKey: category as NSString)
    }
    
    // Clears the cache
    func clearCache() {
        cache.removeAllObjects()
    }
}
