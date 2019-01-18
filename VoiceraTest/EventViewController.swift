//
//  EventViewController.swift
//  VoiceraTest
//
//  Created by Agapov Oleg on 1/18/19.
//  Copyright © 2019 Oleg Agapov. All rights reserved.
//

import UIKit
import EventKit

class EventViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var attendiesLabel: UILabel!

    var event: EKEvent?

    lazy var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .short
        return format
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    public func setup() {
        guard let event = event else {
            return
        }
        titleLabel.text = event.title
        locationLabel.text = event.location
        startDateLabel.text = dateFormatter.string(from: event.startDate)
        endDateLabel.text = dateFormatter.string(from: event.endDate)
        let attendees = event.attendees.flatMap({ (attendee: [EKParticipant]) in
            return attendee.map({ (attendee:EKParticipant) in
                attendee.url.absoluteString
            })
        })
        attendiesLabel.text = attendees?.joined(separator: ", ")
    }

    @IBAction func didTapRemoveNotification() {
        guard let event = event else {
            return
        }
        EventsNotificationScheduler.shared.removeNotification(for: event)
    }

}
