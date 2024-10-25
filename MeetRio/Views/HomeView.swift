//
//  HomeView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 23/08/24.
//


//TODO: APÓS COLOCAR OS EVENTOS DO BD, TEMOS QUE FAZER O SISTEMA DE BUSCA PELA SEARCHBAR.

import Foundation
import SwiftUI

struct HomeView: View{
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State var searchText = ""
    
    @State var isLoadingBemBrazil: Bool = false
    @State var isLoadingNightLife: Bool = false
    
    @Binding var selectedScreen: SelectedScreen
    
    @Binding var isAuthenticated: Bool
    
    @State var selectedFavorite: EventDetails? = nil
    
    @Binding var deuRefresh: Bool
    
    @Binding var loggedCase: LoginCase
    
    @Binding var arbiuPrimeiraVez: Bool
    
    @State var clicouGoing: Bool = false
    
    var body: some View{
        ZStack{
            ZStack {
                VStack(spacing: 0.0){
                        header
                            .padding(.bottom, 30)
                        
                    ScrollView{
                        // AQUI TEM Q MUDAR
                        
                        if loggedCase != .none {
                            container
                            
                                // tem q ser aqui pq ele depende da aparicao, e esse é o que mais demora para aparecer
                                // Apenas atualiza o nome no UI.
//                                .onAppear{
//                                    if name == "Anonymous" && loggedCase == .registered{
//                                        name = UserManager.shared.hospede?.name ?? ""
//                                    }
//                                }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 96)
                    .refreshable {
                        deuRefresh.toggle()
                    }
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
//                            deuRefresh.toggle()
//                        }
//                    }
                }
            }.ignoresSafeArea()
            
            VStack{
                Spacer()
//                if selectedFavorite != nil {
//                    AddedToFavoriteCard(eventImage: ((selectedFavorite?.photoData) ?? UIImage(named: "defaultImage")?.pngData())!, selectedScreen: $selectedScreen)
//                        .padding()
//                        .task {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                withAnimation(Animation.easeInOut(duration: 0.5)) {
//                                    selectedFavorite = nil
//                                }
//                            }
//                        }
//                }
                
            }
        }
    }
    
    var header: some View {
        VStack {
            ZStack {
                Image("imgFundoTop")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenHeight / 5)
                    .clipped()

                LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.7)
                
                HStack{
                    VStack {
                        HStack {
                            Text("Hey ")
                                .font(Font.custom("Bricolage Grotesque", size: 26)) +
                            Text("\(UserManager.shared.hospede?.name ?? "Anonymous"),")
                                .font(Font.custom("Bricolage Grotesque", size: 26))
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("What ")
                                .font(Font.custom("Bricolage Grotesque", size: 26))
                                .fontWeight(.bold) +
                            Text("Are You ")
                                .font(Font.custom("Bricolage Grotesque", size: 26))
                                .fontWeight(.bold) +
                            Text("Up")
                                .font(Font.custom("Bricolage Grotesque", size: 26).bold())
                            
                            Text("to?")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        
                        
                        
                    }
                    .foregroundColor(.white)
                    
                    
                    NavigationLink(destination: ProfileView(loggedCase: $loggedCase, isAuthenticated: $isAuthenticated, arbiuPrimeiraVez: $arbiuPrimeiraVez)) {
                        Image(systemName: "person.circle.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 34))
                            .background(
                                Circle()
                                    .padding(6)
                                    .foregroundStyle(.black)
                                    .clipped()
                            )
                            .offset(y: -15)
                    }
                    .accessibilityIdentifier("ProfileView")
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                CustomSearchBar(searchText: $searchText, filterButton: .constant(false), showFilter: false)
                    .offset(y: 95)
                    .padding(.horizontal)
            }
            .frame(width: screenWidth, height: screenHeight / 5)
        }
    }
    
    var container: some View{
        VStack{
            EventsSlider(title: "Bem Brasil Events", eventCategory: EventCategory.bemBrazil.rawValue, isLoading: $isLoadingBemBrazil, searchText: $searchText, selectedFavorite: $selectedFavorite, deuRefresh: $deuRefresh, loggedCase: $loggedCase, clicouGoing: $clicouGoing)
            EventsSlider(title: "Nightlife", eventCategory: EventCategory.nightLife.rawValue, isLoading: $isLoadingNightLife, searchText: $searchText, selectedFavorite: $selectedFavorite, deuRefresh: $deuRefresh, loggedCase: $loggedCase, clicouGoing: $clicouGoing)
        }
    }
}

//#Preview {
//    HomeView(selectedScreen: .constant(.home), isAuthenticated: .constant(true))
//}
