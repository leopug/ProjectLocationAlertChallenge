//
//  ViewController.swift
//  ProjectLocationAlertChallenge
//
//  Created by Leonardo Maia Pugliese on 04/06/20.
//  Copyright © 2020 Leonardo Maia Pugliese. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    let randomButtom = UIButton()
    let titleLabel = UILabel()
    let distanceLabel = UILabel()
    let locationManager = CLLocationManager()
    var userLocation : CLLocation?
    var homeLocation : CLLocation?
    let homeAddress = "1 Infinite Loop, Cupertino, CA"
        
    let padding : CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        userLocation = CLLocation(latitude: 5.0, longitude: 5.0)
        homeLocation = CLLocation(latitude: 6.0, longitude: 6.0)
        startLocationService()
        startNotificationService()
        configureUI()
    }
    
    func configureUI() {
        configureLabel()
        configureButton()
        configureDistanceLabel()
    }

    func configureDistanceLabel() {
        view.addSubview(distanceLabel)
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.text = "- - - - -"
        distanceLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        distanceLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.textColor = .label
        distanceLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: randomButtom.bottomAnchor, constant: padding),
            distanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            distanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            distanceLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Go Neon! Mask Alert POC"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureButton() {
        view.addSubview(randomButtom)
        randomButtom.translatesAutoresizingMaskIntoConstraints = false
        randomButtom.setTitle("Generate Location", for: .normal)
        randomButtom.layer.cornerRadius = 12
        randomButtom.backgroundColor = .systemBlue
        randomButtom.addTarget(self, action: #selector(randomButtomTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            randomButtom.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            randomButtom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            randomButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            randomButtom.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func randomButtomTapped() {
        print("buttom tapped")
        if let homeFromAdressLocation = getLocationFrom(address: homeAddress) {
            print(homeFromAdressLocation)
        }
        guard let homeLocation = homeLocation else { return }
        userLocation = CLLocation(latitude: Double.random(in: 6.0001...6.0010), longitude: Double.random(in: 6.0001...6.0010))
        let distanceInMeters = userLocation!.distance(from: homeLocation).rounded()
        print(distanceInMeters)
        distanceLabel.text = "\(distanceInMeters.rounded()) meters"
        if distanceInMeters > 120 {
            scheduleLocal()
        }
    }
    
    func startLocationService () {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func startNotificationService() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("yayy")
            }else {
                print("D'oh")
            }
        }
    }
    
    func getLocationFrom(address: String) -> CLLocation? {

        let geoCoder = CLGeocoder()
        
        var location : CLLocation?
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                placemarks.first?.location != nil
            else {
                // handle no location found
                return
            }

            location = placemarks.first?.location
        }
        return location
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //userLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    func scheduleLocal(){
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Olá amigx"
        content.body = "Neon lembra você de usar a máscara fora de casa e manter distância social. 😉 😷"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"xpto"]
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let showNotificationAction = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [showNotificationAction], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
}
