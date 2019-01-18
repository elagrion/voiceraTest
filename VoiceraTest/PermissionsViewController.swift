//
//  ViewController.swift
//  VoiceraTest
//
//  Created by Agapov Oleg on 1/17/19.
//  Copyright © 2019 Oleg Agapov. All rights reserved.
//

import UIKit
import EventKit

class PermissionsViewController: UIViewController {

    let model = PermissionsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true;
//    }

    @IBAction public func didTapRequestPemissionsButton() {
        model.requestCalendarPermissions() {[weak self] calendarResult in
            if calendarResult {
                self?.model.requestNotificationPermission() {[weak self] notificationResult in
                    if notificationResult {
                        self?.gotoEvents()
                    } else {
                        self?.showOpenSettingsAlert()
                    }
                }
            } else {
                self?.showOpenSettingsAlert()
            }
        }
    }

    func gotoEvents() {
        self.performSegue(withIdentifier: "calendarSegue", sender: self)
    }

    func showOpenSettingsAlert() {
        let alert = UIAlertController(title: "Ooops", message: "Access was denied, thats bad", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(settingsUrl)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }

    

}

