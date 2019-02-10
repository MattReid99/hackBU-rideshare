//
//  MapViewController.swift
//  hackBU-Rideshare
//
//  Created by Matthew Reid on 2/9/19.
//  Copyright © 2019 Matthew Reid. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationField: UIButton!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationField.layer.shadowColor = UIColor.gray.cgColor
        locationField.layer.shadowRadius = 4.0
        locationField.layer.shadowOpacity = 0.60
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        // 1
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
            
        // 2
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        }
        
        // 4
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            loadViews()
        }
        
    }
    
    func loadViews() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
            let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!, zoom: 8.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        
        if let jsonMap = Bundle.main.path(forResource: "style", ofType: "json") {
            do {
                let contents = try String(contentsOfFile: jsonMap)
                do {
                    // Set the map style by passing a valid JSON string.
                    
                    mapView.mapStyle = try GMSMapStyle(jsonString: contents)
                } catch {
                    NSLog("One or more of the map styles failed to load. \(error)")
                }
            }
            catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
        
        let marker = GMSMarker()
        
        var markerImage = UIImage.init(named: "icons8-marker-90-2.png")
        markerImage = ResizeImage(image: markerImage!, targetSize: CGSize.init(width: 40, height: 40))

        marker.position = (locationManager.location?.coordinate)!
        marker.map = mapView
        marker.icon = markerImage!
        marker.appearAnimation = .pop
        
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        
    }
    
    // 1
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            print("Current location: \(currentLocation)")
        }
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    @IBAction func startPressed(_ sender: Any) {
        if Globals.paypalEmail == nil {
        
        let popup = UIAlertController.init(title: "Enter your PayPal e-mail", message: nil, preferredStyle: .alert)
        popup.addTextField { (textField) in
            textField.text = ""
        }
        popup.addAction(UIAlertAction.init(title: "Done", style: .default, handler: { Void in
            Globals.paypalEmail = popup.textFields![0].text!
            let userDefaults = UserDefaults.standard
            userDefaults.set(Globals.paypalEmail!, forKey: "paypalEmail")
            Globals.isDriver = true
            self.present(UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rideListVC"), animated: true, completion: nil)
        }))
        popup.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(popup, animated: true, completion: nil)
            
    }
        else {
            Globals.isDriver = true
            self.present(UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rideListVC"), animated: true, completion: nil)
        }

    }
    
    @IBAction func backPressed(_sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize.init(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
