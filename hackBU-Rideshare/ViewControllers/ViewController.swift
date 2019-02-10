//
//  ViewController.swift
//  hackBU-Rideshare
//
//  Created by Matthew Reid on 2/9/19.
//  Copyright © 2019 Matthew Reid. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var passField : UITextField!
    @IBOutlet weak var signInBtn : UIButton!
    @IBOutlet weak var signUpBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        let email = userDefaults.string(forKey: "email")
        let password = userDefaults.string(forKey: "password")
        
        
        signInBtn.layer.cornerRadius = 15.0
        signInBtn.clipsToBounds = false
        
        signUpBtn.layer.cornerRadius = 15.0
        signUpBtn.clipsToBounds = false
        signUpBtn.layer.borderWidth = 3.0
        signUpBtn.layer.borderColor = signUpBtn.titleColor(for: .normal)?.cgColor
        
        guard email != nil && password != nil else {
            return
        }
        emailField.text = email!
        passField.text = password!
    }

    @IBAction func signInPressed() {
        
        let parameters:Parameters = ["email" : self.emailField.text!,
                                     "password" : self.passField.text!]
        
        
        Alamofire.request("\(Globals.webURL)login.php", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                
                print(response)
                
                if let result = response.result.value {
                    if result is NSNull {
                        return
                    }
                    else {
                        
                        if let data = result as? NSDictionary {
                                if let id = data["ID"] as? Int, let name = data["NAME"] as? String, let driver = data["ISDRIVER"] as? Int {
                                    guard id != -1 else {
                                        return
                                    }
                                    
                                    let isDriver : Bool = (driver == 1)
                                    
                                    
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(isDriver, forKey: "isDriver")
                                    userDefaults.set(id, forKey: "ID")
                                    userDefaults.set(name, forKey: "name")
                                    userDefaults.set(self.emailField.text!, forKey: "email")
                                    userDefaults.set(self.passField.text!, forKey: "password")
                                    
                                    Globals.paypalEmail = userDefaults.string(forKey: "paypalEmail")
                                    Globals.userID = id
                                    Globals.name = name
                                    Globals.isDriver = isDriver
    
                                    self.present(UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapVC"), animated: true, completion: nil)
                                }
                            }
                    }
                }
        }
    }

}

