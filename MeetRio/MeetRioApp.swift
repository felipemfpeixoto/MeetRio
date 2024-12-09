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
        let POSTHOG_API_KEY = "phc_l7FQ5jmKlfRzSx5p74D3UqzR7INxOIfXxEGfuS5n2uo"
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
//                ContentView(didStartSignUpFlow: $didStartSignUpFlow)
                Text("Ta tudo comentado")
            }
//            
//            .toast(isPresenting: $toastVariables.isOnAddCalendar, duration: 5){
//                AlertToast(displayMode: .banner(.slide), type: .systemImage("checkmark.circle.fill", .darkGreen), title: "Siri Request", subTitle: "Request sent to Siri to add event to Apple Calendar")
//            }
//            
//            .toast(isPresenting: $toastVariables.isOnAdd){
//                AlertToast(displayMode: .banner(.slide), type: .systemImage("checkmark.circle.fill", .backgroundWhite), title: "Event Saved", subTitle: "Your event has been saved in your events list", style: .style(backgroundColor: .darkGreen, titleColor: .backgroundWhite, subTitleColor: .backgroundWhite))
//            }
//            
//            .toast(isPresenting: $toastVariables.isOnRemove){
//                AlertToast(displayMode: .banner(.pop), type: .systemImage("trash.fill", .backgroundWhite), title: "Event Removed", subTitle: "Your event has been removed from your events list", style: .style(backgroundColor: .red, titleColor: .backgroundWhite, subTitleColor: .backgroundWhite))
//            }
            
//            .onChange(of: scenePhase) {
//                switch scenePhase {
//                case .background:
//                        do {
//                            try YourEventsModel.shared.save()
//                            
//                            if let hostel = UserManager.shared.hostel {
//                                let hostelCE = HostelCodableExtensions(hostel: hostel)
//                                try hostelCE.save()
//                            } else {
//                                print("Hostel ta vazio doidao")
//                            }
//                        } catch {
//                            print("🤬 ERRO AO TENTAR SALVAR O HOSTEL ou YourEventsModel: \(error.localizedDescription)")
//                        }
//                    break
//                case .inactive:
//                    if didStartSignUpFlow {
//                        Task {
//                            do {
//                                try await AuthenticationManager.shared.delete(false)
//                                print("Deletou usuario!")
//                            } catch {
//                                print("Se ferrou!", error)
//                            }
//                        }
//                    }
//                case .active:
//                    break
//                @unknown default:
//                    break
//                }
//            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
