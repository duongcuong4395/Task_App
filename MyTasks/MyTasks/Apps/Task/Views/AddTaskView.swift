//
//  AddTaskView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI

struct AddTaskView: View {
    // MARK: - Properties
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: TaskListViewModel
    
    
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var priority: String = "Medium"
    @State private var category: String = "Work"
    
    @State private var showPermissionAlert: Bool = false
    @State private var showSettingsAlert: Bool = false
    
    // MARK: - Views
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    withAnimation {
                        viewModel.page = .ListTask
                    }
                }
                Spacer()
            }
            Form {
                Section(header: Text("Add Task")) {
                    TextField("Title", text: $title)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    Picker("Priority", selection: $priority) {
                        HStack {
                            Text("High")
                            AppShare.priorityIcon(priority: "High")
                           
                        }
                        .foregroundColor(AppShare.priorityColor(priority: "High"))
                        .tag("High")
                        HStack {
                            Text("Medium")
                            AppShare.priorityIcon(priority: "Medium")
                                
                        }
                        .foregroundColor(AppShare.priorityColor(priority: "Medium"))
                        .tag("Medium")
                        HStack {
                            Text("Low")
                            AppShare.priorityIcon(priority: "Low")
                                
                        }
                        .tag("Low")
                        .foregroundColor(AppShare.priorityColor(priority: "Low"))
                    }
                        .foregroundColor(AppShare.priorityColor(priority: priority))
                    Picker("Category", selection: $category) {
                        Text("Work").tag("Work")
                        Text("Personal").tag("Personal")
                        Text("Others").tag("Others")
                    }
                    
                    HStack {
                        
                        
                        Spacer()
                        Button("Save") {
                            withAnimation {
                                if title.isEmpty {
                                    return
                                }
                                
                                if lnManager.isGranted { } else {
                                    lnManager.openSettings()
                                }
                                
                                viewModel.addTask(title: title, dueDate: dueDate, priority: priority, category: category) { taskCD in
                                    
                                    guard let date = taskCD.dueDate
                                            , let id = taskCD.id else {
                                        return
                                    }
                                    
                                    let dataComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                                    
                                    let notificationModel = NotificationModel(id: "\(id)", title: "My Task", body: taskCD.title ?? "", datecomponents: dataComponent, repeats: false, moreData: ["" : ""])
                                    Task {
                                        await lnManager.schedule(by: notificationModel)
                                    }
                                }
                                viewModel.page = .ListTask
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $showPermissionAlert) {
                Alert(
                    title: Text("Notification Permission Required"),
                    message: Text("Please enable notifications to create a new task."),
                    primaryButton: .default(Text("Allow")) {
                        //requestNotificationPermission()
                    },
                    secondaryButton: .cancel {
                        //presentationMode.wrappedValue.dismiss()
                    }
                )
            }
            .alert(isPresented: $showSettingsAlert) {
               Alert(
                   title: Text("Notifications Disabled"),
                   message: Text("Please enable notifications in Settings to create a new task."),
                   primaryButton: .default(Text("Open Settings")) {
                       //openAppSettings()
                   },
                   secondaryButton: .cancel {
                       //presentationMode.wrappedValue.dismiss()
                   }
               )
           }
        }
        .onAppear{
            if lnManager.isGranted { } else {
                lnManager.openSettings()
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if lnManager.isGranted { } else {
                lnManager.openSettings()
            }
        }
    }
}

// MARK: - Events
extension AddTaskView {
        
    private func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
}
