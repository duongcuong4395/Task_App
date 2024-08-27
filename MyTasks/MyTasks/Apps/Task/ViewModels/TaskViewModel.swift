//
//  TaskViewModel.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import Foundation
import CoreData

import UserNotifications

class TaskListViewModel: ObservableObject {
    @Published var tasksCD: [TaskCD] = []
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    private let notificationManager = NotificationManager.shared
            
    init() {
        fetchTasks()
    }
    
    func addTask(title: String, dueDate: Date?, priority: String, category: String) {
        let newTask = TaskCD(context: context)
        newTask.id = UUID()
        newTask.title = title
        newTask.dueDate = dueDate
        newTask.priority = priority
        newTask.category = category
        newTask.isCompleted = false
        
        saveContext()
        fetchTasks()  
        
        if let id = newTask.id?.uuidString, let dueDate = dueDate {
            notificationManager.scheduleNotification(id: id, title: title, body: "Your task is due!", date: dueDate)
        }
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<TaskCD> = TaskCD.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            tasksCD = try context.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
        }
    }
    
    func updateTask(task: TaskCD) {
        saveContext()
        fetchTasks()
        
        if let id = task.id?.uuidString, let dueDate = task.dueDate {
            notificationManager.removeNotification(id: id)
            notificationManager.scheduleNotification(id: id, title: task.title ?? "No Title", body: "Your task is due!", date: dueDate)
        }
    }
    
    func deleteTask(task: TaskCD) {
        
        if let id = task.id?.uuidString {
           notificationManager.removeNotification(id: id)
        }
        
        context.delete(task)
        saveContext()
        fetchTasks()
    }
    
    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }
}
