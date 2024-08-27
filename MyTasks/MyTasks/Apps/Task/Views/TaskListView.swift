//
//  TaskListView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI
/*
struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel()
    
    @State private var isShowingAddTaskView = false
    @State private var selectedCategory: String = "All"
    
    var sortedTasks: [TaskCD] {
        let filteredTasks = viewModel.tasksCD.filter { task in
            selectedCategory == "All" || task.category == selectedCategory
        }
        return filteredTasks.sorted(by: { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) })
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
                    ForEach(viewModel.tasksCD) { task in
                        NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                            TaskRowView(task: task)
                        }
                        .onDelete(perform: deleteTask)
                    }
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
        .task {
            print("TaskListView.task")
        }
        .onAppear{
            print("TaskListView.onAppear")
        }
        .onChange(of: viewModel.tasksCD) { vl, newVL in
            print("TaskListView.onChange.tasksCD")
        }
        .environmentObject(viewModel)
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.map { viewModel.tasksCD[$0] }.forEach(viewModel.deleteTask)
    }
    
}
*/

enum Page {
    case ListTask
    case TaskDetail
    case AddTask
    case Dashboard
}

struct ListTaskView: View {
    @StateObject private var viewModel = TaskListViewModel()
    
    @State private var isShowingAddTaskView = false
    @State private var selectedCategory: String = "All"
    
    var sortedTasks: [TaskCD] {
        let filteredTasks = viewModel.tasksCD.filter { task in
            selectedCategory == "All" || task.category == selectedCategory
        }
        return filteredTasks.sorted(by: { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) })
    }
    
    var body: some View {
        VStack {
            
            switch viewModel.page {
            case .ListTask:
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                viewModel.page = .Dashboard
                            }
                        }) {
                            Label("Dashboard", systemImage: "list.dash.header.rectangle")
                        }
                        Spacer()
                        Button(action: {
                            withAnimation {
                                viewModel.page = .AddTask
                            }
                        }) {
                            Label("Add Task", systemImage: "plus")
                        }
                    }
                    Picker("Category", selection: $selectedCategory) {
                        Text("All").tag("All")
                        Text("Work").tag("Work")
                        Text("Personal").tag("Personal")
                        Text("Others").tag("Others")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    //.padding()
                    ScrollView(showsIndicators: false) {
                        ForEach(sortedTasks) { task in
                            TaskRowView(task: task)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.taskDetail = task
                                        viewModel.page = .TaskDetail
                                    }
                                    
                                }
                                
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            case .TaskDetail:
                if let task = viewModel.taskDetail {
                    TaskDetailView(task: task)
                        .padding()
                }
                
            case .AddTask:
                AddTaskView()
                    .padding()
            case .Dashboard:
                DashboardView()
            }
        }
        .environmentObject(viewModel)
    }
    
    private func deleteTask(at offsets: IndexSet) {
        offsets.map { viewModel.tasksCD[$0] }.forEach(viewModel.deleteTask)
    }
}
