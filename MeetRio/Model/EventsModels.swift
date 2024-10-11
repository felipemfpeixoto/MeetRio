//
//  EventsModels.swift
//  MeetRio
//
//  Created by Felipe on 03/10/24.
//

import Foundation
import FirebaseFirestore

@Observable
class EventDetails: Identifiable, Codable, Comparable {
    // Propriedades
    var id: String?
    var name: String
    var address: AddressDetails
    var dateDetails: DateDetails?
    var description: String
    var photoURL: String?
    var buyURL: String?
    var otherPictureURLs: [String]?
    var tags: [String]
    var tips: [String]
    var safetyRate: Float?
    var eventCategory: String
    var dayWeek: String?
    
    // MARK: Vai sair
    var otherPictureData: [Data]?
    var photoData: Data?

    init(id: String?, tags: [String], tips: [String], safetyRate: Float?, eventCategory: String, dayWeek: String?, otherPictureURLs: [String]?, photoURL: String?, description: String, name: String, address: AddressDetails, dateDetails: DateDetails?, buyURL: String?) {
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
       self.dayWeek = dayWeek
    }
    
    // Definindo os CodingKeys para mapear os campos do JSON
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case _name = "name"
        case _address = "address"
        case _dateDetails = "dateDetails"
        case _description = "description"
        case _photoURL = "photoURL"
        case _buyURL = "buyURL"
        case _otherPictureURLs = "otherPictureURLs"
        case _tags = "tags"
        case _tips = "tips"
        case _safetyRate = "safetyRate"
        case _eventCategory = "eventCategory"
        case _dayWeek = "dayWeek"
        
        // Propriedades que vão sair (não mapeadas no JSON)
        case _otherPictureData
        case _photoData
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

    static func returnDayOfWeek(day: String) -> Int {
        let daysOfWeek: [String: Int] = [
            "Sunday": 1,
            "Monday": 2,
            "Tuesday": 3,
            "Wednesday": 4,
            "Thursday": 5,
            "Friday": 6,
            "Saturday": 7
        ]
        
        guard let targetWeekday = daysOfWeek[day.capitalized] else {
            print("Invalid day provided.")
            return 0
        }
        
        let calendar = Calendar.current
        let today = Date()
        
        let currentWeekday = calendar.component(.weekday, from: today)
        
        // Calcula quantos dias faltam até o próximo evento
        let daysUntilNext = (targetWeekday - currentWeekday + 7) % 7
        
        // Se daysUntilNext for 0, o evento é hoje, então retorna o dia de hoje
        let nextDate = calendar.date(byAdding: .day, value: daysUntilNext, to: today)!
        
        return calendar.component(.day, from: nextDate)
    }

    static func returnDayOfWeekDate(day: String) -> Date? {
        let daysOfWeek: [String: Int] = [
            "Sunday": 1,
            "Monday": 2,
            "Tuesday": 3,
            "Wednesday": 4,
            "Thursday": 5,
            "Friday": 6,
            "Saturday": 7
        ]
        
        guard let targetWeekday = daysOfWeek[day.capitalized] else {
            print("Invalid day provided.")
            return nil
        }
        
        let calendar = Calendar.current
        let today = Date()
        
        let currentWeekday = calendar.component(.weekday, from: today)
        
        // Calcula quantos dias faltam até o próximo evento
        let daysUntilNext = (targetWeekday - currentWeekday + 7) % 7
        
        // Se daysUntilNext for 0, o evento é hoje, então retorna a data de hoje
        let nextDate = calendar.date(byAdding: .day, value: daysUntilNext, to: today)!
        
        return nextDate
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
    func loadPhotoData() async -> Data? {
        guard let photoURLString = self.photoURL, let url = URL(string: photoURLString) else {
            return nil
        }
        // Start a data task to download the image
        let response = try? await URLSession.shared.data(from: url)
        return response?.0
    }
    
    //MARK: Protocolo comparable
    static func < (ant: EventDetails, prox: EventDetails) -> Bool {
        if ant.dateDetails != nil{
           let antDate = ant.dateDetails?.startDate ?? ""
           let proxDate = prox.dateDetails?.startDate ?? ""
            return antDate < proxDate
        }
        
        let antDate = returnDayOfWeek(day: ant.dayWeek ?? "")
        let proxDate = returnDayOfWeek(day: prox.dayWeek ?? "")
        return antDate < proxDate
        
    }
    
    static func == (lhs: EventDetails, rhs: EventDetails) -> Bool {
            return lhs.id == rhs.id
        }
    
    
    // MARK: Share event
    func shareEvent(completion: @escaping (Bool) -> Void) {
        let eventTitle = self.name
        let eventDate = self.dateDetails?.startDate ?? "Data não disponível"
        
        
        // Define o texto de compartilhamento dependendo do idioma
        var shareText: String
        shareText = "Check out this event I found on MeetRio: \(eventTitle) happening on \(eventDate). Don't miss it!"
        
        let eventURL = URL(string: self._buyURL ?? "")
        var itemsToShare: [Any] = [shareText]
        
        if let eventURL = eventURL {
            itemsToShare.append(eventURL)
        }
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}



typealias AllEvents = [EventDetails]
extension AllEvents {
    init() {
        self = []
    }
}
