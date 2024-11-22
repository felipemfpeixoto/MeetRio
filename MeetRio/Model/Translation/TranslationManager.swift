//
//  TranslationManager.swift
//  MeetRio
//
//  Created by Felipe on 26/09/24.
//
import SwiftUI
import Foundation
import Translation

@available(iOS 18.0, *)
@Observable
final class TranslationManager {
    var configuration: TranslationSession.Configuration?
    
    var translatedTexts: [String?] = [nil, nil]
    
    var languageAvailable: LanguageAvailability.Status {
        get async {
            return await checkLanguageAvailability()
        }
    }
    
    func translateAllAtOnce(using session: TranslationSession, isShowing: Binding<Bool>) async {
        Task { @MainActor in
            ToastVariables.shared.isOnTranslate = true
            let requests: [TranslationSession.Request] = translatedTexts.map {
                // Map each item into a request.
                TranslationSession.Request(sourceText: $0 ?? "")
            }

            do {
                let responses = try await session.translations(from: requests)
                ToastVariables.shared.isOnTranslate = false
                translatedTexts = responses.map {
                    // Update each item with the translated result.
                    $0.targetText
                }
                print("Traduziu: \(String(describing: translatedTexts[0]))")
                ToastVariables.shared.isTranslated = true
            } catch {
                ToastVariables.shared.isOnTranslate = false
                ToastVariables.shared.isTranslateError = true
                
                // Handle any errors.
                print("Deu merda aqui: \(error)")
            }
            
            isShowing.wrappedValue = true
        }
    }
    
    private func checkLanguageAvailability() async -> LanguageAvailability.Status {
        let availability = LanguageAvailability()
        let languageAvailability = await availability.status(from: Locale.Language(identifier: "en_US"), to: Locale.Language(identifier: Locale.preferredLanguages.first!))
        return languageAvailability
    }
}
