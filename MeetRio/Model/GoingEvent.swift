//
//  GoingEvent.swift
//  MeetRio
//
//  Created by Felipe on 27/12/24.
//

import Foundation
import FirebaseFirestore

@Observable
class GoingEvent: Codable, CRUDItem {
    var id: String
    var eventID: String
    var userID: String
    
    /// Inicializador que cria uma instância do objeto e logo em seguida tenta criar esse record no BD
    init(eventID: String, userID: String, isNewGoingEvent: Bool = false) async throws {
        if isNewGoingEvent {
            self.id = UUID().uuidString
            self.eventID = eventID
            self.userID = userID
            
            try await self.create()
        } else {
            let querySnapshot = try await db.collection(String(describing: Self.self)).whereField("eventID", isEqualTo: eventID).whereField("userID", isEqualTo: userID).getDocuments()
            
            let document = querySnapshot.documents.first
                
            if let record = try? document!.data(as: GoingEvent.self) {
                self.id = record.id
                self.userID = record.userID
                self.eventID = record.eventID
                return
            }
            
            throw DBError.recordNotFound
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case _eventID = "eventID"
        case _userID = "userID"
    }
    
    init(id: String, eventID: String, userID: String) {
        self.id = id
        self.eventID = eventID
        self.userID = userID
    }
    
    // TODO: (1) Provavelmente essas funções não deveriam estar aqui
    static func getGoingEvent(_ eventID: String) async -> [Hospede] {
        do {
            let collectionName = String(describing: Self.self)
            let querySnapshot = try await db.collection(collectionName)
                .whereField("eventID", isEqualTo: eventID)
                .getDocuments()
            var events: [GoingEvent] = []
            
            for document in querySnapshot.documents {
                if let event = try? document.data(as: GoingEvent.self) {
                    events.append(event)
                }
            }
            
            var usersGoing: [Hospede] = []
            for going in events {
                let hospede = try await db.collection("Hospede").document(going.userID).getDocument(as: Hospede.self)
                usersGoing.append(hospede)
            }
            // Optionally cache event attendees
            return usersGoing
        } catch {
            print("Error getting documents: \(error)")
            // TODO: (1) Criar um erro customizado para termos mais logs customizados aqui
        }
        return []
    }
    
    /// - Returns: Valor booleano que indica se o record com o eventID e userID passados existe na DataBase
    static func getGoingEvent(eventID: String, userID: String) async throws -> Bool {
        let querySnapshot = try await db.collection("GoingEvent")
            .whereField("eventID", isEqualTo: eventID)
            .whereField("userID", isEqualTo: userID)
            .getDocuments()
        
        return !querySnapshot.documents.isEmpty
    }
    
    
    
    // TODO: (0) Não foi testada
    static func getAllUserGoingEvents(userID: String) async throws -> [EventDetails] {
        let querySnapshot = try await db.collection("GoingEvent").whereField("userID", isEqualTo: userID).getDocuments()
        
        var allEventIDs: [String] = []
        
        for document in querySnapshot.documents {
            if let goingEvent = try? document.data(as: GoingEvent.self) {
                allEventIDs.append(goingEvent.eventID)
            }
        }
        
        var allEvents: [EventDetails] = []
        
        for eventID in allEventIDs {
            let event = try await EventDetails(id: eventID)
            allEvents.append(event)
        }
        
        return allEvents
    }
    
    static private func getAllGoingEvents(userID: String) async throws -> [GoingEvent] {
        let querySnapshot = try await db.collection("GoingEvent").whereField("userID", isEqualTo: userID).getDocuments()
        
        var allGoingEvents: [GoingEvent] = []
        
        for document in querySnapshot.documents {
            if let goingEvent = try? document.data(as: GoingEvent.self) {
                allGoingEvents.append(goingEvent)
            }
        }
        
        return allGoingEvents
    }
    
    static func deleteAllGoing(for userID: String) async throws {
        let allGoing = try await Self.getAllGoingEvents(userID: userID)
        
        for goingEvent in allGoing {
            try await goingEvent.deleteItem()
        }
    }
}
