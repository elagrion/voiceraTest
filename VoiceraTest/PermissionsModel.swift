//
//  PermissionsModel.swift
//  VoiceraTest
//
//  Created by Agapov Oleg on 1/17/19.
//  Copyright © 2019 Oleg Agapov. All rights reserved.
//

import EventKit
import UserNotifications

class PermissionsModel {

    let store = EKEventStore()

    func requestCalendarPermissions(completion: @escaping (Bool)->(Void)) {
        self.store.requestAccess(to: .event) { (result, error) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func requestNotificationPermission(completion: @escaping (Bool)->(Void)) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {
            (result, error) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

}
