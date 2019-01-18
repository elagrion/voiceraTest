//
//  CalendarModel.swift
//  VoiceraTest
//
//  Created by Agapov Oleg on 1/17/19.
//  Copyright © 2019 Oleg Agapov. All rights reserved.
//

import Foundation
import EventKit

protocol CalendarModelDelegate: class {
    func addNewEvents(_ events: [EKEvent], from index: Int)
    func needsReloadData()
}

class CalendarModel {
    let store = EKEventStore()
    let dataFetchQueue = DispatchQueue(label: "calendarFetch", qos: .userInteractive)

    var fetchedEvents: [EKEvent] = []

    public weak var delegate: CalendarModelDelegate?

    var lastFetchedDate = Date().dayBefore

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public var eventsCount: Int {
        get {
            return fetchedEvents.count + 1
        }
    }

    public func getEvent(by index:Int) -> EKEvent? {
        if (index < fetchedEvents.count) {
            return fetchedEvents[index]
        } else {
            fetchNextEventsBatch()
            return nil
        }
    }

    public func startListeningUpdates() {
        NotificationCenter.default.addObserver(self, selector: Selector("storeChanged:"), name: .EKEventStoreChanged, object: store)
    }

    func fetchNextEventsBatch() {
        let startDate = lastFetchedDate.dayAfter
        let finishDate = startDate.sevenDaysAfter
        requestData(from: startDate, to: finishDate) { [weak self] events in
            guard let self = self else {
                return
            }
            guard events.count > 0 else {
                self.fetchNextEventsBatch()
                return
            }
            let index = self.fetchedEvents.count
            self.fetchedEvents.append(contentsOf: events)
            self.delegate?.addNewEvents(events, from: index)
            for event in events {
                EventsNotificationScheduler.shared.addNotification(for: event)
            }
        }
        lastFetchedDate = finishDate
    }

    func requestData(from startDate:Date, to finishDate: Date, completion: @escaping ([EKEvent])->(Void)) {
        dataFetchQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            let calendars = self.store.calendars(for: .event)
            let predicate = self.store.predicateForEvents(withStart: startDate, end: finishDate, calendars: calendars)
            let events = self.store.events(matching: predicate)
            DispatchQueue.main.async {
                completion(events)
            }
        }
    }

    @objc
    func storeChanged(notification: NSNotification) {
        self.delegate?.needsReloadData()
    }
    

}

extension Date {

    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: midnight)!
    }

    var sevenDaysAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 7, to: midnight)!
    }

    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}
