//
//  SearchViewController.swift
//  hackBU-Rideshare
//
//  Created by Matthew Reid on 2/9/19.
//  Copyright © 2019 Matthew Reid. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var startingLocationField: UITextField!
    @IBOutlet weak var endLocationField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var location : String?
    var destination : String?
    
    @IBOutlet weak var doneBtn: UIButton!
    
    
    var allLocations = [String]()
    var filtered = [String]()
    var txtFieldSelected : Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        allLocations = Globals.locations

        startingLocationField.delegate = self
        endLocationField.delegate = self
        
        doneBtn.layer.cornerRadius = 16.0
        startingLocationField.layer.addBorder(edge: .bottom, color: .lightGray, thickness: 0.4)
        
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == startingLocationField {
            txtFieldSelected = 0
        }
        if textField == endLocationField {
            txtFieldSelected = 1
        }
        
        guard textField.text!.characters.count > 1 else {
            tableView.isHidden = true
            return true
        }
        filterContentForSearchText(searchText: textField.text!)
        tableView.isHidden = false
        tableView.reloadData()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if txtFieldSelected == 0 {
            startingLocationField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text!
            location = startingLocationField.text!
        }
        if txtFieldSelected == 1 {
            endLocationField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text!
            destination = endLocationField.text!
        }
        tableView.deselectRow(at: indexPath, animated: true)
        filtered.removeAll()
        tableView.reloadData()
        tableView.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell
        cell?.textLabel?.text = filtered[indexPath.row]
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    @IBAction func donePressed() {
        guard location != nil && destination != nil else {
            return
        }
        
        let rideVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rideVC") as! RideViewController
        
        rideVC.startLocation = self.location!
        rideVC.destination = self.destination!

       self.present(rideVC, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array
        self.filtered = self.allLocations.filter({( location: String) -> Bool in
            // to start, let's just search by name
            return location.lowercased().range(of: searchText.lowercased()) != nil
        })
    }
    
    @IBAction func backPressed() {
        self.dismiss(animated: true, completion: nil)
    }


}
