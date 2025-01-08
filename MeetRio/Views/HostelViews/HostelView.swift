////
////  HostelView.swift
////  MeetRio
////
////  Created by Felipe on 01/11/24.
////
//
//import SwiftUI
//import PostHog
//
//struct HostelView: View {
//    
//    var body: some View {
//        VStack {
//            if let hospede = Fornecedor.shared.userVariable as? Hospede, hospede.hostel != nil  {
//                // TODO: (0) Comecei aqui
//                HostelPopulatedView()
//            } else {
//                EmptyHostelView()
//            }
//        }
//        .onAppear {
//            PostHogSDK.shared.capture("ClicouTabHostel")
//        }
//    }
//        
//}
//
//#Preview("Hostel Vazio") {
//    HostelView()
//}
//
//#Preview("Hostel Adicionado") {
//    HostelView()
//}
