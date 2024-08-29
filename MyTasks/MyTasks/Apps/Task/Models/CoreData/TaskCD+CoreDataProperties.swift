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

}

extension TaskCD : Identifiable {

}
