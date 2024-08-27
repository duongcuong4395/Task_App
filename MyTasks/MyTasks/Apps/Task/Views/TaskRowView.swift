//
//  TaskRowView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI

struct TaskRowView: View {
    
    @EnvironmentObject var viewModel: TaskListViewModel
    var task: TaskCD
    
    var body: some View {
        HStack {
            Button(action: {
                deleteTask()
            }, label: {
                Image(systemName: "trash.fill")
                    .foregroundStyle(.red)
            })
            VStack(alignment: .leading) {
                Text(task.title ?? "No Title")
                    .font(.headline)
                HStack {
                    AppShare.priorityIcon(priority: task.priority ?? "Medium")
                        .foregroundColor(AppShare.priorityColor(priority: task.priority ?? "Medium"))
                    Text(task.priority ?? "Medium")
                        .font(.caption)
                    Spacer()
                }
                HStack {
                    Text(task.dueDate ?? Date(), style: .date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(task.dueDate ?? Date(), style: .time)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
            }
            Spacer()
            
            if task.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
    
    func deleteTask() {
        viewModel.deleteTask(task: task)
    }
}


extension TaskRowView {
    /*
    private func priorityColor(priority: String) -> Color {
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

    private func priorityIcon(priority: String) -> Image {
        switch priority {
        case "High":
            return Image(systemName: "exclamationmark.triangle.fill")
        case "Medium":
            return Image(systemName: "exclamationmark.circle.fill")
        case "Low":
            return Image(systemName: "info.circle.fill")
        default:
            return Image(systemName: "circle.fill")
        }
    }
    */
}
