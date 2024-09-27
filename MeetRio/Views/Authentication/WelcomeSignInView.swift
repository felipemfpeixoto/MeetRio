//
//  WelcomeSignInView.swift
//  MeetRio
//
//  Created by Felipe on 27/08/24.
//

import SwiftUI

struct WelcomeSignInView: View {
    
    @Binding var isShowing: Bool
    @Binding var arbiuPrimeiraVez: Bool
    @Binding var loggedCase: LoginCase
    @Binding var didStartSignUpFlow: Bool
    
    
    @Binding var willLoad: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("rioBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            VStack(alignment: .leading) {
                                Text("Connecting you to the")
                                    .font(Font.custom("Bricolage Grotesque", size: 26))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("true carioca vibes")
                                    .font(Font.custom("Bricolage Grotesque", size: 26))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            VStack(alignment: .leading) {
                                Text("Discover local events and")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                                Text("experience the best of")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                                Text("Rio de Janeiro")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                            }
                            NavigationLink(destination: AuthenticationView(loggedCase: $loggedCase, isShowing: $isShowing, arbiuPrimeiraVez: $arbiuPrimeiraVez, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad)) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(.marcaTexto)
                                    Text("Continue")
                                        .font(.system(size: 18))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.black)
                                }
                            }.frame(width: 140, height: 44)
                                .padding(.top)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 128)
            }
        }.tint(.marcaTexto)
//        .onDisappear {
//            if loggedCase == .none {
//                print("TA NONE ESSA PORRA")
//            } else {
//                print("NAO TA NONE ESSA PORRA")
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                willLoad.toggle()
//            }
//        }
    }
}

//#Preview {
//    WelcomeSignInView(isShowing: .constant(false), arbiuPrimeiraVez: .constant(true), loggedCase: .constant(.none))
//}
