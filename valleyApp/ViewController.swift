//
//  ViewController.swift
//  valleyApp
//
//  Created by Henry Akaeze on 1/22/18.
//  Copyright © 2018 Henry Akaeze. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var popUpView: UIView!
    
    private var LATITUDE = Double()
    private var LONGITUDE = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationAuth()
        
        Auth.auth().signInAnonymously { (user, error) in
            if error != nil{
                print("Error occured while signing in")
            }
            else{
                print("\(user) signed in")
            }
        }
        
        Database.database().reference().child("CampusPoints").observe(.childAdded, with: { (snapshot) -> Void in
        let anno = snapshot.value as! Dictionary<String, String>
        
        //let announce_key = snapshot.key
        
        if let name = anno["Name"] as String!, let latitude = anno["Latitude"] as String!, let longitude = anno["Longitude"] as String!, let type = anno["Type"] as String!{
            
            let loc = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
                let annotation = campusAnnotations(location: loc, name: name)
                self.mapView.addAnnotation(annotation)
        
            }
        })
        
        //set UIGesture tap event that hides keyboard on view click
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        //give views shadows
        buttonsView.layer.shadowOpacity = 0.5
        popUpView.layer.shadowOpacity = 0.5
        
        //Map Functions to set up map and locationmanager
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        locationAuth()
    }
    
    //MARK: - Map Functions
    
    //Get authorization from user if doesn't exist
    func locationAuth(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            mapView.showsUserLocation = true
        }
        else{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("HEN Error Occured Getting Location")
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        // This should hide keyboard for the view.
        view.endEditing(true)
    }
    
    @IBAction func groupRideBtnPressed(_ sender: Any) {
        panMap()
    }
    @IBAction func instantRideBtnPressed(_ sender: Any) {
        panMap()
    }
    @IBAction func hitchRideBtnPressed(_ sender: Any) {
        panMap()
    }
    
    func panMap(){
        var myLocation: CLLocationCoordinate2D?
        var span: MKCoordinateSpan?
        popUpView.isHidden = !popUpView.isHidden
        
        let loc = mapView.centerCoordinate
        if popUpView.isHidden{
            myLocation = CLLocationCoordinate2DMake(LATITUDE, LONGITUDE)
            span = MKCoordinateSpanMake(0.01, 0.01)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation!, span!)
            mapView.animatedZoom(zoomRegion: region, duration: 1.0)
        }
        else if !popUpView.isHidden{
            myLocation = CLLocationCoordinate2DMake(LATITUDE, LONGITUDE)
            span = MKCoordinateSpanMake(0.02, 0.02)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation!, span!)
            mapView.animatedZoom(zoomRegion: region, duration: 1.0)
            
        }
        
        print("LAT: \(LATITUDE), LONG: \(LONGITUDE)")
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways{
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[0]
        
        LATITUDE = loc.coordinate.latitude
        LONGITUDE = loc.coordinate.longitude
        print("LAT: \(LATITUDE), LONG: \(LONGITUDE)")
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude)

        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        if !mapHasCenteredOnce{
            mapView.setRegion(region, animated: true)
            mapHasCenteredOnce = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?

        if annotation.isKind(of: MKUserLocation.self){
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")

            annotationView?.image = UIImage(named: "standing")
        }

        return annotationView
    }

}

extension MKMapView {
    func animatedZoom(zoomRegion:MKCoordinateRegion, duration:TimeInterval) {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.setRegion(zoomRegion, animated: true)
        }, completion: nil)
    }
}


//            let camera = MKMapCamera()
//            camera.centerCoordinate = mapView.centerCoordinate
//            camera.pitch = 80.0
//            camera.altitude = 600.0
//            camera.heading = 0.0
//            mapView.setCamera(camera, animated: true)
