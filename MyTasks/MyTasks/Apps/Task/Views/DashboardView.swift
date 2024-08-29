//
//  DashboardView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var viewModel: TaskListViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.page = .ListTask
                    }
                }) {
                    Label("Back", systemImage: "chevron.left")
                }
                Spacer()
                Text("Dashboard")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            .padding(0)
            
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Biểu đồ tròn cho Completed vs Pending Tasks
                    Section("Completed vs Pending Tasks") {
                        PieChartView(
                            data: [
                                PieChartDataEntry(value: Double(viewModel.completedTasksCount), label: "Completed"),
                                PieChartDataEntry(value: Double(viewModel.pendingTasksCount), label: "Pending")
                            ],
                            label: "Completion Status"
                        )
                        .frame(height: 300)
                        .padding()
                    }
                    
                    
                    Divider()
                    Section("High vs Medium vs Low") {
                        BarChartView(
                            data: [
                                BarChartDataEntry(x: 0, y: Double(viewModel.tasksCount(byPriority: "High"))),
                                BarChartDataEntry(x: 1, y: Double(viewModel.tasksCount(byPriority: "Medium"))),
                                BarChartDataEntry(x: 2, y: Double(viewModel.tasksCount(byPriority: "Low")))
                            ],
                            labels: ["High", "Medium", "Low"],
                            title: "Tasks by Priority"
                        )
                        .frame(height: 300)
                        .padding()
                    }
                    
                    
                    Divider()
                    Section("Tasks Over Time") {
                        LineChartView(
                            data: viewModel.tasksOverTime(),
                            title: "Tasks Over Time"
                        )
                        .frame(height: 300)
                        .padding()
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle("Dashboard")
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Dashboard")
    }
}

struct BarChartView: View {
    let data: [BarChartDataEntry]
    let labels: [String]
    let title: String
    
    var body: some View {
        Chart {
            ForEach(data.indices, id: \.self) { index in
                BarMark(
                    x: .value("Priority", labels[index]),
                    y: .value("Tasks", data[index].y)
                )
                .foregroundStyle(by: .value("Priority", labels[index]))
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: labels.count))
        }
        .chartYScale(domain: 0...data.map(\.y).max()!)
        .frame(height: 300)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .navigationTitle(title)
    }
}

struct PieChartView: View {
    let data: [PieChartDataEntry]
    let label: String
    
    var body: some View {
        Chart(data) { slice in
            SectorMark(
                angle: .value("Value", slice.value),
                innerRadius: .ratio(0.5),
                outerRadius: .ratio(1)
            )
            .foregroundStyle(by: .value("Label", slice.label ?? ""))
        }
        .frame(height: 300)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .navigationTitle(label)
    }
}

struct LineChartView: View {
    let data: [(date: Date, count: Int)]
    let title: String
    
    var body: some View {
        Chart {
            ForEach(data.indices, id: \.self) { index in
                let entry = data[index]
                LineMark(
                    x: .value("Date", entry.date, unit: .day),
                    y: .value("Tasks", entry.count)
                )
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day))
        }
        .chartYAxis {
            AxisMarks()
        }
        .frame(height: 300)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .navigationTitle(title)
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct PieChartDataEntry: Identifiable {
    var id = UUID()
    let value: Double
    let label: String?
}


struct BarChartDataEntry: Identifiable {
    var id = UUID()
    let x: Double
    let y: Double
}
