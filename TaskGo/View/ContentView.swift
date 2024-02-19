//
//  ContentView.swift
//  TaskGo
//
//  Created by Amin on 15/02/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTIES
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [.init(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    // MARK: - Functions
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
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - MAIN VIEW
                VStack {
                    
                    // MARK: - HEADER
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    Button(action: {
                        withAnimation {
                            showNewTaskItem = true
                        }
                    }, label: {
//                        Image(systemName: "plus.circle")
//                            .font(.system(size: 30, weight: .semibold, design: .rounded))
//                        Text("New Task")
//                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Label(
                            title: {
                                Text("New Task")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                            },
                            icon: {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                            }
                        )
                    })
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            colors: [.pink, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(.capsule)
                    .shadow(
                        color: Color(
                            red: 0,
                            green: 0,
                            blue: 0,
                            opacity: 0.25
                        ),
                        radius: 8,
                        x: 0.0,
                        y: 4
                    )
                    // MARK: - TASKS
                    
                    // MARK: - List
                    List {
                        ForEach(items) { item in
                            NavigationLink(destination: Text("Item at \(item.timestamp!, formatter: itemFormatter)")) {
                                VStack(alignment: .leading) {
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(item.timestamp!, formatter: itemFormatter)
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    } //: List
                    .shadow(
                        color: Color(
                            red: 0,
                            green: 0,
                            blue: 0,
                            opacity: 0.3
                        ),
                        radius: 10,
                        x: 0.0,
                        y: 0.0
                    )
                    
                    .scrollContentBackground(.hidden)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } //: VStack
                
                // MARK: - NEW TASK ITEM
                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
            } //: ZStack
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            } //: Toolbar
            .background(BackgroundImageView())
            .background(backgroundGradient.ignoresSafeArea(.all))
        } //: NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

// MARK: - PREVEIEW
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
