//
//  CheckboxStyle.swift
//  TaskGo
//
//  Created by Amin on 20/02/2024.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(
                systemName: configuration.isOn ? "checkmark.circle.fill" : "circle"
            )
            .foregroundStyle(configuration.isOn ? .pink : .primary)
            .font(.system(size: 30, weight: .semibold, design: .rounded))
            .onTapGesture {
                configuration.isOn.toggle()
                feedback.notificationOccurred(.success)
                if configuration.isOn {
                    playSound(sound: "sound-rise", type: "mp3")
                } else {
                    playSound(sound: "sound-tap", type: "mp3")
                }
            }
            configuration.label
        } //: HSTACK
    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Placholder label", isOn: .constant(false))
            .padding()
            .toggleStyle(CheckboxStyle())
            .previewLayout(.sizeThatFits)
    }
}
