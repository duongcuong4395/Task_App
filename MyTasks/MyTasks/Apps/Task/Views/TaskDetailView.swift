//
//  TaskDetailView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var viewModel: TaskListViewModel
    @EnvironmentObject var lnManager: LocalNotificationManager
    @StateObject var hapticsManager = HapticsManager()
    @State private var title: String
    @State private var dueDate: Date
    @State private var priority: String
    @State private var category: String
    @State private var isCompleted: Bool
    @State private var showingDatePicker = false
    
    @State private var subtasks: [SubtaskCD]
    @State private var subtaskTitle: String = ""
    
    var task: TaskCD
    
    init(task: TaskCD) {
        self.task = task
        //self.viewModel = viewModel
        
        _title = State(initialValue: task.title ?? "")
        _dueDate = State(initialValue: task.dueDate ?? Date())
        _priority = State(initialValue: task.priority ?? "Medium")
        _category = State(initialValue: task.category ?? "Work")
        _isCompleted = State(initialValue: task.isCompleted)
        _subtasks = State(initialValue: task.subtaskArray)
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
                        guard let id = task.id else { return }
                        lnManager.removeRequest(with: "\(id)")
                        
                        viewModel.deleteTask(task: task)
                        viewModel.page = .ListTask
                        hapticsManager.errorHaptic()
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
                    
                    /*
                    HStack {
                        
                        Spacer()
                        Button("Save") {
                            withAnimation {
                                
                                if title.isEmpty { return }
                                
                                if lnManager.isGranted { } else {
                                    lnManager.openSettings()
                                }
                                task.title = title
                                task.dueDate = dueDate
                                task.priority = priority
                                task.category = category
                                task.isCompleted = isCompleted
                                
                                viewModel.updateTask(task: task) { taskCD in
                                    guard let id = taskCD.id else { return }
                                    
                                    lnManager.removeRequest(with: "\(id)")
                                    
                                    let date = dueDate
                                    
                                    let dataComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                                    
                                    let notificationModel = NotificationModel(id: "\(id)", title: "My Task", body: taskCD.title ?? "", datecomponents: dataComponent, repeats: false, moreData: ["" : ""])
                                    Task {
                                        await lnManager.schedule(by: notificationModel)
                                    }
                                    hapticsManager.warningHaptic()
                                }
                                viewModel.page = .ListTask
                            }
                        }
                    }
                    */
                }
                
                // Section for managing Subtasks
                Section(header: Text("Subtasks")) {
                    TextField("Subtask Title", text: $subtaskTitle)
                    Button(action: {
                        addSubtask()
                    }) {
                        Label("Add Subtask", systemImage: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                    
                    ForEach(subtasks, id: \.id) { subtask in
                        HStack {
                            Text(subtask.title ?? "Untitled Subtask")
                            Spacer()
                            Button(action: {
                                deleteSubtask(subtask)
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button("Save") {
                        withAnimation {
                            if title.isEmpty { return }
                            
                            if lnManager.isGranted {
                                saveTask()
                            } else {
                                lnManager.openSettings()
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            CustomDatePicker(selectedDate: $dueDate)
        }
    }
}

extension TaskDetailView {
    // MARK: - Subtask Management
    private func addSubtask() {
        if !subtaskTitle.isEmpty {
            let newSubtask = SubtaskCD(context: CoreDataManager.shared.persistentContainer.viewContext)
            newSubtask.id = UUID()
            newSubtask.title = subtaskTitle
            subtasks.append(newSubtask)
            subtaskTitle = ""
        }
    }

    private func deleteSubtask(_ subtask: SubtaskCD) {
        if let index = subtasks.firstIndex(where: { $0.id == subtask.id }) {
            subtasks.remove(at: index)
        }
    }

    // MARK: - Task Management
    private func saveTask() {
        task.title = title
        task.dueDate = dueDate
        task.priority = priority
        task.category = category
        task.isCompleted = isCompleted

        // Gán subtasks vào task
        task.subtask = NSSet(array: subtasks)

        viewModel.updateTask(task: task) { taskCD in
            guard let id = taskCD.id else { return }

            lnManager.removeRequest(with: "\(id)")

            let date = dueDate

            let dataComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)

            let notificationModel = NotificationModel(id: "\(id)", title: "My Task", body: taskCD.title ?? "", datecomponents: dataComponent, repeats: false, moreData: ["" : ""])
            Task {
                await lnManager.schedule(by: notificationModel)
            }
            hapticsManager.warningHaptic()
        }
        viewModel.page = .ListTask
    }
}


struct CustomDatePicker: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())  // Sử dụng DatePicker kiểu Graphical
                .labelsHidden()  // Ẩn nhãn để chỉ hiển thị lịch
            Button("Done") {
                // Đóng DatePicker khi người dùng nhấn "Done"
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            .padding()
        }
        .padding()
    }
}
