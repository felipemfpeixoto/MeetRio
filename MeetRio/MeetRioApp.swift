//
//  MeetRioApp.swift
//  MeetRio
//
//  Created by Felipe on 30/07/24.
//

import SwiftUI
import Firebase
import PostHog
import Translation
import CodableExtensions
import AlertToast

@main
struct MeetRioApp: App {
    @Environment(\.scenePhase) var scenePhase

    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        let POSTHOG_API_KEY = "phc_zYzjZUSDIjfkKL23VB0zp2wUDTo194k7WHsfCkuDWaK"
        let POSTHOG_HOST = "https://us.i.posthog.com"
        
        let config = PostHogConfig(apiKey: POSTHOG_API_KEY, host: POSTHOG_HOST)
        PostHogSDK.shared.setup(config)
        #if DEBUG
        PostHogSDK.shared.identify("Testes", userProperties: ["environment": "debug"])
        #else
        PostHogSDK.shared.identify("Producao", userProperties: ["environment": "release"])
        #endif
    }
    
    @State var didStartSignUpFlow: Bool = false
    
    // Variáveis para teste de tradução
    @State var showsTranslation: Bool = false
    
    @State var toastVariables = ToastVariables.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(didStartSignUpFlow: $didStartSignUpFlow)
//                    .onAppear {
//                        let hostel = Hostel(
//                            name: "Social Hostel",
//                            description: "Located 1 block from Copacabana Beach and a 3-minute walk from Ipanema Beach, Social Hostel features beautiful classic interiors",
//                            contact: ContactDetails(
//                                phone: "+55 21 2513 2048"
//                            ),
//                            addressDetails: AddressDetails(
//                                street: "R. Francisco Otaviano",
//                                number: "56",
//                                neighborhood: "Copacabana",
//                                location: LocationDetails(latitude: -22.986128314561387, longitude: -43.19092783862311)
//                            ),
//                            services: [
//                                "Free Wifi",
//                                "Air Condidioner",
//                                "Modern Décor"
//                            ],
//                            imageURL: "*** SUBSTITUIR ***",
//                            events: [
//                                HostelEvent(
//                                    id: UUID().uuidString,
//                                    tags: [],
//                                    tips: [],
//                                    safetyRate: 5,
//                                    eventCategory: "Hostel Events",
//                                    dayWeek: nil,
//                                    otherPictureURLs: nil,
//                                    photoURL: "*** Substituir ***",
//                                    description: "*** Substituir ***",
//                                    name: "*** Substituir ***",
//                                    address: AddressDetails(
//                                        street: "Avenida dos Artistas",
//                                        number: "123",
//                                        neighborhood: "Centro",
//                                        location: LocationDetails(
//                                            latitude: -22.9068,
//                                            longitude: -43.1729,
//                                            mapURL: "https://maps.apple.com/?q=-22.9068,-43.1729"
//                                        ),
//                                        cep: "",
//                                        details: "Perto do Museu",
//                                        referencePoint: "Ao lado do parque"
//                                    ),
//                                    dateDetails: DateDetails(
//                                        startDate: "2024-12-14", // Now using String for the date
//                                        endDate: "2024-12-14",
//                                        startHour: "18:00", // Now using String for the hour
//                                        endHour: "22:00"
//                                    ),
//                                    buyURL: "*** Substituir ***",
//                                    hostelID: "bvKiWCn1HsejIPr3jCy9"
//                                ),
//                                HostelEvent(
//                                    id: UUID().uuidString,
//                                    tags: [],
//                                    tips: [],
//                                    safetyRate: 5,
//                                    eventCategory: "Hostel Events",
//                                    dayWeek: nil,
//                                    otherPictureURLs: nil,
//                                    photoURL: "*** Substituir ***",
//                                    description: "*** Substituir ***",
//                                    name: "*** Substituir ***",
//                                    address: AddressDetails(
//                                        street: "Avenida dos Artistas",
//                                        number: "123",
//                                        neighborhood: "Centro",
//                                        location: LocationDetails(
//                                            latitude: -22.9068,
//                                            longitude: -43.1729,
//                                            mapURL: "https://maps.apple.com/?q=-22.9068,-43.1729"
//                                        ),
//                                        cep: "",
//                                        details: "Perto do Museu",
//                                        referencePoint: "Ao lado do parque"
//                                    ),
//                                    dateDetails: DateDetails(
//                                        startDate: "2024-12-14", // Now using String for the date
//                                        endDate: "2024-12-14",
//                                        startHour: "18:00", // Now using String for the hour
//                                        endHour: "22:00"
//                                    ),
//                                    buyURL: "*** Substituir ***",
//                                    hostelID: "bvKiWCn1HsejIPr3jCy9"
//                                ),
//                                HostelEvent(
//                                    id: UUID().uuidString,
//                                    tags: [],
//                                    tips: [],
//                                    safetyRate: 5,
//                                    eventCategory: "Hostel Events",
//                                    dayWeek: nil,
//                                    otherPictureURLs: nil,
//                                    photoURL: "*** Substituir ***",
//                                    description: "*** Substituir ***",
//                                    name: "*** Substituir ***",
//                                    address: AddressDetails(
//                                        street: "Avenida dos Artistas",
//                                        number: "123",
//                                        neighborhood: "Centro",
//                                        location: LocationDetails(
//                                            latitude: -22.9068,
//                                            longitude: -43.1729,
//                                            mapURL: "https://maps.apple.com/?q=-22.9068,-43.1729"
//                                        ),
//                                        cep: "",
//                                        details: "Perto do Museu",
//                                        referencePoint: "Ao lado do parque"
//                                    ),
//                                    dateDetails: DateDetails(
//                                        startDate: "2024-12-14", // Now using String for the date
//                                        endDate: "2024-12-14",
//                                        startHour: "18:00", // Now using String for the hour
//                                        endHour: "22:00"
//                                    ),
//                                    buyURL: "*** Substituir ***",
//                                    hostelID: "bvKiWCn1HsejIPr3jCy9"
//                                )
//                            ]
//                        )
//                        Task {
//                            await hostel.uploadToFirestore()
//                        }
//                    }
                
            }
            
