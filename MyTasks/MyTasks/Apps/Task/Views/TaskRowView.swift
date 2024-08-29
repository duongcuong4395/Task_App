//
//  TaskRowView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI

struct TaskRowView: View {
    @EnvironmentObject var viewModel: TaskListViewModel
    @EnvironmentObject var lnManager: LocalNotificationManager
    var task: TaskCD
    
    var body: some View {
        HStack {
            Button(action: {
                guard let id = task.id else { return }
                lnManager.removeRequest(with: "\(id)")
                
                deleteTask()
            }, label: {
                Image(systemName: "trash.fill")
                    .foregroundStyle(.red)
                    .font(.title3)
            })
            .padding(5)
            
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
                    .font(.title3)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .font(.title3)
            }
        }
        .padding(.vertical, 5)
    }
    
    func deleteTask() {
        viewModel.deleteTask(task: task)
    }
}

