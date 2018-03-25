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

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.statusBarBackgroundColor = UIColor.rgbColor(red: 249, green: 249, blue: 249)

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let currentLocation = locations.last {
            self.currentLocation = currentLocation
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButton(_ sender: Any) {
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
