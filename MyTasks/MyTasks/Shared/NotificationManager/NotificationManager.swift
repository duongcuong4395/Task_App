//
//  NotificationManager.swift
//  MyTasks
//
//  Created by pc on 27/08/2024.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager: NSObject, ObservableObject  {
    static let shared = NotificationManager()

    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        refreshAuthorizationStatus()
    }
    
}

extension NotificationManager {
    func refreshAuthorizationStatus() {
       UNUserNotificationCenter.current().getNotificationSettings { settings in
           DispatchQueue.main.async {
               self.authorizationStatus = settings.authorizationStatus
           }
       }
   }
   
   // Yêu cầu quyền thông báo từ người dùng
   func requestAuthorization(completion: @escaping (Bool) -> Void) {
       UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
           DispatchQueue.main.async {
               self.refreshAuthorizationStatus()
               completion(granted)
           }
           if let error = error {
               print("Error requesting notification authorization: \(error.localizedDescription)")
           }
       }
   }
}

extension NotificationManager {
    func scheduleNotification(id: String, title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func removeNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    func removeNotification(byTitle title: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let matchingRequests = requests.filter { $0.content.title == title }
            let identifiers = matchingRequests.map { $0.identifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func showNotificationNow(id: String, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error)")
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    // Handle notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // Handle notification response when the app is opened via the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification tap event here
        print("Notification tapped: \(response.notification.request.identifier)")
        completionHandler()
    }
}
