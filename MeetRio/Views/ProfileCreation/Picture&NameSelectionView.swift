////
////  Picture&NameSelectionView.swift
////  MeetRio
////
////  Created by Felipe on 21/08/24.
////
//
//import SwiftUI
//
//struct Picture_NameSelectionView: View {
//    
//    @State private var isImagePickerPresented = false
//    @State private var selectedImage: UIImage?
//    
//    @State var hospede = Hospede(name: "", country: CountryDetails(name: "", flag: ""))
//    
//    @Binding var isShowingFullScreenCover: Bool
//    @Binding var arbiuPrimeiraVez: Bool
//    
//    @Binding var loggedCase: LoginCase
//    
//    @Binding var didStartSignUpFlow: Bool
//    
//    @Binding var willLoad: Bool
//    
//    let userID: String
//    
//    var body: some View {
//        ZStack {
//            backgroundContainer
//            VStack(spacing: 32) {
//                Spacer()
//                HStack {
//                    titleContainer
//                    Spacer()
//                }
//                imagePickerButton
//                VStack(spacing: 16) {
//                    textFieldContainer
//                    continueButtonContainer
//                }
//                Spacer()
//                Spacer()
//            }.padding()
//            .tint(.blue)
//        }
//        .navigationBarBackButtonHidden()
//        .sheet(isPresented: $isImagePickerPresented) {
//            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
//        }
//        .onTapGesture {
//            UIApplication.shared.endEditing()
//        }
//    }
//    
//    var titleContainer: some View {
//        VStack(alignment: .leading) {
//            Text("Complete Profile")
//                .font(Font.custom("Bricolage Grotesque", size: 32))
//                .fontWeight(.semibold)
//                .foregroundStyle(.white)
//                .padding(.bottom)
//            Text("By creating a profile, you can find")
//                .font(.system(size: 17))
//                .foregroundStyle(.white)
//            Text("other guests who will attend to")
//                .font(.system(size: 17))
//                .foregroundStyle(.white)
//            Text("the same event as you.")
//                .font(.system(size: 17))
//                .foregroundStyle(.white)
//        }.padding(.horizontal)
//    }
//    
//    var backgroundContainer: some View {
//        ZStack {
//            Image("MuseuDoAmanha")
//                .resizable()
//        }
//        .ignoresSafeArea()
//    }
//    
//    var textFieldContainer: some View {
//        TextField("Add your name", text: $hospede.name)
//            .textFieldStyle()
//    }
//    
//    var imagePickerButton: some View {
//            Button {
//                isImagePickerPresented.toggle()
//            } label: {
//                if selectedImage == nil {
//                    ZStack {
//                        Circle()
//                            .foregroundColor(.white)
//                            .shadow(color: .black.opacity(0.75), radius: 4, y: 4)
//                        Image(systemName: "plus")
//                            .font(.system(size: 50).weight(.semibold))
//                            .foregroundStyle(.black)
//                        VStack {
//                            Spacer()
//                            Text("Add")
//                                .font(.system(size: 26))
//                                .fontWeight(.light)
//                                .foregroundStyle(.black)
//                        }.padding(32)
//                    }
//                } else {
//                    ZStack {
//                        Image(uiImage: selectedImage ?? UIImage(systemName: "photo")!)
//                            .resizable()
//                            .scaledToFit()
//                            .clipShape(Circle())
//                            .shadow(color: .black.opacity(0.75), radius: 4, y: 4)
//                        VStack {
//                            Spacer()
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 20)
//                                    .foregroundStyle(.white).foregroundStyle(.white)
//                                    .frame(width: 80, height: 30)
//                                Text("Edit")
//                                    .foregroundStyle(.black)
//                                    .font(.system(size: 17).weight(.semibold))
//                            }
//                        }
//                    }
//                    .frame(width: 204, height: 204)
//                }
//            }
//            .padding()
//            .frame(width: 204, height: 204)
//        }
//    
//    var continueButtonContainer: some View {
//        NavigationLink(destination: SelectCountryView(hospede: $hospede, isShowingFullScreenCover: $isShowingFullScreenCover, arbiuPrimeiraVez: $arbiuPrimeiraVez, loggedCase: $loggedCase, didStartSignUpFlow: $didStartSignUpFlow, willLoad: $willLoad, userID: userID, selectedImage: selectedImage)) {
//            ZStack {
//                RoundedRectangle(cornerRadius: 20)
//                    .foregroundStyle(hospede.name == "" ? .white : .black)
//                Text("Continue")
//                    .foregroundStyle(.white)
//                    .fontWeight(.semibold)
//            }
//        }
//        .frame(height: 44)
//        .disabled(hospede.name == "")
//        .opacity(hospede.name == "" ? 0.5 : 1)
//    }
//}
//
//#Preview {
//    Picture_NameSelectionView(isShowingFullScreenCover: .constant(true), arbiuPrimeiraVez: .constant(true), loggedCase: .constant(.none), didStartSignUpFlow: .constant(true), willLoad: .constant(false), userID: "")
//}
