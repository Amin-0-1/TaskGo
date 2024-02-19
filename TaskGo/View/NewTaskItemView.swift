//
//  NewTaskItemView.swift
//  TaskGo
//
//  Created by Amin on 19/02/2024.
//

import SwiftUI

struct NewTaskItemView: View {
    // MARK: - PROPERTIES
    @Environment(\.managedObjectContext) private var viewContext
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
                        Color(UIColor.systemGray5.cgColor)
                    )
                
                Button(action: {
                    addItem()
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
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(.white)
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
