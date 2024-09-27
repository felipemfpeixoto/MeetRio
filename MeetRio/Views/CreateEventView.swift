//import SwiftUI
//
//struct CreateEventView: View {
//    
//    @StateObject private var locationManager = LocationManager()
//    
//    let fsManager: FirestoreManager
//    
//    @Binding var isShowingSelf: Bool
//    
//    @State var newEvent = EventDetails(
//        name: "",
//        photo: nil, 
//        description: "",
//        dateDetails: "",
//        address: AddressDetails(street: "", number: "", neighborhood: ""),
//        location: LocationDetails(latitude: 0, longitude: 0),
//        safetyRate: 0.0,
//        tips: "",
//        url: ""
//    )
//    
//    @State private var isImagePickerPresented = false
//    @State private var selectedImage: UIImage?
//    
//    // State variables for recurrence
//    @State private var isRecurring: Bool = false
//    @State private var recurrenceType: DateDetails.RecurrenceType = .daily
//    @State private var selectedWeekdays: [DateDetails.Weekday] = []
//    @State private var selectedDaysOfMonth: [Int] = []
//    
//    // State variables for specific start and end time
//    @State private var startTime: Date = Date()
//    @State private var endTime: Date = Date().addingTimeInterval(3600) // 1 hour later by default
//    
//    @State var isToggled = false
//    
//    var body: some View {
//        ZStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                    // Campo para o nome do evento
//                    TextField("Event Name", text: $newEvent.name)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal)
//                    
//                    // Campo para a data de início do evento
//                    DatePicker("Event Start Date", selection: $newEvent.dateDetails.startDate, displayedComponents: .date)
//                        .padding(.horizontal)
//                    
//                    // Campo para a data de término do evento
//                    DatePicker("Event End Date", selection: $newEvent.dateDetails.endDate, displayedComponents: .date)
//                        .padding(.horizontal)
//                    
//                    // Campo para o horário de início do evento
//                    DatePicker("Event Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
//                        .padding(.horizontal)
//                    
//                    // Campo para o horário de término do evento
//                    DatePicker("Event End Time", selection: $endTime, displayedComponents: .hourAndMinute)
//                        .padding(.horizontal)
//                    
//                    // Seletor para recorrência
//                    Toggle("Is Recurring?", isOn: $isRecurring)
//                        .padding(.horizontal)
//                        .onChange(of: isRecurring) { value in
//                            newEvent.dateDetails.isRecurring = value
//                        }
//                    
//                    if isRecurring {
//                        Picker("Recurrence Type", selection: $recurrenceType) {
//                            Text("Daily").tag(DateDetails.RecurrenceType.daily)
//                            Text("Weekly").tag(DateDetails.RecurrenceType.weekly([]))
//                            Text("Monthly").tag(DateDetails.RecurrenceType.monthly([]))
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                        .padding(.horizontal)
//                        .onChange(of: recurrenceType) { value in
//                            newEvent.dateDetails.recurrenceType = value
//                        }
//                        
//                        if case .weekly = recurrenceType {
//                            MultiSelectPicker(title: "Select Weekdays", items: DateDetails.Weekday.allCases, selectedItems: $selectedWeekdays)
//                                .padding(.horizontal)
//                                .onChange(of: selectedWeekdays) { value in
//                                    newEvent.dateDetails.recurrenceType = .weekly(value)
//                                }
//                        }
//                        
//                        if case .monthly = recurrenceType {
//                            MultiSelectPicker(title: "Select Days of Month", items: Array(1...31), selectedItems: $selectedDaysOfMonth)
//                                .padding(.horizontal)
//                                .onChange(of: selectedDaysOfMonth) { value in
//                                    newEvent.dateDetails.recurrenceType = .monthly(value)
//                                }
//                        }
//                    }
//                    
//                    // Campos para endereço
//                    TextField("Street", text: $newEvent.address.street)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal)
//                    
//                    TextField("Number", text: $newEvent.address.number)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal)
//                    
//                    TextField("Neighborhood", text: $newEvent.address.neighborhood)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal)
//                    
//                    TextField("Postal Code", text: $newEvent.address.postalCode)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal)
//                    
//                    imagePickerButton
//                    
//                    Spacer()
//                    Button("Get Coordinates") {
//                        locationManager.getCoordinates(for: "\(newEvent.address.street) \(newEvent.address.number)")
//                    }
//                    .padding()
//                    
//                    if let latitude = locationManager.latitude, let longitude = locationManager.longitude {
//                        Text("Latitude: \(latitude)")
//                        Text("Longitude: \(longitude)")
//                    } else {
//                        Text("Coordinates will appear here.")
//                    }
//                    
//                    // O Toggle que altera a variável booleana
//                    Toggle("Evento Bem Brazil", isOn: $isToggled)
//                        .padding()
//                        .toggleStyle(SwitchToggleStyle()) // Estilo do Toggle como um switch
//                    
//                    // Botão para criar o evento
//                    Button(action: {
//                        newEvent.location.latitude = locationManager.latitude ?? 0.0
//                        newEvent.location.longitude = locationManager.longitude ?? 0.0
//                        newEvent.dateDetails.startDate = combine(date: newEvent.dateDetails.startDate, time: startTime)
//                        newEvent.dateDetails.endDate = combine(date: newEvent.dateDetails.endDate, time: endTime)
//                        newEvent.photo = selectedImage != nil ? selectedImage?.pngData() : Data()
//                        newEvent.eventCategory = isToggled ? EventCategory.bemBrazil.rawValue : EventCategory.nightLife.rawValue
//                        createEvent(newEvent: newEvent)
//                    }, label: {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 14)
//                                .foregroundStyle(.blue)
//                            Text("Create Event")
//                                .foregroundStyle(.white)
//                                .font(.system(size: 22).weight(.bold))
//                        }
//                    })
//                    .frame(height: 43)
//                    .padding(.horizontal)
//                }
//                .padding()
//            }
//        }
//        .sheet(isPresented: $isImagePickerPresented) {
//            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
//        }
//    }
//    
//    var imagePickerButton: some View {
//            Button {
//                isImagePickerPresented.toggle()
//            } label: {
//                if selectedImage == nil {
//                    ZStack {
//                        Circle()
//                            .frame(width: 100)
//                            .foregroundColor(.white)
//                        Image(systemName: "photo.badge.plus")
//                            .font(.largeTitle)
//                            .foregroundStyle(.black)
//                    }
//                } else {
//                    Image(uiImage: selectedImage ?? UIImage(systemName: "photo")!)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 100, height: 100)
//                        .clipShape(Circle())
//                        .shadow(color: .black.opacity(0.5), radius: 2.5, y: 4)
//                }
//            }.padding()
//        }
//    
//    func createEvent(newEvent: EventDetails) {
//        do {
//            try fsManager.db.collection("Events").addDocument(from: newEvent)
//            isShowingSelf.toggle()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    // Helper function to combine date and time into a single Date
//    func combine(date: Date, time: Date) -> Date {
//        let calendar = Calendar.current
//        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
//        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
//        return calendar.date(byAdding: timeComponents, to: calendar.date(from: dateComponents)!)!
//    }
//}
//
//// Custom Picker for Multiple Selection
//struct MultiSelectPicker<Item: Hashable>: View {
//    let title: String
//    let items: [Item]
//    @Binding var selectedItems: [Item]
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(title)
//            ForEach(items, id: \.self) { item in
//                HStack {
//                    Text("\(item)")
//                    Spacer()
//                    if selectedItems.contains(item) {
//                        Image(systemName: "checkmark")
//                            .foregroundColor(.blue)
//                    }
//                }
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    if let index = selectedItems.firstIndex(of: item) {
//                        selectedItems.remove(at: index)
//                    } else {
//                        selectedItems.append(item)
//                    }
//                }
//            }
//        }
//    }
//}
//
//extension DateDetails.Weekday: Identifiable {
//    var id: Self { self }
//}
//
//extension Int: Identifiable {
//    public var id: Int { self }
//}
//
//#Preview {
//    CreateEventView(fsManager: FirestoreManager.shared, isShowingSelf: .constant(true))
//}
