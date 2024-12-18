//
//  FirestoreManager.swift
//  MeetRio
//
//  Created by Felipe on 09/08/24.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

@Observable
class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() {}
    
    let db = Firestore.firestore()
    let cache = EventCache.shared
    
    var allEvents: [EventDetails] = []
    
    let collection = "TesteEvents"
    
    var weekEvents: [Int: [EventDetails]] = [
        Calendar.current.component(.day, from: Date()) : [],
        Calendar.current.component(.day, from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!) : [],
        Calendar.current.component(.day, from: Calendar.current.date(byAdding: .day, value: 2, to: Date())!) : [],
        Calendar.current.component(.day, from: Calendar.current.date(byAdding: .day, value: 3, to: Date())!) : []
    ]
    
    func getAllEvents() async {
        do {
            let querySnapshot = try await db.collection(collection).getDocuments()
            self.allEvents = []  // Clear the events array before populating
            
            for document in querySnapshot.documents {
                do {
                    // MARK: Tem forma melhor de fazer com certeza
                    let id = document.documentID
                    let apiResponse = try document.data(as: EventDetails.self)
                    apiResponse.id = id
                    self.allEvents.append(apiResponse)
                } catch {
                    print("Failed to parse document data into EventDetails for document ID: \(document.documentID). Error: \(error)")
                    return
                }
            }
            
            // Cache the allEvents
            cache.setEvents(allEvents, forCategory: "allEvents")
        } catch {
            print("Error getting documents: \(error)")
        }
    }

    func getSpecificDayEvent(selectedDate: Date) async -> [EventDetails] {
        let calendar = Calendar.current
        
        // Início do dia (00:00:00)
        let startOfDay = calendar.startOfDay(for: selectedDate)
        
        // Fim do dia (23:59:59)
        let endOfDay: Date = {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return calendar.date(byAdding: components, to: startOfDay)!
        }()
        
        let cacheKey = "events_\(startOfDay.timeIntervalSince1970)_\(endOfDay.timeIntervalSince1970)"
        
        // Check cache first
        if let cachedEvents = cache.getEvents(forCategory: cacheKey) {
            print("Events loaded from cache for date: \(selectedDate)")
            return cachedEvents
        }
        
        do {
            let querySnapshot = try await db.collection(collection)
                .whereField("dateDetails.startDate", isGreaterThanOrEqualTo: startOfDay)
                .whereField("dateDetails.startDate", isLessThanOrEqualTo: endOfDay)
                .getDocuments()
            
            var events: [EventDetails] = []
            
            for document in querySnapshot.documents {
                if let apiResponse = try? document.data(as: EventDetails.self) {
                    apiResponse.id = document.documentID
                    events.append(apiResponse)
                }
            }
            // Cache the events
            cache.setEvents(events, forCategory: cacheKey)
            return events
        } catch {
            print("Error getting documents: \(error)")
        }
        return []
    }
    
    func getLabeledEvents(_ queryName: String) async -> [EventDetails] {
        // Check cache first
        if let cachedEvents = cache.getEvents(forCategory: queryName) {
            return cachedEvents
        }
        
        do {
            let querySnapshot = try await db.collection(collection)
                .whereField("eventCategory", isEqualTo: queryName)
                .getDocuments()
            var events: [EventDetails] = []
            for document in querySnapshot.documents {
                if let apiResponse = try? document.data(as: EventDetails.self) {
                    apiResponse.id = document.documentID
                    events.append(apiResponse)
                }
            }
            // Cache the events
            cache.setEvents(events, forCategory: queryName)
            return events
        } catch {
            print("Error getting labeled events: \(error)")
        }
        return []
    }
    
    // MARK: - IsGoingEvent Related Methods
    
    func imGoing(_ userID: String, eventID: String) async throws -> Bool {
        do {
            let querySnapshot = try await db.collection("IsGoingEvent")
                .whereField("userID", isEqualTo: userID)
                .whereField("eventID", isEqualTo: eventID)
                .getDocuments()
            return !querySnapshot.isEmpty
        } catch {
            print("Error checking if user is going to event: \(error)")
            return false
        }
    }
    
    func userGoingEvents(_ userId: String) async -> [EventDetails] {
        do {
            var eventList: [EventDetails] = []
            let querySnapshot = try await db.collection("IsGoingEvent")
                .whereField("userID", isEqualTo: userId)
                .getDocuments()
            var events: [GoingEvent] = []
            
            for document in querySnapshot.documents {
                if let event = try? document.data(as: GoingEvent.self) {
                    events.append(event)
                    let goingEvent = try await db.collection("Events").document(event.eventID).getDocument(as: EventDetails.self)
                    goingEvent.id = document.documentID
                    eventList.append(goingEvent)
                }
            }
            // Optionally cache user-specific events
            return eventList
        } catch {
            print("Error getting documents: \(error)")
        }
        return []
    }
    
    func getGoingEvent(_ eventID: String) async -> [Hospede] {
        do {
            let querySnapshot = try await db.collection("IsGoingEvent")
                .whereField("eventID", isEqualTo: eventID)
                .getDocuments()
            var events: [GoingEvent] = []
            for document in querySnapshot.documents {
                if let event = try? document.data(as: GoingEvent.self) {
                    events.append(event)
                }
            }
            print("Number of events: ", events.count)
            var usersGoing: [Hospede] = []
            for going in events {
                let hospede = try await db.collection("Hospedes").document(going.userID).getDocument(as: Hospede.self)
                usersGoing.append(hospede)
            }
            // Optionally cache event attendees
            return usersGoing
        } catch {
            print("Error getting documents: \(error)")
        }
        return []
    }
    
    func createGoingEvent(_ userID: String, _ eventID: String) async {
        do {
            let newGoing = GoingEvent(eventID: eventID, userID: userID)
            try db.collection("IsGoingEvent").addDocument(from: newGoing)
            print("Going created")
            // Invalidate cache if necessary
        } catch {
            print("Erro em createGoingEvent: ", error.localizedDescription)
        }
    }
    
    func deleteGoingEvent(_ userID: String, _ eventID: String) async {
        do {
            let query = db.collection("IsGoingEvent")
                .whereField("eventID", isEqualTo: eventID)
                .whereField("userID", isEqualTo: userID)
            let querySnapshot = try await query.getDocuments()
            let document = querySnapshot.documents.first
            try await document?.reference.delete()
            print("Going deleted")
            // Invalidate cache if necessary
        } catch {
            print("Error deleting going event: ", error.localizedDescription)
        }
    }
    
    func removeGoingEvent(_ userID: String) async {
        let collectionRef = db.collection("IsGoingEvent")
        do {
            let querySnapshot = try await collectionRef
                .whereField("userID", isEqualTo: userID)
                .getDocuments()
            for document in querySnapshot.documents {
                try await collectionRef.document(document.documentID).delete()
                print("Successfully removed user from IsGoingEvent.")
            }
            // Invalidate cache if necessary
        } catch {
            print("Error removing user from IsGoingEvent: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Hospede Related Methods
    
    func deleteHospede(_ userID: String) async {
        let collectionRef = db.collection("Hospedes")
        do {
            try await collectionRef.document(userID).delete()
            print("Hospede profile deleted successfully")
            // Invalidate cache if necessary
        } catch {
            print("Error deleting hospede")
        }
    }
}
