//
//  SubscriptionsListViewController.swift
//  Push Notifications Test
//
//  Created by Neura on 7/13/16.
//  Copyright © 2016 Neura. All rights reserved.
//

import Foundation
import UIKit
import NeuraSDK

class SubscriptionsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    let neuraSDK = NeuraSDK.shared
    // Declare the permissions you'll want to request here. These can be found in the app wizard in the developer console at the bottom of the page.
    // They should correspond to the permissions group that you've declared in the authenticate with permissions function elsewhere (in the main view controller in this case)
    var eventNamesArray = [
        "userArrivedHome",
        "userArrivedHomeFromWork",
        "userLeftHome",
        "userArrivedHomeByWalking",
        "userArrivedHomeByRunning",
        "userIsOnTheWayHome",
        "userIsIdleAtHome",
        "userStartedWorkOut",
        "userFinishedRunning",
        "userFinishedWorkOut",
        "userLeftGym",
        "userFinishedWalking",
        "userArrivedToGym",
        "userIsIdleFor2Hours",
        "userStartedWalking",
        "userIsIdleFor1Hour",
        "userStartedRunningFromPlace",
        "userStartedTransitByWalking",
        "userStartedRunning",
        "userFinishedTransitByWalking"
    ]
    var subscriptions = [String: NSubscription]()
    let cellReuseIdentifier = "SuscriptionsListViewCell"
    
    //MARK: IBOutlets
    @IBOutlet weak var subscriptionsTableView: UITableView!
    
    //MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptionsTableView.delegate = self
        subscriptionsTableView.dataSource = self
        reloadAllData()
    }
    
    func reloadAllData() {
        self.subscriptions.removeAll()
       // Get a list of current subscriptions
        neuraSDK.getSubscriptionsList() { result in
            guard result.success else { return }
            for subscription in result.subscriptions {
                self.subscriptions[subscription.eventName] = subscription
            }
            self.subscriptionsTableView.reloadData()
        }
    }
    
    //MARK: Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventNamesArray.count
    }
    
    //Create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SubscriptionsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SubscriptionsTableViewCell
        
        // Configure the cell.
        let eventName = self.eventNamesArray[indexPath.item]
        cell.subscriptionName?.text = eventName
        cell.subscribeSwitch.isUserInteractionEnabled = false
        
        if let _ = self.subscriptions[eventName] {
            cell.subscribeSwitch.isOn = true
        } else {
            cell.subscribeSwitch.isOn = false
        }
        
        return cell
    }
    
    
   

    func subscribeToEvent(_ eventName: String) {
        let identifier = "\(NeuraSDK.shared.neuraUserId()!)_\(eventName)"
        let nSubscription = NSubscription(evenName: eventName, forPushWithIdentifier: identifier)//NSubscription(eventName: eventName, webhookId: identifier)
        neuraSDK.add(nSubscription)  { result in
            if result.error != nil {
                let alertController = UIAlertController(title: "Error", message: result.errorString, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            self.reloadAllData()
        }
    }

    func removeSubscriptionWithEventName(_ eventName: String){
        let identifier = (eventName) + "_" + (NeuraSDK.shared.neuraUserId()!)
        let nSubscription = NSubscription(evenName: eventName, forPushWithIdentifier: identifier)
        neuraSDK.remove(nSubscription) { result in
            if result.error != nil {
                let alertController = UIAlertController(title: "Error", message: result.errorString, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            self.reloadAllData()
        }
    }
    
    //MARK: IBActions
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
