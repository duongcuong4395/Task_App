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
    @State private var selectedCategory: String = "All"
   
    var filteredTasks: [TaskCD] {
       if selectedCategory == "All" {
           return viewModel.tasksCD
       } else {
           return viewModel.tasksCD.filter { $0.category == selectedCategory }
       }
    }

    var body: some View {
        NavigationView {
            
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag("All")
                    Text("Work").tag("Work")
                    Text("Personal").tag("Personal")
                    Text("Others").tag("Others")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(filteredTasks) { task in
                        NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                            TaskRowView(task: task)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
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
    
    @State private var title: String
        @State private var dueDate: Date
        @State private var priority: String
        @State private var category: String
        @State private var isCompleted: Bool
        
        var task: TaskCD
        
        init(task: TaskCD, viewModel: TaskListViewModel) {
            self.task = task
            self.viewModel = viewModel
            
            _title = State(initialValue: task.title ?? "")
            _dueDate = State(initialValue: task.dueDate ?? Date())
            _priority = State(initialValue: task.priority ?? "Medium")
            _category = State(initialValue: task.category ?? "Work")
            _isCompleted = State(initialValue: task.isCompleted)
        }
        
        var body: some View {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    Picker("Priority", selection: $priority) {
                        Text("High").tag("High")
                        Text("Medium").tag("Medium")
                        Text("Low").tag("Low")
                    }
                    Picker("Category", selection: $category) {
                        Text("Work").tag("Work")
                        Text("Personal").tag("Personal")
                        Text("Others").tag("Others")
                    }
                    Toggle(isOn: $isCompleted) {
                        Text("Completed")
                    }
                }
            }
            .navigationTitle("Task Details")
            .navigationBarItems(trailing: Button("Save") {
                task.title = title
                task.dueDate = dueDate
                task.priority = priority
                task.category = category
                task.isCompleted = isCompleted
                
                viewModel.updateTask(task: task)
            })
        }
}


