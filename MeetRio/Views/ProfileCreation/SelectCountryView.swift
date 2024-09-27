//
//  SelectCountryView.swift
//  MeetRio
//
//  Created by Felipe on 21/08/24.
//

import SwiftUI
import PostHog

struct SelectCountryView: View {
    
    @State private var vm2 = SettingsViewModel()
    
    @Binding var hospede: Hospede
    
    @State var allCountries: [CountryDetails] = []
    
    @State var selectedCountry: CountryDetails? = nil
    
    @State var searchText: String = ""
    
    @Binding var isShowingFullScreenCover: Bool
    @Binding var arbiuPrimeiraVez: Bool
    
    @State var isLoading: Bool = false
    
    @Binding var loggedCase: LoginCase
    
    @Binding var didStartSignUpFlow: Bool
    
    @Binding var willLoad: Bool
    
    let userID: String
    
    var filteredCountries: [CountryDetails] {
        var filteredCountries = allCountries
        
        if !searchText.isEmpty {
            filteredCountries = filteredCountries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filteredCountries
    }
    
    var body: some View {
        ZStack {
            bsckgroundContainer
            VStack(alignment: .leading) {
                Spacer()
                Text("Select your country")
                    .font(Font.custom("Bricolage Grotesque", size: 26))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                CustomSearchBar(searchText: $searchText, filterButton: .constant(false), showFilter: false)
                ScrollView {
                    ForEach(filteredCountries, id: \.self.name) { country in
                        Button(action: {
                            // seleciona o país
                            selectedCountry = country
                            hospede.country = country
                        }, label: {
                            HStack {
                                Text(country.flag)
                                    .font(.system(size: 25))
                                Text(country.name)
                                    .foregroundStyle(.black)
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: selectedCountry?.name == country.name ? "checkmark.circle.fill" : "circlebadge")
                            }
                        }).frame(height: 30)
                    }.padding()
                }
                .frame(height: 400)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Button(action: {
                    Task {
                        do {
                            isLoading = true
                            try await UserManager.shared.createNewUser(userID: userID, hospede: hospede)
                            arbiuPrimeiraVez = false
                            didStartSignUpFlow = false
                            postLoginSuccess()
                            PostHogSDK.shared.capture("CriouPerfil")
                        } catch {
                            
                        }
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.marcaTexto)
                        Text("Finish")
                            .foregroundStyle(.black)
                    }
                }).frame(height: 55)
            }
            .padding()
            if isLoading {
                loadingOverlay
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            self.allCountries = loadJsonFileFromObjective()
        }
    }
    
    var loadingOverlay: some View {
        ZStack {
            Color.black
                .opacity(0.4)
                .ignoresSafeArea()
            ProgressView()
                .tint(.marcaTexto)
        }
    }
    
    var bsckgroundContainer: some View {
        ZStack {
            Image("seaBackground")
                .resizable()
            Color.black.opacity(0.3)
                
        }
        .ignoresSafeArea()
    }
    
    func loadJsonFileFromObjective() -> [CountryDetails] {
        let filename = "countries.json"
        let data: [CountryDetails] = try! Bundle.main.decode(file: filename) as [CountryDetails]
        return data
    }
    
    private func postLoginSuccess() {
        Task {
            do {
                // Recupera o usuário autenticado através do AuthenticationManager
                let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
                
                // Recupera informações adicionais do usuário com UserManager
                let userDetails: () = try await UserManager.shared.getUser(userID: authUser.uid)
                
                // Carrega as informações do usuário autenticado (substitua vm2 por seu ViewModel correto se necessário)
                guard let authUser2 = try? vm2.loadAuthUser() else {
                    loggedCase = .none
                    print("Falha ao carregar informações do usuário do ViewModel.")
                    return
                }
                
                // Atualiza o estado loggedCase com base no status de anonimato do usuário
                if authUser2.isAnonymous {
                    loggedCase = .anonymous
                } else {
                    loggedCase = .registered
                }
                
                
                isShowingFullScreenCover = false
                isLoading = false
                // Adicione aqui mais lógica de pós-login, se necessário
                print("Login bem-sucedido e estado do usuário atualizado para \(loggedCase).")
            } catch {
                print("Erro ao processar o login bem-sucedido: \(error)")
                loggedCase = .none
            }
        }
    }
}

enum BundleDecodingError: Error {
    case fileNotFound(String)
    case couldNotLoadData(String)
    case decodingFailure(String)
}


extension Bundle {
    func decode<T: Decodable>(file: String) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw BundleDecodingError.fileNotFound("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            throw BundleDecodingError.couldNotLoadData("Could not load \(file) from bundle.")
        }
        
        guard let loadedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw BundleDecodingError.decodingFailure("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}

//#Preview {
//    SelectCountryView(hospede: .constant(Hospede(name: "", country: CountryDetails(name: "", flag: ""), picture: Data())), isShowingFullScreenCover: .constant(false), arbiuPrimeiraVez: .constant(true), loggedCase: .constant(.registered), userID: "")
//}
