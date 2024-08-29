//
//  SubtaskCD+CoreDataProperties.swift
//  MyTasks
//
//  Created by pc on 29/08/2024.
//
//

import Foundation
import CoreData


extension SubtaskCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubtaskCD> {
        return NSFetchRequest<SubtaskCD>(entityName: "SubtaskCD")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var dueDate: Date?
    @NSManaged public var priority: String?
    @NSManaged public var parentTask: TaskCD?

}

extension SubtaskCD : Identifiable {

}
