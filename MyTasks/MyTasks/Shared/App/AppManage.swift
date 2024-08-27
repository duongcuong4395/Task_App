//
//  AppManage.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import Foundation
import SwiftUI

class AppShare {
    static func priorityColor(priority: String) -> Color {
        switch priority {
        case "High":
            return .red
        case "Medium":
            return .orange
        case "Low":
            return .blue
        default:
            return .gray
        }
    }

    static func priorityIcon(priority: String) -> Image {
        switch priority {
        case "High":
            return Image(systemName: "gauge.high")
        case "Medium":
            return Image(systemName: "gauge.medium")
        case "Low":
            return Image(systemName: "gauge.low")
        default:
            return Image(systemName: "gauge.low")
        }
    }
}
