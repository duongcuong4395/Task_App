//
//  TaskDetailView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var viewModel: TaskListViewModel
    
    @State private var title: String
    @State private var dueDate: Date
    @State private var priority: String
    @State private var category: String
    @State private var isCompleted: Bool
    
    var task: TaskCD
    
    init(task: TaskCD) {
        self.task = task
        //self.viewModel = viewModel
        
        _title = State(initialValue: task.title ?? "")
        _dueDate = State(initialValue: task.dueDate ?? Date())
        _priority = State(initialValue: task.priority ?? "Medium")
        _category = State(initialValue: task.category ?? "Work")
        _isCompleted = State(initialValue: task.isCompleted)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    withAnimation {
                        viewModel.page = .ListTask
                    }
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        viewModel.deleteTask(task: task)
                        viewModel.page = .ListTask
                    }
                }, label: {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.red)
                })
            }
            Form {
                Section(header: Text("Task Detail")) {
                    TextField("Title", text: $title)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    Picker("Priority", selection: $priority) {
                        
                        
                        
                        HStack {
                            Text("High")
                            AppShare.priorityIcon(priority: "High")
                                .foregroundColor(AppShare.priorityColor(priority: "High"))
                        }
                        .tag("High")
                        HStack {
                            Text("Medium")
                            AppShare.priorityIcon(priority: "Medium")
                                .foregroundColor(AppShare.priorityColor(priority: "Medium"))
                        }
                        .tag("Medium")
                        HStack {
                            Text("Low")
                            AppShare.priorityIcon(priority: "Low")
                                .foregroundColor(AppShare.priorityColor(priority: "Low"))
                        }
                        .tag("Low")
                    }
                        .foregroundColor(AppShare.priorityColor(priority: priority))
                    Picker("Category", selection: $category) {
                        Text("Work").tag("Work")
                        Text("Personal").tag("Personal")
                        Text("Others").tag("Others")
                    }
                    Toggle(isOn: $isCompleted) {
                        Text("Completed")
                    }
                    HStack {
                        
                        Spacer()
                        Button("Save") {
                            withAnimation {
                                
                                if title.isEmpty {
                                    return
                                }
                                task.title = title
                                task.dueDate = dueDate
                                task.priority = priority
                                task.category = category
                                task.isCompleted = isCompleted
                                
                                viewModel.updateTask(task: task)
                                viewModel.page = .ListTask
                            }
                        }
                    }
                }
                .ignoresSafeArea(.all)
            }
        }
    }
}
