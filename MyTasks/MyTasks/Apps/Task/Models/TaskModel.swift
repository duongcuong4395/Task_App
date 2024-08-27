//
//  TaskModel.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import Foundation


// Models/Task.swift
protocol Task {
    var id: UUID { get }
    var title: String { get set }
    var description: String? { get set }
    var dueDate: Date? { get set }
    var priority: TaskPriority { get set }
    var category: TaskCategory { get set }
    var subtasks: [Task]? { get set }
    var isCompleted: Bool { get set }
}

struct ConcreteTask: Task {
    var id = UUID()
    var title: String
    var description: String?
    var dueDate: Date?
    var priority: TaskPriority
    var category: TaskCategory
    var subtasks: [Task]?
    var isCompleted = false
}

// Enums/TaskPriority.swift
enum TaskPriority {
    case high, medium, low
}

// Enums/TaskCategory.swift
enum TaskCategory {
    case work, personal, others
}
