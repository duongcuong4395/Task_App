//
//  TaskViewModel.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import Foundation
import CoreData
import Combine
import UserNotifications

@MainActor
class TaskListViewModel: ObservableObject {
    @Published var tasksCD: [TaskCD] = []
    @Published var taskDetail: TaskCD?
    @Published var page: Page = .ListTask
    private let context = CoreDataManager.shared.persistentContainer.viewContext
    @Published var draggedTask: TaskCD?
    
    var completedTasksCount: Int {
        tasksCD.filter { $0.isCompleted }.count
    }
    
    var pendingTasksCount: Int {
        tasksCD.filter { !$0.isCompleted }.count
    }
    
    func tasksCount(byPriority priority: String) -> Int {
        tasksCD.filter { $0.priority == priority }.count
    }
    
    func tasksOverTime() -> [(date: Date, count: Int)] {
        var taskCountByDate: [Date: Int] = [:]
        
        for task in tasksCD {
            let dueDate = Calendar.current.startOfDay(for: task.dueDate ?? Date())
            taskCountByDate[dueDate, default: 0] += 1
        }
        
        return taskCountByDate
            .sorted(by: { $0.key < $1.key })
            .map { (date: $0.key, count: $0.value) }
    }
    
    init() {
        fetchTasks()
    }
    
    //@MainActor
    func addTask(title: String, dueDate: Date?, priority: String, category: String, completion: @escaping (TaskCD) -> Void) {
        let newTask = TaskCD(context: context)
        newTask.id = UUID()
        newTask.title = title
        newTask.dueDate = dueDate
        newTask.priority = priority
        newTask.category = category
        newTask.isCompleted = false
        
        newTask.position = (tasksCD.last?.position ?? 0) + 1
        saveContext()
        fetchTasks()  
        completion(newTask)
        
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<TaskCD> = TaskCD.fetchRequest()
        //let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        DispatchQueue.main.async {
            do {
                
                self.tasksCD = try self.context.fetch(request)
                print("self.tasksCD", self.tasksCD)
                
            } catch {
                print("Failed to fetch tasks: \(error.localizedDescription)")
            }
        }
        
    }
    
    func updateTask(task: TaskCD, completion: @escaping (TaskCD) -> Void) {
        objectWillChange.send()
        saveContext()
        fetchTasks()
        completion(task)
    }
    
    func deleteTask(task: TaskCD) {
        /*
        if let subtasks = task.subtask as? Set<SubtaskCD> {
           for subtask in subtasks {
               context.delete(subtask)
           }
       }
        */
        context.delete(task)
        saveContext()
        fetchTasks()
    }
    
    private func saveContext() {
        CoreDataManager.shared.saveContext()
    }
    
    func updateTaskOrder() {
        for (index, task) in tasksCD.enumerated() {
            task.position = Int64(index)
        }
        saveContext()
    }
}


// MARK: - For Sub Task
extension TaskListViewModel {
    func addSubtask(to task: TaskCD, title: String, dueDate: Date?) {
        let newSubtask = SubtaskCD(context: context)
        newSubtask.id = UUID()
        newSubtask.title = title
        newSubtask.dueDate = dueDate
        newSubtask.isCompleted = false
        newSubtask.parentTask = task
        
        saveContext()
    }
    
    func deleteSubtask(_ subtask: SubtaskCD) {
        context.delete(subtask)
        saveContext()
    }
}
