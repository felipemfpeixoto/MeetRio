//
//  ProfileView.swift
//  MeetRio
//
//  Created by Felipe on 15/08/24.
//

import SwiftUI
import CachedAsyncImage

struct ProfileView: View {
    
    @State private var vm = SettingsViewModel()
    @Binding var loggedCase: LoginCase
    
    @Binding var isAuthenticated: Bool
    
    @Binding var arbiuPrimeiraVez: Bool
    
    @State var isPresented: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        // TODO: Mostrar informações do perfil do usuário na página
        ZStack {
            background
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .bold()
                            Text("Your Profile")
                                .font(.title).bold()
                        })
                        .foregroundStyle(.white)
                    }
                }
            
            VStack{
                profilePicture
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                    .shadow(radius: 5, y: 5)
//                    .overlay{
//                        Button(action: {
//                            
//                        }, label: {
//                            HStack{
//                                Image(systemName: "camera")
//                                Text("Change")
//                            }
//                            .fontWeight(.medium)
//                            .foregroundStyle(.black)
//                            .padding(8)
//                            .background{
//                                Color.white
//                                    .clipShape(RoundedCorner(radius: 12))
//                            }
//                        })
//                        .offset(y: 95)
//                    }
                
                nButtons
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                
                
            }
        }
    }
    
    var background: some View{
        Image("ProfileBackground")
            .resizable()
            .scaledToFill()
    }

    var nButtons: some View{
        List{
            if loggedCase == .registered {
                Section{
                    Button("Reset Password") {
                        Task {
                            do {
                                try await vm.resetPassword()
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    Button("Log Out") {
                        Task {
                            do {
                                try await vm.signOut()
                                isAuthenticated = false
                                loggedCase = .none
                                DispatchQueue.main.async {
                                    dismiss()
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .foregroundStyle(.red)
                    
                    Button {
                        isPresented.toggle()
                    } label: {
                        Text("Delete Account")
                    }
                    .foregroundStyle(.red)
                    
                }.listRowBackground(Color.white.opacity(0.8))
            }
            else{
                Section{
                    Button("Sign in") {
                        //TODO: Abre a sheet e deleta a conta atual
                        Task{
                            do{
                                try await vm.delete()
                                isAuthenticated = false
                                DispatchQueue.main.async {
                                    arbiuPrimeiraVez = true
                                    dismiss()
                                }
                            } catch{
                                print(error)
                            }
                        }
                    }
                    
                }.listRowBackground(Color.white.opacity(0.8))
            }
            
            

            
        }
        .scrollContentBackground(.hidden)
        .alert("Are you sure you want to delete your account?", isPresented: $isPresented) {
            Button(role: .destructive, action: {
                Task {
                    do {
                        try await vm.delete()
                        isAuthenticated = false
                        arbiuPrimeiraVez = true
                        DispatchQueue.main.async {
                            dismiss()
                        }
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Text("Delete")
            })
        }
        
    }
    
    
    var profilePicture: some View {
        VStack{
            if let imageURL = UserManager.shared.hospede?.imageURL, imageURL != "" {
                CachedAsyncImage(url: URL(string: imageURL), transaction: Transaction(animation: .easeInOut.speed(1.5))) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        ZStack {
                            Color.oceanBlue
                            Image(systemName: "person.fill")
                                .resizable()
                                .padding(50)
                                .foregroundStyle(.white)
                        }
                    default:
                        ZStack {
                            Color.oceanBlue
                            Image(systemName: "person.fill")
                                .resizable()
                                .padding(50)
                                .foregroundStyle(.white)
                            Color.black.opacity(0.5)
                            ProgressView()
                                .tint(.white)
                                .scaleEffect(1.3)
                                .padding(.bottom)
                        }
                    }
                }
            } else {
                ZStack {
                    Color.oceanBlue
                    Image(systemName: "person.fill")
                        .resizable()
                        .padding(50)
                        .foregroundStyle(.white)
                }
            }
        }
    }

    var profileInfos: some View{
        VStack {
            Text(UserManager.shared.hospede?.name ?? "")
                .foregroundStyle(.black)
                .font(.system(size: 26))
        }
    }
    

}

#Preview {
    NavigationStack {
        ProfileView(loggedCase: .constant(.registered), isAuthenticated: .constant(true), arbiuPrimeiraVez: .constant(false))
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
