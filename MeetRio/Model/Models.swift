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

class EventDetails: Codable, Identifiable {
    @DocumentID var id: String?
    
    // Basic Information
    var name: String
    var address: AddressDetails
    var dateDetails: DateDetails?
    var description: String
    var photoURL: String? // URL of the main image
    var photoData: Data?
    
    // Extra Information
    var dayWeek: String?
    var buyURL: String?
    var otherPictureURLs: [String]? // URLs of other images
    var otherPictureData: [Data]?// Data of other images
    var tags: [String]
    var tips: [String]
    var safetyRate: Float?
    var eventCategory: String
    
    // Initializer
    init(id: String?, name: String, address: AddressDetails, dateDetails: DateDetails, description: String, photoURL: String?, buyURL: String?, otherPictureURLs: [String], tags: [String], tips: [String], safetyRate: Float?, eventCategory: String) {
        self.id = id
        self.name = name
        self.address = address
        self.dateDetails = dateDetails
        self.description = description
        self.photoURL = photoURL
        self.buyURL = buyURL
        self.otherPictureURLs = otherPictureURLs
        self.tags = tags
        self.tips = tips
        self.safetyRate = safetyRate
        self.eventCategory = eventCategory
    }
    
    func formattedDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE" // Formato para 3 letras do dia da semana
        return dateFormatter.string(from: dateDetails?.startDateTime ?? Date())
    }
    
    func formattedDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d" // Formato para retornar apenas o dia do mês (1, 2, 15, etc.)
        return dateFormatter.string(from: dateDetails?.startDateTime ?? Date())
    }
    
    func formattedHour(from hourString: String) -> String {
        // Tenta dividir a string no formato "HH:mm" para obter a hora
        let components = hourString.split(separator: ":")
        
        // Garantir que haja ao menos uma parte válida para a hora
        guard let hourComponent = components.first, let hour = Int(hourComponent) else {
            return hourString // Se a string não for válida, retorna como está
        }

        // Verificar se é AM ou PM
        let isPM = hour >= 12
        let formattedHour = hour % 12 == 0 ? 12 : hour % 12 // Converte 0 ou 12 para 12, e outras horas para formato 12h
        let suffix = isPM ? "PM" : "AM"
        
        // Retornar a hora formatada
        return String(format: "%02d%@", formattedHour, suffix) // Formata com dois dígitos
    }

    
    func mergeData(date: Date, withHour hourString: String) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current // Define o fuso horário

        // Separa os componentes de data (dia, mês, ano) da `date`
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)

        // Divide a string "HH:mm" para obter a hora e o minuto
        let timeComponents = hourString.split(separator: ":")
        
        // Tenta extrair a hora e os minutos
        guard let hourComponent = timeComponents.first,
              let hour = Int(hourComponent),
              let minuteComponent = timeComponents.last,
              let minute = Int(minuteComponent) else {
            return date // Se a string for inválida, retorna a data original
        }

        // Adiciona a hora e o minuto extraídos da string aos componentes de data
        dateComponents.hour = hour
        dateComponents.minute = minute

        // Combina os componentes para criar uma nova `Date`
        return calendar.date(from: dateComponents) ?? date
    }

    
    // MARK: - Image Loading Methods
    
    // Load main photo data from URL
    func loadPhotoData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let photoURLString = self.photoURL, let url = URL(string: photoURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        print(photoURL)
        // Start a data task to download the image
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                self.photoData = data
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
            }
        }.resume()
    }
    
    // Load other pictures data from URLs
    func loadOtherPicturesData(completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        var tempDataArray: [Data] = []
        var encounteredError: Error?
        
        guard let otherPictureURLs else {
            return
        }
        for pictureURLString in otherPictureURLs {
            if let url = URL(string: pictureURLString) {
                group.enter()
                URLSession.shared.dataTask(with: url) { data, response, error in
                    defer { group.leave() }
                    
                    if let error = error {
                        encounteredError = error
                    } else if let data = data {
                        tempDataArray.append(data)
                    }
                }.resume()
            }
        }
        
        group.notify(queue: .main) {
            if let error = encounteredError {
                completion(.failure(error))
            } else {
                self.otherPictureData = tempDataArray
                completion(.success(()))
            }
        }
    }
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
    var cep: String
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

