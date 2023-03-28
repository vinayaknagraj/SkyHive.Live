//
//  MapScreen.swift
//  User-Location
//
//  Created by Sean Allen on 8/24/18.
//  Copyright © 2018 Sean Allen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapScreen: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let map = MKMapView()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
         addAnnotations()
        view.addSubview(map)
        checkLocationServices()
    }

    
    func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func addAnnotations() {
        
       /* let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 19.076090, longitude: 72.877426)
        annotation1.title = "Mumbai"
        annotation1.subtitle = "Maharashtra, India"
        
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 19.0330, longitude: 73.0297)
        annotation2.title = "Trial"
        annotation2.subtitle = "Delhi, India"
       mapView.addAnnotations([annotation1, annotation2]) */
        
        let annotation1 = CustomAnnotation(title: "Custom Annotation", subtitle: "India", coordinate: CLLocationCoordinate2D(latitude: 19.076090, longitude: 72.877426), image: UIImage(named: "image_name.png"))
       
        let annotation3 = CustomAnnotation(title: "Thane", subtitle: "India", coordinate: CLLocationCoordinate2D(latitude: 19.218330, longitude: 72.978088), image: UIImage(named: "image_name.png"))
        
        let annotation2 = CustomAnnotation(title: "Custom Annotation", subtitle: "India", coordinate: CLLocationCoordinate2D(latitude: 19.0330, longitude: 73.0297), image: UIImage(named: "image_name.png"))
        
        mapView.addAnnotations([annotation1, annotation2, annotation3])
    }

   /* func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
        let identifier = "CustomAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.image = customAnnotation.image
            annotationView?.leftCalloutAccessoryView = imageView
        } else {
            annotationView?.annotation = customAnnotation
        }
        return annotationView
    }
*/
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
}



class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?

    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, image: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.image = image
        super.init()
    }

}



extension MapScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}


