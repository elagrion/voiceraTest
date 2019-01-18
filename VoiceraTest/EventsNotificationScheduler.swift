//
//  EventsNotificationScheduler.swift
//  VoiceraTest
//
//  Created by Agapov Oleg on 1/18/19.
//  Copyright © 2019 Oleg Agapov. All rights reserved.
//

import Foundation
import UserNotifications
import EventKit

class EventsNotificationScheduler {

    public static let shared = EventsNotificationScheduler()

    public func addNotification(for event: EKEvent) {
        guard checkDate(event.startDate) else {
            print("Do not schedule events week after")
            return
        }
        guard checkAttendees(event) else {
            print("Do not schedule events when no non-gmail participant")
            return
        }
        let notificationCenter = UNUserNotificationCenter.current()
        let content = self.createNotificationConent(for: event)
        let trigger = self.createTrigger(for: event)
        let request = UNNotificationRequest(identifier: event.eventIdentifier, content: content, trigger: trigger)
        notificationCenter.add(request)
        print("Scheduled for event: \(String(describing: event.title))")
    }

    public func removeNotification(for event: EKEvent) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.eventIdentifier])
    }

    func createNotificationConent(for event:EKEvent) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.body = "Your events starts now"
        content.sound = UNNotificationSound.default
        content.userInfo = ["eventId": event.eventIdentifier]
        return content
    }

    func createTrigger(for event:EKEvent) -> UNNotificationTrigger {
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,], from: event.startDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        return trigger
    }

    func checkDate(_ date: Date) -> Bool {
        return date.compare(Date().sevenDaysAfter) == .orderedAscending
    }

    func checkAttendees(_ event: EKEvent) -> Bool {

        let attendees = event.attendees.flatMap({ (attendee: [EKParticipant]) in
            return attendee.map({ (attendee:EKParticipant) in
                attendee.url.absoluteString
            })
        })
        let count = attendees?.filter({ (string) -> Bool in
            return !string.contains("gmail")
        }).count
        return count != nil && count! > 0
    }

    func startListeningUpdates() {
        
    }

}
