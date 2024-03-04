//
//  ContentView.swift
//  TaskGo
//
//  Created by Amin on 15/02/2024.
//

import SwiftUI
import CoreData

protocol AnyView where Self: View {
    var isDarkMode: Bool { get set }
}

struct ContentView: View, AnyView {
    // MARK: - PROPERTIES
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [.init(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - MAIN VIEW
                VStack {
                    
                    // MARK: - HEADER
                    HStack(spacing: 10) {
                        // MARK: - TITLE
                        Text("TaskGo")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.black)
                            .padding(.leading, 4)
                        
                        Spacer()
                        
                        // MARK: - EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(
                                Capsule().stroke(.white, lineWidth: 2)
                            )
                        // MARK: - APPEARENCE BUTTON
                        Button(action: {
                            withAnimation {
                                isDarkMode.toggle()
                                playSound(sound: "sound-tap", type: "mp3")
                                feedback.notificationOccurred(.success)
                            }
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title,design: .monospaced))
                        })
                        
                    } //:HSTACK
                    .padding()
                    .foregroundStyle(.white)
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    Button(action: {
                        withAnimation {
                            showNewTaskItem = true
                            playSound(sound: "sound-ding", type: "mp3")
                            feedback.notificationOccurred(.success)
                        }
                    }, label: {
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
                    List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
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
                .blur(radius: showNewTaskItem ? 8.0 : 0)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5), value: true)
                
                // MARK: - NEW TASK ITEM
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkMode ? .black : .gray,
                        backgroundOpacity: isDarkMode ? 0.3 : 0.5
                    ).onTapGesture {
                        withAnimation {
                            showNewTaskItem = false
                        }
                    }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
            } //: ZStack
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(.hidden)
            .background(
                BackgroundImageView()
                    .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
            )
            .background(backgroundGradient.ignoresSafeArea(.all))
        } //: NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
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
    
}

// MARK: - PREVEIEW
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