//            .toast(isPresenting: $toastVariables.isTranslated){
//                AlertToast(displayMode: .banner(.slide), type: .systemImage("translate", .backgroundWhite), title: "Translate Concluded", style: .style(backgroundColor: .darkGreen, titleColor: .backgroundWhite, subTitleColor: .backgroundWhite))
//            }
//            
//            .toast(isPresenting: $toastVariables.isOnTranslate){
//                AlertToast(displayMode: .banner(.pop), type: .loading, title: "Translate", subTitle: "Translate in progress")
//            }
            
            .toast(isPresenting: $toastVariables.isOnAddCalendar, duration: 5){
                AlertToast(displayMode: .banner(.slide), type: .systemImage("checkmark.circle.fill", .darkGreen), title: "Siri Request", subTitle: "Request sent to Siri to add event to Apple Calendar")
            }
            
            .toast(isPresenting: $toastVariables.isOnAdd){
                AlertToast(displayMode: .banner(.slide), type: .systemImage("checkmark.circle.fill", .backgroundWhite), title: "Event Saved", subTitle: "Your event has been saved in your events list", style: .style(backgroundColor: .darkGreen, titleColor: .backgroundWhite, subTitleColor: .backgroundWhite))
            }
            
            .toast(isPresenting: $toastVariables.isOnRemove){
                AlertToast(displayMode: .banner(.pop), type: .systemImage("trash.fill", .backgroundWhite), title: "Event Removed", subTitle: "Your event has been removed from your events list", style: .style(backgroundColor: .red, titleColor: .backgroundWhite, subTitleColor: .backgroundWhite))
            }
            
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .background:
                        do {
                            try YourEventsModel.shared.save()
                            
                            if let hostel = UserManager.shared.hostel {
                                let hostelCE = HostelCodableExtensions(hostel: hostel)
                                try hostelCE.save()
                            } else {
                                print("Hostel ta vazio doidao")
                            }
                        } catch {
                            print("🤬 ERRO AO TENTAR SALVAR O HOSTEL ou YourEventsModel: \(error.localizedDescription)")
                        }
                    break
                case .inactive:
                    if didStartSignUpFlow {
                        Task {
                            do {
                                try await AuthenticationManager.shared.delete(false)
                                print("Deletou usuario!")
                            } catch {
                                print("Se ferrou!", error)
                            }
                        }
                    }
                case .active:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
