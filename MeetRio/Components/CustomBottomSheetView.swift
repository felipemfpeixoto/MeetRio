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
    @Binding var selectedSafetyRating: Int
    let screenHeight = UIScreen.main.bounds.height
    @State private var dragOffset = CGSize.zero

    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isShowing = false
                            dragOffset = .zero
                        }
                    }

                VStack {
                    FilterView(safetyRating: $selectedSafetyRating)
                }
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.75)
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.spring(), value: isShowing)
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
