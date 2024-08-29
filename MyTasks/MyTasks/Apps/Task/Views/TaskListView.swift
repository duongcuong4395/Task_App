//
//  TaskListView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI

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
        return filteredTasks//.sorted(by: { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) })
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
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(sortedTasks) { task in
                                TaskRowView(task: task)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            viewModel.taskDetail = task
                                            viewModel.page = .TaskDetail
                                        }
                                    }
                                    .padding(5)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
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
