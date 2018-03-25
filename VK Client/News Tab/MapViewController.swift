//
//  MapViewController.swift
//  VK Client
//
//  Created by Денис Львович on 25.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var currentLocation = CLLocation()
    private var locationDescription = ""
    var delegate: MapViewControllerDelegate?
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.statusBarBackgroundColor = UIColor.rgbColor(red: 249, green: 249, blue: 249)

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        self.doneButton.isEnabled = false
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let currentLocation = locations.last {
            self.currentLocation = currentLocation

            DispatchQueue.global(qos: .userInitiated).async {
                self.geocodeLocation()
            }

            let currentRadius: CLLocationDistance = 1000
            let currentRegion = MKCoordinateRegionMakeWithDistance((currentLocation.coordinate), currentRadius *
                2.0, currentRadius * 2.0)
            self.mapView.setRegion(currentRegion, animated: true)
            self.mapView.showsUserLocation = false

            self.locationManager.stopUpdatingLocation()
            self.setMarker()
        }
    }

    private func setMarker() {

        let annotation = MKPointAnnotation()
        annotation.title = "Текущее местоположение"
        annotation.subtitle = "Кликните \"Готово\" чтобы отправить его в VK"
        annotation.coordinate = self.currentLocation.coordinate
        mapView.addAnnotation(annotation)
    }

    private func geocodeLocation() {

        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(self.currentLocation) {(myPlaces, Error) -> Void in
            if let place = myPlaces?.first,
                let cityName = place.locality {

                self.locationDescription = cityName
                self.doneButton.isEnabled = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func doneButton(_ sender: Any) {
        delegate?.setLocation(coordinates: self.currentLocation.coordinate, andCityName: self.locationDescription)
        self.dismiss(animated: true, completion: nil)
    }
}

protocol MapViewControllerDelegate {

    func setLocation(coordinates: CLLocationCoordinate2D, andCityName cityName: String)
}
