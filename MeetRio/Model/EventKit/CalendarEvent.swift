//
//  CalendarEvent.swift
//  MeetRio
//
//  Created by Felipe on 27/09/24.
//

import Foundation
import EventKit
import Intents
import Contacts

// Struct para representar um evento de calendário
class CalendarEvent {
    let name: String
    let startDate: Date
    let endDate: Date
    let locationName: String
    let latitude: Double
    let longitude: Double
    let street: String
    let city: String
    let state: String
    let postalCode: String
    let country: String
    let isoCountryCode: String
    
    private var reservation: INReservation?
    private var event: INTicketedEvent?
    
    static var eventCount: [String: Int] = [:]{
        didSet{
            saveEventCount()
        }
    }
    
    init(name: String, startDate: Date, endDate: Date, locationName: String, latitude: Double, longitude: Double, street: String, city: String, state: String, postalCode: String, country: String, isoCountryCode: String) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.street = street
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
        self.isoCountryCode = isoCountryCode
        CalendarEvent.loadEventCount()
    }

    func reciveAndDonateInteraction(eventData: CalendarEvent) {
        reciveInteraction(eventData: eventData)
        donateInteraction()
    }
    
    // Função que recebe os dados do evento e faz a doação da interação
    func reciveInteraction(eventData: CalendarEvent) {
        reservation = nil
        event = nil
        
        let eventName = getUniqueEventName(for: eventData.name)
        print(eventName)
        
        let calendar = Calendar.current
        let myEventStart = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: eventData.startDate)
        let myEventEnd = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: eventData.endDate)
        
        let duration = INDateComponentsRange(start: myEventStart, end: myEventEnd)
        
        let myCLLocation = CLLocation(latitude: eventData.latitude, longitude: eventData.longitude)
        let myAddress = CNMutablePostalAddress()
        myAddress.street = eventData.street
        myAddress.city = eventData.city
        myAddress.state = eventData.state
        myAddress.postalCode = eventData.postalCode
        myAddress.country = eventData.country
        myAddress.isoCountryCode = eventData.isoCountryCode
        
        let location = CLPlacemark(location: myCLLocation, name: eventData.locationName, postalAddress: myAddress)
        
        event = INTicketedEvent(category: .unknown, name: eventName, eventDuration: duration, location: location)
        
        let reservationReference = INSpeakableString(vocabularyIdentifier: UUID().uuidString, spokenPhrase: eventData.name, pronunciationHint: nil)
        
        reservation = INTicketedEventReservation(itemReference: reservationReference, reservationNumber: nil, bookingTime: nil, reservationStatus: .confirmed, reservationHolderName: nil, actions: nil, reservedSeat: nil, event: event!)
    }
    
    // Função que retorna um nome de evento único com base no número de vezes que ele foi registrado
    private func getUniqueEventName(for eventName: String) -> String {
            
        if let count = CalendarEvent.eventCount[eventName] {
            
                let newCount = count + 1
                CalendarEvent.eventCount[eventName] = newCount
                return "\(eventName) (\(newCount))"
            } else {
                
                CalendarEvent.eventCount[eventName] = 0
                return eventName
            }
        }
    
    // Função para doar a interação para o sistema
    private func donateInteraction() {
        guard let reservation = reservation else { return }
        
        let intent = INGetReservationDetailsIntent(reservationContainerReference: reservation.itemReference, reservationItemReferences: nil)
        
        let intentResponse = INGetReservationDetailsIntentResponse(code: .success, userActivity: nil)
        intentResponse.reservations = [reservation]
        
        let interaction = INInteraction(intent: intent, response: intentResponse)
        
        interaction.donate { error in
            if let error = error {
                print("Erro ao doar a interação: \(error.localizedDescription)")
            } else {
                print("Interação doada com sucesso.")
            }
        }
    }
    
    // Função para salvar o dicionário eventCount no UserDefaults
    static private func saveEventCount() {
        UserDefaults.standard.set(eventCount, forKey: "eventCount")
    }

    // Função para carregar o dicionário eventCount do UserDefaults
    static private func loadEventCount() {
        if let savedEventCount = UserDefaults.standard.dictionary(forKey: "eventCount") as? [String: Int] {
            eventCount = savedEventCount
        }
    }
}
