//
//  CustomBottomSheetView.swift
//  MeetRio
//
//  Created by Luiz Seibel on 20/08/24.
//

import Foundation
import SwiftUI

struct BottomSheetView: View {
    
    @Binding var isShowing: Bool
    let someView: any View
    var backgroundColor: Color = Color("BackgroundWhite")
    var overlayedColor: Color = Color.black
    var isSheetFixed: Bool = true
    
    @State private var dragOffset = CGSize.zero
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    @State private var isChangeHeight: Bool = false


    var body: some View {
        ZStack(alignment: .bottom) {
            background
            if isShowing {
                if isSheetFixed{
                    viewContentFixed()
                }
                else{
                    viewContent()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.spring(), value: isShowing)
    }
    
    var background: some View {
        overlayedColor
            .opacity(0.3)
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation(.spring()) {
                    isShowing = false
                    dragOffset = .zero
                }
            }
    }
    
    @ViewBuilder
    func viewContentFixed() -> some View {
        ZStack {
            VStack {
                Rectangle()
                    .frame(width: screenWidth, height: 80, alignment: .top)
                    .foregroundStyle(Color.black.opacity(0.0000008))
                    .offset(y: -90)
                Spacer()
            }
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: screenWidth * 0.15, height: 5, alignment: .top)
                    .foregroundStyle(Color.gray)
                Spacer()
                
                AnyView(someView)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(backgroundColor)
        .frame(maxWidth: .infinity)
        .frame(height: calculateHeight())
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .offset(y: max(0, dragOffset.height))
        .simultaneousGesture(
            DragGesture(minimumDistance: 160)
                .onChanged { drag in
                    if abs(drag.translation.height) > 120 {
                        dragOffset = drag.translation

                        if dragOffset.height < -screenHeight * 0.8 {
                            dragOffset.height = -screenHeight * 0.8 // Limite superior
                        } else if dragOffset.height > screenHeight * 0.4 {
                            dragOffset.height = screenHeight * 0.4 // Limite inferior
                        }
                    }
                }
                .onEnded { drag in
                    withAnimation(.easeInOut) {
                        if drag.translation.height > 100 {
                            isChangeHeight = false
                        } else if drag.translation.height < -100 {
                            isChangeHeight = true
                        }
                        dragOffset = .zero
                    }
                }
        )
        .animation(.bouncy, value: dragOffset.height) // Animação suave
    }


    
    @ViewBuilder
    func viewContent() -> some View {
        VStack {
            AnyView(someView)
        }
        .frame(maxWidth: .infinity)
        .frame(height: screenHeight * 0.3)
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .offset(y: max(0, dragOffset.height))
        .transition(.move(edge: .bottom))
        .gesture(
            DragGesture()
                .onChanged { drag in
                    dragOffset = drag.translation
                }
                .onEnded { drag in
                    if drag.translation.height > 100 {
                        withAnimation {
                            isShowing = false
                            dragOffset = .zero
                        }
                    } else {
                        withAnimation {
                            dragOffset = .zero
                        }
                    }
                }
        )
    }
    
    func calculateHeight() -> CGFloat {
        let baseHeight = isChangeHeight ? screenHeight * 0.8 : screenHeight * 0.3
        let adjustedHeight = baseHeight - dragOffset.height
        let minHeight = screenHeight * 0.3
        let maxHeight = screenHeight * 0.8

        return min(max(adjustedHeight, minHeight), maxHeight)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct testeView: View {
    var body: some View{
        ZStack{
            Text("Hello")
            BottomSheetView(isShowing: .constant(true), someView:
                                VStack{
                ScrollView{
                    Text("oi")
                    Button(action: {
                        // Ação que será executada quando o botão for pressionado
                        print("Botão pressionado!")
                    }) {
                        // Conteúdo do botão
                        Text("Clique aqui")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    Text("oi")
                    Text("oi")
                    Text("oi")
                    Text("oi")
                    Text("oi")
                    Text("oi")
                    Text("oi")
                    Text("oi")
                    Text("oi")
                    
                    Text("oi")
                    Text("oi")
                    Text("oi")
                    Text("oi")
                }
            }
            )
        }.background(.red)
    }
}


#Preview("MockTests"){
    testeView()
}
