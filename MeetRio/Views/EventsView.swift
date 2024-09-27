//
//  EventsView.swift
//  MeetRio
//
//  Created by Felipe on 09/08/24.
//

import SwiftUI

//TODO: Integracao com o BD
struct EventsView: View {
    
    let fsManager: FirestoreManager
    
    @Binding var selectedScreen: SelectedScreen
    
    @Binding var isAuthenticated: Bool
    
    @Binding var loggedCase: LoginCase
    
    let calendar = Calendar.current
    @State var startOfToday: Date?
    
    @State var isShowingCreate = false
    
    // TESTANDO COM 17 DIAS A MAIS!!!!!!!!
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    
    @State var isShowingPopOver = false
    
    @State private var specificDayEvents: [EventDetails]?
    
    @State var isBetween: Bool = true
    
    @State var selectedFavorite: EventDetails? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                    .ignoresSafeArea()
                ZStack {
                    VStack {
                        HStack {
                            Text("\(getWeekdayForDayOfMonth2(day: selectedDay))  ,\(selectedDay)")
                                .font(.title.bold())
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        calendarButtons
                            .offset(y: -60)
                        if isBetween {
                            eventsContainer
                        } else {
                            eventsSelectedDate
                        }
                        
                        Button(action: {
                            isShowingCreate.toggle()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .foregroundStyle(.blue)
                                Text("Create New Event")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 22).weight(.bold))
                            }
                        })
                        .frame(height: 43)
                    }
                    .padding()
                    VStack {
                        Spacer()
                        if selectedFavorite != nil {
                            AddedToFavoriteCard(eventImage: ((selectedFavorite?.photo) ?? UIImage(named: "defaultImage")?.pngData())!, selectedScreen: $selectedScreen)
                                .padding()
                                .task {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        withAnimation(Animation.easeInOut(duration: 0.5)) {
                                            selectedFavorite = nil
                                        }
                                    }
                                }
                        }
                    }
                }
                .padding()
            }
            
            .sheet(isPresented: $isShowingCreate, content: {
//                CreateEventView(fsManager: fsManager, isShowingSelf: $isShowingCreate)
            })
            .onAppear {
                startOfToday = calendar.startOfDay(for: Date())
            }
            .onChange(of: selectedDate) {
                isBetween = isDateBetween(selectedDate, between: startOfToday ?? Date(), and: calendar.date(byAdding: .day, value: 3, to: Date())!)
                if isBetween {
                    selectedDay = calendar.component(.day, from: selectedDate) - calendar.component(.day, from: Date())
                }
            }
        }
    }
    
    var background: some View {
        VStack {
            Image("calendarImage")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 5)
            Spacer()
        }
    }
    
    var calendarButtons: some View {
        HStack {
            ForEach(sortDays(days: Array(fsManager.weekEvents.keys.sorted()), startDay: calendar.component(.day, from: Date())), id: \.self) { day in
                Button(action: {
                    selectedDay = day
                    selectedDate = Calendar.current.startOfDay(for: Date())
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(!isBetween ? .white : (selectedDay == day ? .marcaTexto : .white))
                            .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                        VStack(spacing: 0) {
                            Circle()
                                .foregroundStyle(.black)
                                .frame(width: 6, height: 6)
                            VStack(spacing: -5) {
                                Text("\(getWeekdayForDayOfMonth(day: day))")
                                    .foregroundStyle(.black)
                                    .fontWeight(.light)
                                Text("\(day)")
                                    .foregroundStyle(.black)
                                    .font(.title2.weight(.medium))
                            }
                        }
                    }
                }
                .frame(width: 67, height: 67)
            }
            
            // Put your own design here
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(!isBetween ? .marcaTexto : .white)
                    .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
                Image(systemName: "calendar")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
            }
            .frame(width: 67, height: 67)
            // Put the actual DataPicker here with overlay
            .overlay {
                DatePicker(selection: $selectedDate, displayedComponents: .date) {}
                    .labelsHidden()
                    .contentShape(Rectangle())
                    .opacity(0.011)             // <<< here
            }
        }
        .padding(.top, (UIScreen.main.bounds.height / 5) - 101)
        
        
    }
    
    var eventsContainer: some View {
        ZStack {
            // ForEach vertical para os eventos do dia selecionado
            if let events = fsManager.weekEvents[selectedDay] {
                ScrollView {
                    VStack(spacing: 25) {
                        ForEach(events, id:\.self.id) { event in
                            NavigationLink(destination: NewEventPageView(loggedCase: $loggedCase, event: event)) {
                                EventCard(event: event, selected: $selectedFavorite)
                                    
                            } 
                        }
                    }
                }
            }
        }
    }
    
    var eventsSelectedDate: some View {
        ZStack {
            ScrollView {
                if let events = specificDayEvents {
                    VStack(spacing: 16) {
                        if events.count > 0 {
                            ForEach(events, id:\.self.id) { event in
                                NavigationLink(destination: NewEventPageView(loggedCase: $loggedCase, event: event)) {
                                    EventCard(event: event, selected: $selectedFavorite)
                                }
                            }
                        } else {
                            Text("Ta vazio doidao")
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .onAppear {
                Task {
                    specificDayEvents = await fsManager.getSpecificDayEvent(selectedDate: selectedDate)
                }
            }
        }
    }
    
    // Função para converter dia do mês em dia da semana
    func getWeekdayForDayOfMonth(day: Int) -> String {
        let todaysDay = calendar.component(.day, from: Date())
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        var month: Int {
            if todaysDay - day > 10 {
                return calendar.component(.month, from: calendar.date(byAdding: .month, value: 1, to: Date())!)
            }
            return calendar.component(.month, from: Date())
        }
        var components = DateComponents(year: year, month: month, day: day)
        guard let date = calendar.date(from: components) else {
            return "Date not found"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" // "E" for the weekday abbreviation
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // English locale
        return dateFormatter.string(from: date)
    }
    
    // Repliquei e "refiz" a funcao, bagulho feio mas funciona
    // Troquei o "E" por "EEEE"
    func getWeekdayForDayOfMonth2(day: Int) -> String {
        let todaysDay = calendar.component(.day, from: Date())
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        var month: Int {
            if todaysDay - day > 10 {
                return calendar.component(.month, from: calendar.date(byAdding: .month, value: 1, to: Date())!)
            }
            return calendar.component(.month, from: Date())
        }
        var components = DateComponents(year: year, month: month, day: day)
        guard let date = calendar.date(from: components) else {
            return "Date not found"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // "E" for the weekday abbreviation
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // English locale
        return dateFormatter.string(from: date)
    }

    func isDateBetween(_ date: Date, between startDate: Date, and endDate: Date) -> Bool {
        return date >= startDate && date <= endDate
    }


    static func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    // Função para ordenar corretamente
    func sortDays(days: [Int], startDay: Int) -> [Int] {
        let daysBeforeStart = days.filter { $0 >= startDay }
        let daysAfterStart = days.filter { $0 < startDay }

        let sortedDaysBeforeStart = daysBeforeStart.sorted()
        let sortedDaysAfterStart = daysAfterStart.sorted()

        return sortedDaysBeforeStart + sortedDaysAfterStart
    }
}

struct DatePickerButton: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    showDatePicker.toggle()
                } label: {
                    Image(systemName: "calendar.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.trailing)
                }
            }
            
         Spacer()
        }
    }
}

#Preview {
    EventsView(fsManager: FirestoreManager.shared, selectedScreen: .constant(.calendar), isAuthenticated: .constant(true), loggedCase: .constant(.registered))
}
