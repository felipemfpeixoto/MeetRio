//
//  AddHostelView.swift
//  MeetRio
//
//  Created by Felipe on 21/11/24.
//

import SwiftUI

struct AddHostelView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var searchText: String = ""
    
    @State var hostels: HostelsManager = HostelsManager()
    
    @State var selectedHostelID: String?
    
    var body: some View {
        ZStack {
            Color.backgroundWhite
                .ignoresSafeArea()
            VStack {
                headerContainer
                hostelsContainer
                Spacer()
                Spacer()
                bottomButtom
                Spacer()
            }.padding()
        }
    }
    
    var headerContainer: some View {
        VStack {
            HStack {
                Text("Select your Hostel")
                    .font(Font.custom("Bricolage Grotesque", size: 24))
                    .fontWeight(.semibold)
                Spacer()
            }
            TextField("Hostel Name...", text: $searchText)
                .padding()
                .background(.quaternary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    var hostelsContainer: some View {
        VStack {
            ForEach(hostels.hostels, id:\.self.id) { hostel in
                Button {
                    if hostel.id == selectedHostelID {
                        selectedHostelID = nil
                    } else {
                        selectedHostelID = hostel.id
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(hostel.id == selectedHostelID ? .darkGreen : .white)
                            .shadow(color: .black.opacity(0.25), radius: 5.8, y: 2)
                        Text(hostel.name)
                            .foregroundStyle(hostel.id == selectedHostelID ? .white : .black)
                    }
                }
                .frame(height: 44)

            }
        }
    }
    
    var bottomButtom: some View {
        Button {
            // salva o hostel para o user
            UserManager.shared.hostel = hostels.hostels.map(\.self).first(where: { $0.id == selectedHostelID })
            dismiss()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 100)
                    .foregroundStyle(.black)
                    .shadow(color: .black.opacity(0.25), radius: 5.8, y: 2)
                Text("Save")
                    .foregroundStyle(.white)
            }
        }
        .opacity(selectedHostelID != nil ? 1 : 0.5)
        .frame(height: 55)
    }
}

#Preview {
    AddHostelView()
}
