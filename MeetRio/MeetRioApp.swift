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

@main
struct MeetRioApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    @State var userHostel: UserHostel = (try? UserHostel.load()) ?? UserHostel()

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

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(didStartSignUpFlow: $didStartSignUpFlow)
                    .environment(userHostel)
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .background:
                        do {
                            try userHostel.save()
                        } catch {
                            print("🤬 ERRO AO TENTAR SALVAR O HOSTEL")
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
