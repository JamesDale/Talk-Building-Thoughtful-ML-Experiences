//
//  ContentView.swift
//  TodoSample1
//
//  Created by James Dale on 30/3/2023.
//

import SwiftUI
import CoreML

struct Todo: Identifiable {
    let id: UUID = UUID()
    let title: String
    let systemImageName: String
}

struct ContentView: View {
    
    @State private var tasks = [Todo]()
    @State private var icons = [
        "popcorn.fill",
        "book.fill",
        "dumbbell.fill",
        "briefcase.fill"
    ]
    
    @State private var newTaskTitle: String = ""
    @State var newTaskIcon: String = "popcorn.fill"
    
    var model = try! IconClassifier(configuration: MLModelConfiguration())
    
    var body: some View {
        List {
            Section("Tasks") {
                ForEach(tasks) { task in
                    HStack {
                        Image(systemName: task.systemImageName)
                        Text(task.title)
                    }
                }
            }
            
            Section("Create Task") {
                HStack {
                    TextField("Describe Your Task",
                              text: $newTaskTitle)
                    Picker("", selection: $newTaskIcon) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon)
                        }
                    }
                }
                
                Button("Add Task") {
                    let newTask = Todo(title: newTaskTitle,
                                       systemImageName: newTaskIcon)
                    tasks.append(newTask)
                }
            }
        }.onChange(of: newTaskTitle) { newValue in
            if let prediction = try? model.prediction(text: newValue) {
                newTaskIcon = prediction.label
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
