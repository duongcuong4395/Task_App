//
//  TaskCD+CoreDataProperties.swift
//  MyTasks
//
//  Created by pc on 29/08/2024.
//
//

import Foundation
import CoreData


extension TaskCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCD> {
        return NSFetchRequest<TaskCD>(entityName: "TaskCD")
    }

    @NSManaged public var category: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var priority: String?
    @NSManaged public var title: String?
    @NSManaged public var position: Int64
    @NSManaged public var subtask: NSSet?

    // Convert NSSet to array
    public var subtaskArray: [SubtaskCD] {
       let set = subtask as? Set<SubtaskCD> ?? []
       return set.sorted { $0.dueDate ?? Date() < $1.dueDate ?? Date() }
    }
}

// MARK: Generated accessors for subtask
extension TaskCD {

    @objc(addSubtaskObject:)
    @NSManaged public func addToSubtask(_ value: SubtaskCD)

    @objc(removeSubtaskObject:)
    @NSManaged public func removeFromSubtask(_ value: SubtaskCD)

    @objc(addSubtask:)
    @NSManaged public func addToSubtask(_ values: NSSet)

    @objc(removeSubtask:)
    @NSManaged public func removeFromSubtask(_ values: NSSet)

}

extension TaskCD : Identifiable {

}
