//
//  SignUpViewController.swift
//  hackBU-Rideshare
//
//  Created by Matthew Reid on 2/9/19.
//  Copyright © 2019 Matthew Reid. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField : UITextField!
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var pwField : UITextField!
    @IBOutlet weak var confirmPWField : UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 0.4)
                emailField.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 0.4)
                pwField.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 0.4)
                confirmPWField.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 0.4)
        
        signupBtn.layer.cornerRadius = 12.0
        signupBtn.clipsToBounds = false

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed() {
        
        let parameters:Parameters = ["name" : self.nameField.text!,
                                     "email" : self.emailField.text!,
                                     "password" : self.pwField.text!]
        
        
        Alamofire.request("\(Globals.webURL)signup.php", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseString { response in
                
                print(response)
                
                if let result = response.result.value {
                    if result is NSNull {
                        return
                    }
                    else {
                        if result == "true" {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}

