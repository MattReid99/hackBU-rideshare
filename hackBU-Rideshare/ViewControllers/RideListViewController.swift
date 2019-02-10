//
//  RideListViewController.swift
//  hackBU-Rideshare
//
//  Created by Matthew Reid on 2/10/19.
//  Copyright © 2019 Matthew Reid. All rights reserved.
//

import UIKit
import Alamofire

class RideListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myAccBtn: UIButton!
    @IBOutlet weak var rideCompletedBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    
    @IBOutlet weak var tableView : UITableView!
    
    var queuedRiders = [RideRequest]()
    var riderName : String?
    var selectedRow : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myAccBtn.layer.cornerRadius = 10.0
        rideCompletedBtn.layer.cornerRadius = 16.0
        myAccBtn.layer.borderColor = rideCompletedBtn.backgroundColor?.cgColor
        myAccBtn.layer.borderWidth = 2.0
        
        tableView.dataSource = self
        tableView.delegate = self
        retrieveRequests()
        
        // Do any additional setup after loading the view.
    }
    
    func retrieveRequests() {
        
        queuedRiders.removeAll()
        
        Alamofire.request("\(Globals.webURL)retrieveQueuedRiders.php", method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                print(response)
                
                if let result = response.result.value {
                    if result is NSNull {
                        return
                    }
                    else {
                        if let jsonData = result as? [NSDictionary] {
                            for elem in jsonData {
                                let passID = elem.value(forKey: "userID") as? Int
                                let nme = elem.value(forKey: "name") as? String
                                let loc = elem.value(forKey: "location") as? String
                                let dest = elem.value(forKey: "destination") as? String
                                let rider = RideRequest.init(id: passID!, loc: loc!, dest: dest!, nme: nme!)
                                self.queuedRiders.append(rider)
                                // passengerID, location, dest, name, priority
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(queuedRiders[indexPath.row].name):\t\(queuedRiders[indexPath.row].location) - \(queuedRiders[indexPath.row].destination)"
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queuedRiders.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func startRide() {
       let parameters : Parameters = ["PASSENGER_ID" : self.queuedRiders[selectedRow!].passengerID,
                                       "DRIVER_ID" : Globals.userID,
                                       "destination" : self.queuedRiders[selectedRow!].destination,
                                       "driverName" : self.queuedRiders[selectedRow!].name,
                                       "rating" : 4.4]
    }
    
    func removeRiderFromQueue() {
        let parameters : Parameters = ["userID" : queuedRiders[selectedRow!].passengerID]
        
        Alamofire.request("\(Globals.webURL)removeRideRequest.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let popup = UIAlertController.init(title: "Would you like to drive \(queuedRiders[indexPath.row].name)", message: "\(queuedRiders[indexPath.row].location) - \(queuedRiders[indexPath.row].destination)", preferredStyle: .actionSheet)
        popup.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { Void in
            self.rideCompletedBtn.isHidden = false
            self.backBtn.isHidden = true
            self.riderName = self.queuedRiders[indexPath.row].name
            self.tableView.reloadData()
            self.tableView.isHidden = true
            self.selectedRow = indexPath.row
            self.removeRiderFromQueue()
        }))
        popup.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func rideCompletePressed(_sender: UIButton) {
        let popup = UIAlertController.init(title: "Thanks!", message: "You earned $10 driving \(self.riderName!).", preferredStyle: .actionSheet)
        popup.addAction(UIAlertAction.init(title: "Keep driving", style: .default, handler: { Void in
                self.tableView.isHidden = false
                self.rideCompletedBtn.isHidden = true
            self.backBtn.isHidden = false
            self.retrieveRequests()
            }))
        popup.addAction(UIAlertAction.init(title: "Stop driving", style: .default, handler: { Void in
                self.dismiss(animated: true, completion: nil)
            }))
        self.present(popup, animated: true, completion: nil)
    }
    
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}

class RideRequest {
    var passengerID : Int = -1
    var location : String = ""
    var destination : String = ""
    var priority : Int = -1
    var name : String
    
    init(id: Int, loc: String, dest: String, nme: String) {
        passengerID = id
        location = loc
        destination = dest
        name = nme
    }
}
