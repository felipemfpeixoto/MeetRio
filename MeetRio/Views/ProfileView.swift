//
//  ProfileView.swift
//  MeetRio
//
//  Created by Felipe on 15/08/24.
//

import SwiftUI
import CachedAsyncImage

struct ProfileView: View {
    
    @Binding var isAuthenticated: Bool
    
    @Binding var arbiuPrimeiraVez: Bool
    
    @State var isPresented: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    // ImagePicker Implementation
    @State var isImagePickerShowing: Bool = false
    @State var selectedImage: UIImage? = nil
    
    var body: some View {
        ZStack {
            background
            content
            bottomImage
        }
        
        .alert("Are you sure you want to delete your account?", isPresented: $isPresented) {
            Button(role: .destructive, action: {
                Task {
                    do {
                        // FIXME: Ao apertar esse botão, o dismiss não é feito na hora e, portando, devemos adicionar uma tela de carregamento, ou outra solução
                        try await Fornecedor.shared.deleteAuthUser()
                        isAuthenticated = false
                        arbiuPrimeiraVez = true
                        DispatchQueue.main.async {
                            dismiss()
                        }
                    } catch {
                        print("🤬 Erro ao deletar a conta: ", error)
                    }
                }
            }, label: {
                Text("Delete")
            })
        }
        
        // Show ImagePicker on a Sheet
        .sheet(isPresented: $isImagePickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerShowing)
        }
        
        // Send image to bd
        .onChange(of: isImagePickerShowing) {
            if Hospede.loggedCase == .registered {
                if let image = selectedImage {
                    ToastVariables.shared.isImageRequest = true
                    Task {
                        do {
                            try await Fornecedor.shared.userVariable!.saveImage(image: image)
                        } catch {
                            print("Erro ao salvar a imagem: \(error)")
                            ToastVariables.shared.isImageChangedError = true
                        }
                    }
                }
            }
        }
    }
    
    var background: some View{
        Image("CadeiraDePraia")
            .resizable()
            .scaledToFill()            .ignoresSafeArea()
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
    }
    
    var content: some View {
        VStack(spacing: 32) {
            profilePicture
            VStack(spacing: 16) {
                nButtons
                    .frame(width: UIScreen.main.bounds.width, height: 400)
            }
        }
    }

    var nButtons: some View{
        List {
            Section {
                Text(Fornecedor.shared.userVariable?.name ?? "Nome não informado")
            }
            Section {
                HStack {
                    if let user = Fornecedor.shared.userVariable as? Hospede {
                        Text(user.country?.flag ?? "🇧🇷")
                        Text(user.country?.name ?? "Brazil")
                    }
                }
            }
            if Hospede.loggedCase == .registered {
                Section{
                    Button("Reset Password") {
                        Task {
                            do {
                                try await Fornecedor.shared.userVariable?.resetPassword(email: Fornecedor.shared.userVariable?.email ?? "")
                            } catch {
                                print("🤬 Erro ao tentar resetar senha: ", error)
                            }
                        }
                    }
                    
                    Button("Log Out") {
                        Task {
                            // FIXME: Ao apertar esse botão, o dismiss não é feito na hora e, portando, devemos adicionar uma tela de carregamento, ou outra solução
                            do {
                                try await Fornecedor.shared.userSignOut()
                                isAuthenticated = false
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
                    
                }.listRowBackground(Color.white)
            } else{
                Section{
                    Button("Sign in") {
                        //TODO: Abre a sheet e deleta a conta atual
                        Task{
                            do {
                                try await Fornecedor.shared.deleteAuthUser()
                                isAuthenticated = false
                                DispatchQueue.main.async {
                                    arbiuPrimeiraVez = true
                                    dismiss()
                                }
                            } catch{
                                print("Erro ao deletar o usuário: ", error)
                            }
                        }
                    }
                    
                }.listRowBackground(Color.white)
            }
        }
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
    }
    
    var profilePicture: some View {
        VStack{
            if let selectedImage{
                Image(uiImage: selectedImage)
                   .resizable()
                   .scaledToFill()
            }
            else if let imageURL = Fornecedor.shared.userVariable?.imageURL, imageURL != "" {
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
        .frame(width: 180, height: 180)
        .clipShape(Circle())
        .overlay {
            if Hospede.loggedCase == .registered {
                Button(action: {
                    isImagePickerShowing.toggle()
                }, label: {
                    HStack{
                        Image(systemName: "camera")
                        Text("Add")
                    }
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
                    .padding(8)
                    .background{
                        Color.white
                            .clipShape(RoundedCorner(radius: 12))
                    }
                })
                .offset(y: 95)
            }
        }
    }
    
    var bottomImage: some View {
        VStack {
            Spacer()
            Image("MeetRioLogoPeq")
                .padding(.bottom, 48)
            
        }
    }

}

#Preview {
    NavigationStack {
        ProfileView(isAuthenticated: .constant(true), arbiuPrimeiraVez: .constant(false))
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
