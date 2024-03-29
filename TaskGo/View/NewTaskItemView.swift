//
//  NewTaskItemView.swift
//  TaskGo
//
//  Created by Amin on 19/02/2024.
//

import SwiftUI

struct NewTaskItemView: View, AnyView {
    // MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage( "isDarkMode") var isDarkMode: Bool = false
    @State private var task: String = ""
    @Binding var isShowing: Bool
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    // MARK: - FUNCTIONS
    private func addItem() {
        
        withAnimation  {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hideKeyboard()
            isShowing = false
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                TextField("New Task", text: $task)
                    .padding()
                    .foregroundStyle(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                
                Button(action: {
                    addItem()
                    playSound(sound: "sound-ding", type: "mp3")
                }, label: {
                    Spacer()
                    Text("SAVE")
                    Spacer()
                })
                .padding()
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .background(
                    isButtonDisabled ? Color.blue : Color.pink
                )
                .disabled(isButtonDisabled)
                .onTapGesture {
                    if isButtonDisabled {
                        playSound(sound: "sound-tap", type: "mp3")
                        feedback.notificationOccurred(.success)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                isDarkMode ? Color(UIColor.secondarySystemBackground): .white
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.6), radius: 24)
            .frame(maxWidth: 640)
        } //: VSTACK
        .padding()
    }
}

#Preview {
    NewTaskItemView(isShowing: .constant(true))
        .background(Color.gray.ignoresSafeArea(.all))
}
