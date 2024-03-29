//
//  ViewController.swift
//  TrackUserLocation
//
//  Created by Deshpande, Anup on 6/3/19.
//  Copyright © 2019 Deshpande, Anup. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    
    func checkLocationServicesEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationPermission()
        }else{
            let Alert = UIAlertController(title: "Need Permission", message: "Please turn location service on", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            Alert.addAction(cancel)
        }
    }
    
    func checkLocationPermission(){
        switch  CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            self.mapView.showsUserLocation = true
            zoomViewOnUserLocation()
            break
       
        case .denied:
            let Alert = UIAlertController(title: "Turn on location settings to continue", message: "1. Select Location\n 2. Tap on While Using the App", preferredStyle: .actionSheet)
            let gotoAction = UIAlertAction(title: "Go to Settings", style: .default, handler:gotoSettingsHandler)
            let noThanksAction = UIAlertAction(title: "No Thanks", style: .cancel, handler: nil)
            Alert.addAction(gotoAction)
            Alert.addAction(noThanksAction)
            
            self.present(Alert, animated: true, completion: nil)
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted:
            //Do something if permission is restricted
            break
            
        case .authorizedAlways:
            break
            
        }
    }
    
    
    //navigate to application setttings page if location is not enabled
    func gotoSettingsHandler(alert: UIAlertAction){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            //settings page opened successfully
            })
        }
    }
    
    
    func zoomViewOnUserLocation(){
      
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            
        }
    }
 
    @IBAction func buttonClicked(_ sender: UIButton) {
        if sender.title(for: .normal) == "Locate Me"{
            print("Finding the current location..")
           checkLocationServicesEnabled()
        }
    
        if sender.title(for: .normal) == "Start Tracking"{
            print("Started Tracking")
            checkLocationServicesEnabled()
            locationManager.startUpdatingLocation()
        }
        
        if sender.title(for: .normal) == "Stop Tracking"{
            print("Stopped Tracking ")
            locationManager.stopUpdatingLocation()
        }
        
    }
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        guard let location = locations.last else { return }
        print("\nUser location updated:\nLat:\(location.coordinate.latitude)\nLng:\(location.coordinate.longitude)")
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }
}


