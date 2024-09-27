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
    
    var allEvents: [EventDetails] = []
    
    var weekEvents: [Int: [EventDetails]] = [
        Calendar.current.component(.day, from: Date()) : [],
        Calendar.current.component(.day, from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!) : [],
        Calendar.current.component(.day, from: Calendar.current.date(byAdding: .day, value: 2, to: Date())!) : [],
        Calendar.current.component(.day, from: Calendar.current.date(byAdding: .day, value: 3, to: Date())!) : []
    ]
    
    func getAllEvents() async {
        do {
            let querySnapshot = try await db.collection("Events").getDocuments()
            for document in querySnapshot.documents {
                self.allEvents = []
                if let event = try? document.data(as: EventDetails.self) {
                    self.allEvents.append(event)
                }
            }
        } catch {
            print("Error getting documents 1: \(error)")
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
        
        do {
            let querySnapshot = try await db.collection("Events")
                .whereField("dateDetails.startDate", isGreaterThanOrEqualTo: startOfDay)
                .whereField("dateDetails.startDate", isLessThanOrEqualTo: endOfDay)
                .getDocuments()
            
            var events: [EventDetails] = []
            
            for document in querySnapshot.documents {
                if let event = try? document.data(as: EventDetails.self) {
                    events.append(event)
                }
            }
            return events
        } catch {
            print("Error getting documents 2: \(error)") // Handle the error in the future
        }
        return []
    }
    
    func getLabeledEvents(_ queryName: String) async -> [EventDetails] {
        do {
            let querySnapshot = try await db.collection("Events")
                .whereField("eventCategory", isEqualTo: "\(queryName)")
                .getDocuments()
            var events: [EventDetails] = []
            for document in querySnapshot.documents {
                if let event = try? document.data(as: EventDetails.self) {
                    events.append(event)
                }
            }
//            print("Quantidade eventos \(queryName): ", events.count)
            return events
        } catch {
            print("Error getting documents 3: \(error)") // Handle the error in the future
        }
        return []
    }
    
}

// MARK: Extension responsável pelos objetos de relação IsGoingEvent
extension FirestoreManager {
    
    func imGoing(_ userID: String, eventID: String) async throws -> Bool {
        do {
            // Consultando a coleção "IsGoingEvent" para verificar se o usuário está associado ao evento
            let querySnapshot = try await db.collection("IsGoingEvent")
                .whereField("userID", isEqualTo: userID)
                .whereField("eventID", isEqualTo: eventID)
                .getDocuments()
            
            // Se houver documentos retornados, isso significa que o usuário está indo ao evento
            return !querySnapshot.isEmpty
        } catch {
            print("Error checking if user is going to event: \(error)")
            return false
        }
    }

    func userGoingEvents(_ userId: String) async -> [EventDetails]{
        do {
            let querySnapshot = try await db.collection("IsGoingEvent")
                .whereField("userID", isEqualTo: "\(userId)")
                .getDocuments()
            var events: [GoingEvent] = []
            
            for document in querySnapshot.documents {
                if let event = try? document.data(as: GoingEvent.self) {
                    events.append(event)
                }
            }
            print("qtd events: ", events.count)
            var eventList: [EventDetails] = []
            for going in events {
                let event = try await FirestoreManager.shared.db.collection("Events").document(going.eventID).getDocument(as: EventDetails.self)
                eventList.append(event)
            }
            return eventList

        } catch {
            print("Error getting documents 4: \(error)") // Handle the error in the future
        }
        return []
    }
    
    func getGoingEvent(_ eventID: String) async -> [Hospede] {
        do {
            print("eventID: \(eventID)")
            let querySnapshot = try await db.collection("IsGoingEvent")
                .whereField("eventID", isEqualTo: "\(eventID)")
                .getDocuments()
            var events: [GoingEvent] = []
            print("Passou")
            for document in querySnapshot.documents {
                if let event = try? document.data(as: GoingEvent.self) {
                    events.append(event)
                }
            }
            print("qtd events: ", events.count)
            var usersGoing: [Hospede] = []
            for going in events {
                print("Passou 2")
                let hospede = try await FirestoreManager.shared.db.collection("Hospedes").document(going.userID).getDocument(as: Hospede.self)
                print("Passou 3")
                usersGoing.append(hospede)
            }
            return usersGoing

        } catch {
            print("Error getting documents 5: \(error)") // Handle the error in the future
        }
        return []
    }
    
    func createGoingEvent(_ userID: String, _ eventID: String) async {
        do {
            let newGoing = GoingEvent(eventID: eventID, userID: userID)
            try self.db.collection("IsGoingEvent").addDocument(from: newGoing)
            print("Going created")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteGoingEvent(_ userID: String, _ eventID: String) async {
        do {
            let newGoing = GoingEvent(eventID: eventID, userID: userID)
            let query = try self.db.collection("IsGoingEvent").whereField("eventID", isEqualTo: eventID).whereField("userID", isEqualTo: userID)
            let querySnapshot = try await query.getDocuments()
            let document = querySnapshot.documents.first
            try await document?.reference.delete()
            print("Going deleted")
        } catch {
            print("Deu erro ao deletar goind: ", error.localizedDescription)
        }
    }
    
    func removeGoingEvent(_ userID: String) async {
        let collectionRef = db.collection("IsGoingEvent")

        do {
            // Procura por documentos onde userID e eventID correspondem
            let querySnapshot = try await collectionRef
                .whereField("userID", isEqualTo: userID)
                .getDocuments()
            
            // Itera sobre os documentos encontrados e remove cada um
            for document in querySnapshot.documents {
                try await collectionRef.document(document.documentID).delete()
                print("Successfully removed user from IsGoingEvent.")
            }
        } catch {
            print("Error removing user from IsGoingEvent: \(error.localizedDescription)")
        }
    }
}

extension FirestoreManager {
    
    func deleteHospede(_ userID: String) async {
        let collectionRef = db.collection("Hospedes")
        
        do {
            try await collectionRef.document(userID).delete()
            print("Perfil de Hospede deletado com sucesso")
        } catch {
            print("Error deleting hospede")
        }
    }
    
}
