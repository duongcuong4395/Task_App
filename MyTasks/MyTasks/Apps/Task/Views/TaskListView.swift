//
//  TaskListView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI

// Views/TaskListView.swift
struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel()
    
    @State private var isShowingAddTaskView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.tasksCD) { task in
                    NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                        TaskRowView(task: task)
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("Tasks")
            .toolbar {
                // Add Task Button
                Button(action: {
                    isShowingAddTaskView = true
                }) {
                    Label("Add Task", systemImage: "plus")
                }
            }
            .sheet(isPresented: $isShowingAddTaskView) {
                AddTaskView(viewModel: viewModel)
            }
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.map { viewModel.tasksCD[$0] }.forEach(viewModel.deleteTask)
    }
    
    private func addTask() {
        // Navigate to add/edit task view
    }
}


struct TaskRowView: View {
    var task: TaskCD
    
    var body: some View {
        HStack {
            Text(task.title ?? "No Title")
            Spacer()
            Text(task.priority ?? "Medium")
                .foregroundColor(.gray)
        }
    }
}


struct TaskDetailView: View {
    @ObservedObject var viewModel: TaskListViewModel
    
    // State variables to hold the editable values
    @State private var title: String
    @State private var dueDate: Date
    @State private var priority: String
    @State private var isCompleted: Bool
    
    var task: TaskCD
    
    init(task: TaskCD, viewModel: TaskListViewModel) {
        self.task = task
        self.viewModel = viewModel
        
        // Initialize the state variables with the current task's values
        _title = State(initialValue: task.title ?? "")
        _dueDate = State(initialValue: task.dueDate ?? Date())
        _priority = State(initialValue: task.priority ?? "Medium")
        _isCompleted = State(initialValue: task.isCompleted)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                Picker("Priority", selection: $priority) {
                    Text("High").tag("High")
                    Text("Medium").tag("Medium")
                    Text("Low").tag("Low")
                }
                Toggle(isOn: $isCompleted) {
                    Text("Completed")
                }
            }
        }
        .navigationTitle("Task Details")
        .navigationBarItems(trailing: Button("Save") {
            // Update the task with new values
            task.title = title
            task.dueDate = dueDate
            task.priority = priority
            task.isCompleted = isCompleted
            
            // Save the context
            viewModel.updateTask(task: task)
        })
    }
}

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TaskListViewModel
    
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var priority: String = "Medium"
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                Picker("Priority", selection: $priority) {
                    Text("High").tag("High")
                    Text("Medium").tag("Medium")
                    Text("Low").tag("Low")
                }
            }
            .navigationBarTitle("New Task", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.addTask(title: title, dueDate: dueDate, priority: priority)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
