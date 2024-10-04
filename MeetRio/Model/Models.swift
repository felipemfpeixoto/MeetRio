//
//  Models.swift
//  MeetRio
//
//  Created by Felipe on 30/07/24.
//

import Foundation
import FirebaseFirestore

enum EventCategory: String, Codable {
    case bemBrazil, nightLife
}

// Objetos
struct Hospede: Codable {
    @DocumentID var id: String?
    var name: String
    var country: CountryDetails
    var picture: Data?
    var hostel: Hostel?
}

struct Hostel: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var password: String
    var location: LocationDetails
}


struct DateDetails: Codable {
    var startDate: String // Date as a string from Firestore
    var endDate: String
    var startHour: String // Time as a string from Firestore
    var endHour: String
    
    // Computed properties to get Date objects
    var startDateTime: Date? {
        return DateDetails.combineDateAndTime(dateString: startDate, timeString: startHour)
    }
    
    var endDateTime: Date? {
        return DateDetails.combineDateAndTime(dateString: endDate, timeString: endHour)
    }
    
    static func combineDateAndTime(dateString: String, timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        let sanitizedDateString = dateString.replacingOccurrences(of: ".", with: "")
        
        dateFormatter.dateFormat = "dd 'de' MMM 'de' yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        
        let combinedString = "\(sanitizedDateString) \(timeString)"
//        print("Combined string: \(combinedString)")
        
        if let date = dateFormatter.date(from: combinedString) {
            return date
        } else {
            print("Failed to parse date from string: \(combinedString)")
            return nil
        }
    }

}


struct AddressDetails: Codable {
    var street: String
    var number: String
    var neighborhood: String
    var location: LocationDetails
    var cep: String?
    var details: String?
    var referencePoint: String?
}

struct LocationDetails: Codable {
    var latitude: Double
    var longitude: Double
    var mapURL: String?
}

// Relações
struct FavoriteEvent: Codable {
    var userID: String
    var eventID: String
}

struct GoingEvent: Codable {
    @DocumentID var id: String?
    var eventID: String
    var userID: String
}

struct RecomendedEvent: Codable {
    var hostelID: String
    var eventID: String
}

// Componentes
struct CountryDetails: Codable {
    var name: String
    var flag: String
}

//struct DateDetails: Codable { // TODO: Vamos precisar mexer em algum momento (não sabemos qual)
//    var startDate: Date
//    var endDate: Date
//    var isRecurring: Bool
//    var recurrenceType: RecurrenceType?
//    var specificDays: [SpecificDay]?
//    
//    enum RecurrenceType: Codable, Hashable {
//        case daily
//        case weekly([Weekday])
//        case monthly([Int]) // Dias específicos do mês (ex: 1, 15, 30)
//    }
//    
//    struct SpecificDay: Codable {
//        var date: Date
//        var startTime: Date
//        var endTime: Date
//    }
//    
//    enum Weekday: String, CaseIterable, Codable {
//        case sunday = "Sunday"
//        case monday = "Monday"
//        case tuesday = "Tuesday"
//        case wednesday = "Wednesday"
//        case thursday = "Thursday"
//        case friday = "Friday"
//        case saturday = "Saturday"
//    }
//    
//    // Verifica se o evento é um evento único
//    var isSingleEvent: Bool {
//        return !isRecurring && specificDays == nil
//    }
//    
//    // Verifica se o evento acontece em uma data específica
//    func occursOn(date: Date) -> Bool {
//        if let specificDays = specificDays {
//            return specificDays.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
//        }
//        
//        guard isRecurring, let recurrenceType = recurrenceType else {
//            return Calendar.current.isDate(date, inSameDayAs: startDate)
//        }
//        
//        switch recurrenceType {
//        case .daily:
//            return date >= startDate && date <= endDate
//        case .weekly(let weekdays):
//            let weekday = Calendar.current.component(.weekday, from: date)
//            return weekdays.contains(Weekday(rawValue: Calendar.current.weekdaySymbols[weekday - 1])!)
//        case .monthly(let days):
//            let day = Calendar.current.component(.day, from: date)
//            return days.contains(day)
//        }
//    }
//    
//    // Descrição textual das ocorrências
//    func recurrenceDescription() -> String {
//        if isSingleEvent {
//            return "Single event on \(formattedDate(startDate))"
//        }
//        
//        if let specificDays = specificDays {
//            let dates = specificDays.map { formattedDate($0.date) }
//            return "Event on specific days: \(dates.joined(separator: ", "))"
//        }
//        
//        guard isRecurring, let recurrenceType = recurrenceType else {
//            return "Event on \(formattedDate(startDate))"
//        }
//        
//        switch recurrenceType {
//        case .daily:
//            return "Daily event from \(formattedDate(startDate)) to \(formattedDate(endDate))"
//        case .weekly(let weekdays):
//            let days = weekdays.map { $0.rawValue }
//            return "Weekly event on \(days.joined(separator: ", "))"
//        case .monthly(let days):
//            let daysString = days.map { "\($0)" }
//            return "Monthly event on day(s): \(daysString.joined(separator: ", "))"
//        }
//    }
//    
//    // Formatação da data para exibição
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        return formatter.string(from: date)
//    }
//}





// MARK: Mudanças posteriores à criação inicial
struct RateEvent: Codable {
    @DocumentID var id: String?
    var userID: String
    var eventID: String
    var userReview: Review
}

struct Review: Codable, Hashable {
    var rate: Float
    var date: Date
    var description: String
}

struct AttendingEvent: Codable {
    var userID: String
    var eventID: String
}

