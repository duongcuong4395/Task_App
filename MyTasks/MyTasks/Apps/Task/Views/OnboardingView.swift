//
//  OnboardingView.swift
//  MyTasks
//
//  Created by pc on 29/08/2024.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isFirstLaunch: Bool

    @State private var currentPage = 0

    var pages = [
        OnboardingPage(title: "Welcome to My Task", description: "Easily manage your tasks and stay organized.", imageName: "checkmark.circle"),
        OnboardingPage(title: "Dashboard", description: "View your task statistics and progress.", imageName: "chart.line.uptrend.xyaxis.circle"),
        OnboardingPage(title: "Add Tasks", description: "Quickly add new tasks and set due dates.", imageName: "plus.circle"),
        OnboardingPage(title: "magnifyingglass.circle", description: "Filter tasks by category to focus on what's important.", imageName: "slider.horizontal.3")
    ]
    
    /*
    var sortedTasks: [TaskCD] {
        var tasks: [TaskCD] = []
        
        var task = TaskCD(context: CoreDataManager.shared.persistentContainer.viewContext)
        task.id = UUID()
        task.title = "Task 1"
        task.dueDate = Date()
        task
        var subtasks: [SubtaskCD] = []
        let newSubtask = SubtaskCD(context: CoreDataManager.shared.persistentContainer.viewContext)
        newSubtask.id = UUID()
        newSubtask.title = "sub task 1"
        subtasks.append(newSubtask)
        
        return viewModel.tasksCD
    }
    */

    var body: some View {
        ZStack {
            /*
            VStack {
                HStack {
                    Button(action: {
                    }) {
                        Label("Dashboard", systemImage: "chart.line.uptrend.xyaxis.circle")
                    }
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Label("Add Task", systemImage: "plus.circle")
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(sortedTasks) { task in
                            TaskRowView(task: task)
                                .padding(5)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            */
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count) { index in
                        VStack {
                            Image(systemName: pages[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .padding(.top, 50)
                            
                            Text(pages[index].title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.top, 50)
                            
                            Text(pages[index].description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                HStack {
                    Button("Skip") {
                        withAnimation {
                            isFirstLaunch = false
                        }
                    }
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Next") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    } else {
                        Button("Get Started") {
                            withAnimation {
                                isFirstLaunch = false
                            }
                        }
                    }
                }
                .padding()
            }
        }
        
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}
