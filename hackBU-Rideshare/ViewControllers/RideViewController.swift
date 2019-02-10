//
//  RideViewController.swift
//  hackBU-Rideshare
//
//  Created by Matthew Reid on 2/10/19.
//  Copyright © 2019 Matthew Reid. All rights reserved.
//

import UIKit
import Alamofire

class RideViewController: UIViewController {

    var startLocation : String?
    var destination : String?
    var statusCheckedCount : Int = 0
    
    var isRiding : Bool = false
    var addedToQueue : Bool = false
    var shouldStopQueueing : Bool = false
    
    
    @IBOutlet weak var searchingLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var rideCompleteBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var driverID : Int = -1
    var driverStars : Double?
    var driverName : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rideCompleteBtn.layer.cornerRadius = 16.0
        cancelBtn.layer.cornerRadius = 16.0
        cancelBtn.layer.borderWidth = 3.0
        cancelBtn.layer.borderColor = cancelBtn.titleColor(for: .normal)?.cgColor
        
        startAnimating()
        
        guard startLocation != nil, destination != nil else {
            return
        }
        
        addToQueue()
        
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkRideStatus), userInfo: nil, repeats: true)


        // Do any additional setup after loading the view.
    }
    
    func startAnimating() {
        
    }
    
    @IBAction func rideCompletedPressed() {
        
        let parameters : Parameters = ["userID" : Globals.userID]
        
        Alamofire.request("\(Globals.webURL)removeRide.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
        }
    }
    
    @IBAction func cancelRidePressed() {
        shouldStopQueueing = true
        let parameters : Parameters = ["userID" : Globals.userID]
        
        Alamofire.request("\(Globals.webURL)removeRideRequest.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func checkRideStatus() {
        statusCheckedCount += 1
        guard statusCheckedCount < 25, !isRiding, addedToQueue, !shouldStopQueueing else {
            return
        }
        print("checked ride status\n")
        
        let parameters:Parameters = ["userID" : Globals.userID]
        
        
        Alamofire.request("\(Globals.webURL)rideStatus.php", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                print(response)
                
                if let result = response.result.value {
                    if result is NSNull {
                        return
                    }
                    else {
                        
                        if let jsonData = result as? NSDictionary {
                            
                            if let driverName = jsonData.value(forKey: "driverName") as? String, let driverID = jsonData.value(forKey: "DRIVER_ID") as? Int, let destination = jsonData.value(forKey: "destination") as? Float, let driverStars = jsonData.value(forKey: "rating") as? Double {
                                
                                self.subtitleLabel.text = "Currently riding with \(driverName):\t\(driverStars) stars"
                                self.cancelBtn.isHidden = true
                                self.rideCompleteBtn.isHidden = false
                                self.searchingLabel.isHidden = false
                                self.setStarsVisible(driverStars)
                                self.isRiding = true
                                self.shouldStopQueueing = true
                            }
                            else {
                                
                            }
                        }
                    }
                }
        }
    }
    
    func setStarsVisible(_ num: Double) {
        let intVal = Int(num)
        let stars = [star1, star2, star3, star4, star5]
        
        for i in 0...(intVal-1) {
            stars[i]?.isHidden = false
        }
    }
    
    func addToQueue() {
        let parameters:Parameters = ["userID" : Globals.userID,
                                     "startLocation" : self.startLocation!,
                                     "destination" : self.destination!,
                                     "name" : Globals.name]
        
        
        Alamofire.request("\(Globals.webURL)addToQueue.php", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                print("ADDtoQueue response:\t\(response)")
                
                if let result = response.result.value {
                    if result is NSNull {
                        return
                    }
                    else {
                        
                        if let jsonData = result as? NSDictionary {
                            if jsonData["addedRider"] as? Int == 1 || jsonData["addedRider"] as? Int == 0 {
                                self.addedToQueue = true
                            }
                        }
                    }
                }
        }
    }
    


}
