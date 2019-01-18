//
//  CalendarTableViewController.swift
//  VoiceraTest
//
//  Created by Agapov Oleg on 1/17/19.
//  Copyright © 2019 Oleg Agapov. All rights reserved.
//

import UIKit
import EventKit

class CalendarTableViewController: UITableViewController, CalendarModelDelegate {

    let model = CalendarModel()

    lazy var dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .short
        return format
    }()

    override func viewDidLoad() {
        model.delegate = self
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.eventsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarReuseIdentifier", for: indexPath)

        if let event = model.getEvent(by: indexPath.row) {
            cell.textLabel?.text = event.title
            cell.detailTextLabel?.text = dateFormatter.string(from: event.startDate)
        }
        else {
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = nil
            _ = cell.startActivityIndicator()
        }
        return cell
    }


    func addNewEvents(_ events: [EKEvent], from index: Int) {
        //TODO: make it work with additions and updates [OA]
//        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
//        tableView.beginUpdates()
//        let starRange = index + 1
//        let endRange = events.count - 1
//        let indexPathes = Array(starRange...endRange).map { row in
//            return IndexPath.init(row: row, section: 0)
//        }
//        print("update: \(index) ... \(endRange);  pathes: \(indexPathes)")
//        tableView.insertRows(at: indexPathes, with: .automatic)
//        tableView.endUpdates()
        tableView.reloadData()
    }

    func needsReloadData() {
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let event = model.getEvent(by: indexPath.row) {
                    let controller = segue.destination as! EventViewController
                    controller.event = event
                }
            }
        }
    }


}

extension UIView {

    func startActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)])
        activityIndicator.startAnimating()
        return activityIndicator
    }

}
