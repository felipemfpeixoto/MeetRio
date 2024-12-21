//
//  EventCategory.swift
//  MeetRio
//
//  Created by Felipe on 21/12/24.
//

import Foundation

struct EventCategory: Codable {
    var eventType: EventType
    var hostelID: String?
    
    init(eventType: EventType, hostelID: String? = nil) {
        self.eventType = eventType
        self.hostelID = hostelID
    }
}

enum EventType: Codable {
    case hostel, nightlife
}
