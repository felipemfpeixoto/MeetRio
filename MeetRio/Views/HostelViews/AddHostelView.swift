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
    
    @State var hostels: HostelAggregator = HostelAggregator()
    
    @State var selectedHostelID: String?
    
    // Password
    @State private var showPasswordAlert = false
    @State private var enteredPassword = ""
    @State private var showError = false
    
    var body: some View {
        ZStack {
            Color.backgroundWhite
                .ignoresSafeArea()
            VStack {
                headerContainer
                hostelsContainer
                Spacer()
                Spacer()
                bottomButton
                Spacer()
            }
            .padding()
            .padding(.top, 32)
        }
    }
    
    var headerContainer: some View {
        VStack {
            VStack{
                HStack{
                    Text("Select your Hostel")
                        .font(Font.custom("Bricolage Grotesque", size: 24))
                        .fontWeight(.semibold)
                    Spacer()
                }
                HStack{
                    Text("That you are staying in Rio de janeiro")
                    Spacer()
                }
                    
            }
            .padding(.bottom)
            
            TextField("Hostel Name...", text: $searchText)
                .padding()
                .background(.quaternary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding()
    }
    
    var hostelsContainer: some View {
        VStack {
            ForEach(hostels.allHostels, id:\.self.id) { hostel in
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
        .padding()
    }
    
    var bottomButton: some View {
        Button {
            if selectedHostelID != nil {
                showPasswordAlert = true
            }
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
        .disabled(selectedHostelID == nil)
        .frame(height: 55)
        .padding()
        .alert("Enter Password", isPresented: $showPasswordAlert, actions: {
            SecureField("Password", text: $enteredPassword)
            Button("Confirm") {
                if validatePassword(enteredPassword) {
                    // Salva o hostel para o user
                    UserManager.shared.hostel = hostels.allHostels.map(\.self).first(where: { $0.id == selectedHostelID })
                    dismiss()
                } else {
                    showError = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Please enter your hostel password to confirm.")
        })
        .alert("Incorrect Password", isPresented: $showError, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text("The password you entered is incorrect. Please try again.")
        })
    }
    
    
    func validatePassword(_ password: String) -> Bool {
        return password == "hipoglos"
    }
}

#Preview {
    AddHostelView()
}
