//
//  NotificationManager.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import Foundation
import UserNotifications
import NotificationCenter

struct NotificationModel {
    var id: String
    var title: String
    var body: String
    var subTitle: String?
    var timeInterval: Double?
    var datecomponents: DateComponents?
    var moreData: [AnyHashable: Any]
    var repeats: Bool
    
    //var model
    
    enum ScheduleType {
        case time, calendar
    }
    
    var scheduleType: ScheduleType
    
    internal init(id: String, title: String, body: String
         , timeInterval: Double
         , repeats: Bool
         , moreData: [AnyHashable: Any]) {
        self.id = id
        self.title = title
        self.body = body
        self .scheduleType = .time
        self.timeInterval = timeInterval
        self.datecomponents = nil
        self.repeats = repeats
        self.moreData = moreData
    }
    
    init(id: String, title: String, body: String
         , datecomponents: DateComponents
         , repeats: Bool
         , moreData: [AnyHashable: Any]) {
        self.id = id
        self.title = title
        self.body = body
        self.timeInterval = nil
        self .scheduleType = .calendar
        self.datecomponents = datecomponents
        self.repeats = repeats
        self.moreData = moreData
    }
}

@MainActor
class LocalNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    let notifyCenter = UNUserNotificationCenter.current()
    @Published var isGranted: Bool = false
    @Published var pendingRequests: [UNNotificationRequest] = []
    
    override init() {
        super.init()
        notifyCenter.delegate = self
    }
    
    func requestAuthorization() async throws {
        try await notifyCenter
            .requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSetting()
    }
    
    func getCurrentSetting() async {
        let currentSetting = await notifyCenter.notificationSettings()
        isGranted = (currentSetting.authorizationStatus == .authorized)
        //print("getCurrentSetting.isGranted:", isGranted)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    
}


// MARK: - Events
extension LocalNotificationManager {
    
    
    func schedule(by data: NotificationModel) async {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.body = data.body
        content.sound = .default
        content.userInfo = data.moreData
        
        if let subTitle = data.subTitle {
            content.subtitle = subTitle
        }
        
        if data.scheduleType == .time {
            guard let timeInterval = data.timeInterval else { return }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval
                                                            , repeats: data.repeats)
            let request = UNNotificationRequest(identifier: data.id
                                                , content: content
                                                , trigger: trigger)
            try? await notifyCenter.add(request)
        } else {
            guard let datecomponents = data.datecomponents else { return }
            let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: data.repeats)
            let request = UNNotificationRequest(identifier: data.id
                                                , content: content
                                                , trigger: trigger)
            try? await notifyCenter.add(request)
        }
        
        
        
        await getPendingRequests()
    }
    
    func getPendingRequests() async {
        pendingRequests = await notifyCenter.pendingNotificationRequests()
        print("pendingRequests:", pendingRequests.count)
    }
    
    func removeRequest(with id: String) {
        notifyCenter.removePendingNotificationRequests(withIdentifiers: [id])
        
        
        if let index = pendingRequests.firstIndex(where: { $0.identifier == id }) {
            pendingRequests.remove(at: index)
            print("pendingRequests:", pendingRequests.count)
        }
    }
    
    func clearRequests() {
        notifyCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll()
    }
}


// MARK: - For Delegate
extension LocalNotificationManager {
    
    // run notify in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter
                                , willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound, .banner]
    }
}
