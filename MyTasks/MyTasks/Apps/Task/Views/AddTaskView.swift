//
//  AddTaskView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI

struct AddTaskView: View {
    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: TaskListViewModel
    
    @ObservedObject var notificationManager = NotificationManager.shared
    
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
                                handleSaveAction()
                                //viewModel.addTask(title: title, dueDate: dueDate, priority: priority, category: category)
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
                        requestNotificationPermission()
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
                       openAppSettings()
                   },
                   secondaryButton: .cancel {
                       //presentationMode.wrappedValue.dismiss()
                   }
               )
           }
        }
        .onAppear {
            checkNotificationPermission()
        }
    }
}

// MARK: - Events
extension AddTaskView {
    private func handleSaveAction() {
        switch notificationManager.authorizationStatus {
        case .authorized:
            viewModel.addTask(title: title, dueDate: dueDate, priority: priority, category: category)
            //presentationMode.wrappedValue.dismiss()
        case .notDetermined:
            showPermissionAlert = true
        case .denied:
            showSettingsAlert = true
        default:
            showSettingsAlert = true
        }
        
        //viewModel.addTask(title: title, dueDate: dueDate, priority: priority, category: category)
        //presentationMode.wrappedValue.dismiss()
    }
    
    private func checkNotificationPermission() {
       notificationManager.refreshAuthorizationStatus()
       if notificationManager.authorizationStatus == .denied {
           showSettingsAlert = true
       } else if notificationManager.authorizationStatus == .notDetermined {
           showPermissionAlert = true
       }
    }
    
    private func requestNotificationPermission() {
        notificationManager.requestAuthorization { granted in
            if granted {
                //viewModel.addTask(title: title, dueDate: dueDate, priority: priority, category: category)
                presentationMode.wrappedValue.dismiss()
            } else {
                showSettingsAlert = true
            }
        }
    }
        
    private func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
}
