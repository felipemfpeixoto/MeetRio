//
//  HostelView.swift
//  MeetRio
//
//  Created by Felipe on 01/11/24.
//

import SwiftUI

struct HostelView: View {
    
    var body: some View {
        if UserManager.shared.hostel != nil {
            HostelPopulatedView()
        } else {
            EmptyHostelView()
        }
    }
}

#Preview("Hostel Vazio") {
    HostelView()
}

#Preview("Hostel Adicionado") {
    HostelView()
}
