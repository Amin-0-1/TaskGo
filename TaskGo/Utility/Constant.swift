//
//  Constant.swift
//  TaskGo
//
//  Created by Amin on 18/02/2024.
//

import SwiftUI

// MARK: - FORMATTER

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

// MARK: - UI
var backgroundGradient: LinearGradient {
    .init(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
//    .init(colors: [.pink, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
}
// MARK: - UX

let feedback = UINotificationFeedbackGenerator()

