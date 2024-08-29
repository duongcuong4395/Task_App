//
//  ContentView.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var lnManager = LocalNotificationManager()
    var body: some View {
        VStack {
            //TaskListView()
            ListTaskView()
        }
        .environmentObject(lnManager)
        .task {
            try? await lnManager.requestAuthorization()
        }
        .onChange(of: scenePhase, { oldValue, newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSetting()
                    await lnManager.getPendingRequests()
                }
            }
        })
    }
}
