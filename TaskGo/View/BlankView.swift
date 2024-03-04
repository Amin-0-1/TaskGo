//
//  BlankView.swift
//  TaskGo
//
//  Created by Amin on 19/02/2024.
//

import SwiftUI

struct BlankView: View {
    // MARK: - PROPERTIES
    var backgroundColor: Color
    var backgroundOpacity: Double
    
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
        .ignoresSafeArea(.all)
        .background(backgroundColor)
        .opacity(backgroundOpacity)
        .blendMode(.overlay )

    }
}

#Preview {
    BlankView(backgroundColor: .black, backgroundOpacity: 0.3)
        .background(BackgroundImageView())
        .background(backgroundGradient.ignoresSafeArea())
}
