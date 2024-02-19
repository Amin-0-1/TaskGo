//
//  BlankView.swift
//  TaskGo
//
//  Created by Amin on 19/02/2024.
//

import SwiftUI

struct BlankView: View {
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(
            minWidth: .zero,
            maxWidth: .infinity,
            minHeight: .zero,
            maxHeight: .infinity,
            alignment: .center
        )
        .background(.black)
        .opacity(0.5)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    BlankView()
}
