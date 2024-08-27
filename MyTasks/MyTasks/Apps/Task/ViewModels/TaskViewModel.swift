//
//  TaskViewModel.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import Foundation
import CoreData

class TaskListViewModel: ObservableObject {
    @Published var tasksCD: [TaskCD] = []
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    
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
        fetchTasks()  // Refresh the task list
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
    }
    
    func deleteTask(task: TaskCD) {
        context.delete(task)
        saveContext()
        fetchTasks()
    }
    
    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }
}
