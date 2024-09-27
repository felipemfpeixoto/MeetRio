//
//  TesteView.swift
//  MeetRio
//
//  Created by Felipe on 25/09/24.
//

import SwiftUI
import Translation

@available(iOS 18.0, *)
struct TesteView: View {
    
    let text: String = "Flamengo é o maior!!!"
    
    @State var showsTranslation: Bool = false
    
    @State var textDic: [String:String?] = [
        "prachtige zon": nil,
        "Flamengo is de grootste": nil,
        "Wat een geweldig doel": nil
    ]
    
    @State private var configuration: TranslationSession.Configuration?
    
    var body: some View {
        ZStack {
            multipleTranslations
        }
    }
    
    var singleTranslation: some View {
        VStack {
            HStack {
                Text(self.text)
                Spacer()
                Button {
                    showsTranslation = true
                } label: {
                    Image(systemName: "translate")
                        .foregroundStyle(.oceanBlue)
                        .font(.title)
                }
                
            }.padding(.horizontal, 64)
        }.translationPresentation(isPresented: $showsTranslation, text: self.text)
    }
    
    var multipleTranslations: some View {
        VStack {
            HStack {
                Text("Comments")
                Button {
                    if let configuration {
                        self.configuration?.invalidate()
                    } else {
                        configuration = TranslationSession.Configuration(target: Locale.Language(identifier: "en"))
                    }
                } label: {
                    Image(systemName: "translate")
                        .font(.title)
                        .foregroundStyle(.oceanBlue)
                }
            }.padding(.horizontal, 64)
            ForEach(Array(textDic), id: \.key) { key, value in
                Text(key)
                Text(value ?? "")
                    .font(.title)
                    .translationTask(configuration) { session in
                        do {
                            let response = try await session.translate(key)
                            textDic[key] = response.targetText
                        } catch {}
                    }
            }
        }
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        TesteView()
    } else {
        // Fallback on earlier versions
    }
}
