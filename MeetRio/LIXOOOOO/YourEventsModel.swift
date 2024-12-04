//
//  YourEventsModel.swift
//  MeetRio
//
//  Created by Luiz Seibel on 01/11/24.
//

import Foundation

@Observable
class YourEventsModelLIXO: Codable {
    static let shared = (try? YourEventsModel.load()) ?? YourEventsModel()
 
    var events: [EventDetails]
    
    init() {
        self.events = []
    }
    
    func addEvent(_ event: EventDetails) {
        self.events.append(event)
    }
    
    func removeEvent(_ event: EventDetails) {
        self.events.removeAll(where: { $0.id == event.id })
    }
}
