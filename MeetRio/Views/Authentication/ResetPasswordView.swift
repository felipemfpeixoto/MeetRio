//
//  ResetPasswordView.swift
//  MeetRio
//
//  Created by Felipe on 18/10/24.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @State var email: String = ""
    
    @State var isLoading: Bool = false
    
    @State private var isShowingAlertError: Bool = false
    @State private var isShowingAlertSuccess: Bool = false
    
    var body: some View {
        ZStack {
            backgroundContainer
            ZStack {
                if UIScreen.main.bounds.height <= 667 {
                    ScrollView {
                        contentStack
                    }
                    loadingOverlay
                } else {
                    contentStack
                        .padding(.horizontal)
                        .padding(.bottom)
                    loadingOverlay
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .alert(isPresented: $isShowingAlertError) {
            Alert(title: Text("An error occurred."), message: Text("Something went wrong. Please try again later."))
        }
        .alert(isPresented: $isShowingAlertSuccess) {
            Alert(title: Text("Email Sent!"), message: Text("Continue the reset process by checking your email."))
        }
    }
    
    var backgroundContainer: some View {
        ZStack {
            Image("cristoBackground")
                .resizable()
                .scaledToFill()
        }
        .ignoresSafeArea()
    }
    
    var contentStack: some View {
        VStack(spacing: 24) {
            Spacer()
            VStack {
                titleContainer
                descriptionContainer
            }
            textFieldContainer
            buttonContainer
                .padding(.top)
            Spacer()
            Spacer()
            Spacer()
        }.tint(.blue)
    }
    
    var titleContainer: some View {
        HStack {
            Text("Reset Password")
                .font(Font.custom("Bricolage Grotesque", size: 26))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Spacer()
        }
    }
    
    var descriptionContainer: some View {
        HStack {
            Text("Please enter your account email address, and we’ll send you a link to reset your password. Make sure to check your inbox and follow the instructions to regain access to your account.")
                .font(Font.custom("Bricolage Grotesque", size: 18))
//                .font(.system(size: 18))
                .fontWeight(.light)
                .foregroundStyle(.white)
        }
    }
    
    var textFieldContainer: some View {
        TextField("Email", text: $email)
            .textFieldStyle()
    }
    
    var buttonContainer: some View {
        Button {
            Task {
                do {
                    UIApplication.shared.endEditing()
                    isLoading = true
                    try await AuthenticationManager.shared.resetPassword(email: email)
                    isLoading = false
                    isShowingAlertSuccess = true
                } catch {
                    print("🤬 Erro ao tentar resetar a senha")
                    isLoading = false
                    isShowingAlertError = true
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 44)
                    .foregroundStyle(.pretin)
                    .shadow(color: .black.opacity(0.25), radius: 5.8, y: 2)
                Text("Reset Password")
                    .foregroundStyle(.white)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            }
        }
    }
    
    var loadingOverlay: some View {
        ZStack{
            if isLoading {
                Color.black.opacity(0.5)
                ProgressView()
            } else {
                EmptyView()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ResetPasswordView()
}
