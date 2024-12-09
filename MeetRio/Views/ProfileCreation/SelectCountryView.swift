////
////  SelectCountryView.swift
////  MeetRio
////
////  Created by Felipe on 21/08/24.
////
//
//import SwiftUI
//import PostHog
//
//struct SelectCountryView: View {
//    
//    @State private var vm2 = SettingsViewModel()
//    let cloudStorageManager = UploadViewModeManager()
//    
//    @Binding var hospede: Hospede
//    
//    @State var allCountries: [CountryDetails] = []
//    
//    @State var selectedCountry: CountryDetails? = nil
//    
//    @State var searchText: String = ""
//    
//    @Binding var isShowingFullScreenCover: Bool
//    @Binding var arbiuPrimeiraVez: Bool
//    
//    @State var isLoading: Bool = false
//    
//    @Binding var loggedCase: LoginCase
//    
//    @Binding var didStartSignUpFlow: Bool
//    
//    @Binding var willLoad: Bool
//    
//    let userID: String
//    let selectedImage: UIImage?
//    
//    var filteredCountries: [CountryDetails] {
//        var filteredCountries = allCountries
//        
//        if !searchText.isEmpty {
//            filteredCountries = filteredCountries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
//        }
//        
//        return filteredCountries
//    }
//    
//    var body: some View {
//        GeometryReader { _ in
//            ZStack {
//                bsckgroundContainer
//                VStack(alignment: .leading) {
//                    Spacer()
//                    Text("Select your country")
//                        .font(Font.custom("Bricolage Grotesque", size: 32))
//                        .fontWeight(.semibold)
//                        .foregroundStyle(.white)
//                    CustomSearchBar(searchText: $searchText, filterButton: .constant(false), showFilter: false)
//                    ScrollView {
//                        ForEach(filteredCountries, id: \.self.name) { country in
//                            Button(action: {
//                                // seleciona o país
//                                selectedCountry = country
//                                hospede.country = country
//                            }, label: {
//                                HStack {
//                                    Text(country.flag)
//                                        .font(.system(size: 25))
//                                    Text(country.name)
//                                        .foregroundStyle(.black)
//                                        .fontWeight(.semibold)
//                                    Spacer()
//                                    Image(systemName: selectedCountry?.name == country.name ? "checkmark.circle.fill" : "circlebadge")
//                                }
//                            }).frame(height: 30)
//                        }.padding()
//                    }
//                    .frame(height: 400)
//                    .background(.white.opacity(0.75))
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    Spacer()
//                    Button(action: {
//                        Task {
//                            do {
//                                isLoading = true
//                                if let selectedImage {
//                                    hospede.imageURL = try await cloudStorageManager.saveImage(userID: userID, image: selectedImage)
//                                }
//                                try await UserManager.shared.createNewUser(userID: userID, hospede: hospede)
//                                arbiuPrimeiraVez = false
//                                didStartSignUpFlow = false
//                                postLoginSuccess()
//                                PostHogSDK.shared.capture("CriouPerfil")
//                            } catch {
//                                print("Erro ao criar perfil de Hospede do usuário: \(error)")
//                            }
//                        }
//                    }, label: {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 20)
//                                .foregroundStyle(selectedCountry != nil ? .black : .white)
//                            Text("Finish")
//                                .foregroundStyle(.white)
//                                .fontWeight(.semibold)
//                        }
//                    }).frame(height: 44)
//                    .opacity(selectedCountry != nil ? 1 : 0.5)
//                    .disabled(!(selectedCountry != nil))
//                }
//                .padding()
//                .tint(.blue)
//                if isLoading {
//                    loadingOverlay
//                }
//            }
//        }
//        .onTapGesture {
//            UIApplication.shared.endEditing()
//        }
//        .ignoresSafeArea(.keyboard)
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            self.allCountries = loadJsonFileFromObjective()
//        }
//    }
//    
//    var loadingOverlay: some View {
//        ZStack {
//            Color.black
//                .opacity(0.4)
//                .ignoresSafeArea()
//            ProgressView()
//        }
//    }
//    
//    var bsckgroundContainer: some View {
//        ZStack {
//            Image("seaBackground")
//                .resizable()
//        }
//        .ignoresSafeArea()
//    }
//    
//    func loadJsonFileFromObjective() -> [CountryDetails] {
//        let filename = "countries.json"
//        let data: [CountryDetails] = try! Bundle.main.decode(file: filename) as [CountryDetails]
//        return data
//    }
//    
//    private func postLoginSuccess() {
//        Task {
//            do {
//                // Recupera o usuário autenticado através do AuthenticationManager
//                let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
//                
//                // Recupera informações adicionais do usuário com UserManager
//                let userDetails: () = try await UserManager.shared.getUser(userID: authUser.uid)
//                
//                // Carrega as informações do usuário autenticado (substitua vm2 por seu ViewModel correto se necessário)
//                guard let authUser2 = try? vm2.loadAuthUser() else {
//                    loggedCase = .none
//                    print("Falha ao carregar informações do usuário do ViewModel.")
//                    return
//                }
//                
//                // Atualiza o estado loggedCase com base no status de anonimato do usuário
//                if authUser2.isAnonymous {
//                    loggedCase = .anonymous
//                } else {
//                    loggedCase = .registered
//                }
//                
//                
//                isShowingFullScreenCover = false
//                isLoading = false
//                // Adicione aqui mais lógica de pós-login, se necessário
//                print("Login bem-sucedido e estado do usuário atualizado para \(loggedCase).")
//            } catch {
//                print("Erro ao processar o login bem-sucedido: \(error)")
//                loggedCase = .none
//            }
//        }
//    }
//}
//
//enum BundleDecodingError: Error {
//    case fileNotFound(String)
//    case couldNotLoadData(String)
//    case decodingFailure(String)
//}
//
//
//extension Bundle {
//    func decode<T: Decodable>(file: String) throws -> T {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            throw BundleDecodingError.fileNotFound("Could not find \(file) in bundle.")
//        }
//        
//        guard let data = try? Data(contentsOf: url) else {
//            throw BundleDecodingError.couldNotLoadData("Could not load \(file) from bundle.")
//        }
//        
//        guard let loadedData = try? JSONDecoder().decode(T.self, from: data) else {
//            throw BundleDecodingError.decodingFailure("Could not decode \(file) from bundle.")
//        }
//        
//        return loadedData
//    }
//}
//
//#Preview {
//    SelectCountryView(hospede: .constant(Hospede(name: "Felipe", country: CountryDetails(name: "Brazil", flag: "🇧🇷"))), isShowingFullScreenCover: .constant(true), arbiuPrimeiraVez: .constant(true), loggedCase: .constant(.none), didStartSignUpFlow: .constant(true), willLoad: .constant(false), userID: "", selectedImage: nil)
//}
