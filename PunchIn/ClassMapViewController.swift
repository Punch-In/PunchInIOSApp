//
//  ClassMapViewController.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/31/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD

class ClassMapViewController: UIViewController, MKMapViewDelegate, LocationProviderContinousDelegate {

    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var showClassLocationImage: UIImageView!
    @IBOutlet weak var showPersonLocationImage: UIImageView!
    @IBOutlet weak var showLocationsContainerView: UIView!
    
    private var isShowingPersonRegion: Bool = false {
        didSet {
            if isShowingPersonRegion == false {
                LocationProvider.stopUpdatingLocation()
                showPersonLocationImage.alpha = 0.5
                showClassLocationImage.alpha = 1.0
            }else{
                LocationProvider.continuousLocation(self)
                showPersonLocationImage.alpha = 1.0
                showClassLocationImage.alpha = 0.5
            }
        }
    }
    
    private var centerOnPerson: Bool = false
    
    var currentClass:Class!
    private var personImage: UIImage!
    private var personAnnotation = MKPointAnnotation()
    private var personName: String!
    private var hud: MBProgressHUD!


    deinit {
        LocationProvider.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isShowingPersonRegion = false

        self.locationMapView.delegate = self
        self.locationMapView.addAnnotation(personAnnotation)
        self.locationMapView.showsUserLocation = false
        self.locationMapView.userTrackingMode = .Follow
        
        if let student = ParseDB.currentPerson as? Student {
            personName = student.studentName
        }else{
            let instructor = ParseDB.currentPerson as? Instructor
            personName = instructor?.instructorName
        }


        setupNavigationImages()
        addClassLocationToMap()
        goToClassLocation()
        addPersonLocationToMap()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        LocationProvider.stopUpdatingLocation()
        self.locationMapView.removeAnnotation(self.personAnnotation)
    }
    
    func setupNavigationImages() {
        showClassLocationImage.layer.borderWidth = 1.0
        showClassLocationImage.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
        showClassLocationImage.backgroundColor = UIColor.whiteColor()
        showClassLocationImage.layer.cornerRadius = showClassLocationImage.frame.size.width / 2
        showClassLocationImage.clipsToBounds = true
        currentClass.parentCourse.getImage { (image, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.showClassLocationImage.image = image
                    let ogAlpha = self.showClassLocationImage.alpha
                    self.showClassLocationImage.alpha = 0
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.showClassLocationImage.alpha = ogAlpha
                    })
                    let gesture = UITapGestureRecognizer(target: self, action: "goToClassLocation")
                    self.showClassLocationImage.addGestureRecognizer(gesture)
                }
            }
        }

        showPersonLocationImage.layer.borderWidth = 1.0
        showPersonLocationImage.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
        showPersonLocationImage.backgroundColor = UIColor.whiteColor()
        showPersonLocationImage.layer.cornerRadius = showClassLocationImage.frame.size.width / 2
        showPersonLocationImage.clipsToBounds = true
        ParseDB.currentPerson!.getImage { (image, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.showPersonLocationImage.image = image
                    let ogAlpha = self.showPersonLocationImage.alpha
                    self.showPersonLocationImage.alpha = 0
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.showPersonLocationImage.alpha = ogAlpha
                    })
                    let gesture = UITapGestureRecognizer(target: self, action: "goToPersonLocation")
                    self.showPersonLocationImage.addGestureRecognizer(gesture)
                }
            }
        }

        showLocationsContainerView.layer.borderWidth = 2.0
        showLocationsContainerView.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
        showLocationsContainerView.backgroundColor = ThemeManager.theme().primaryGreyColor().colorWithAlphaComponent(0.2)
        showLocationsContainerView.layer.cornerRadius = 10.0
    }
    
    // MARK: MapView delegates
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor.redColor().colorWithAlphaComponent(0.1)
//            circle.strokeColor = ThemeManager.theme().primaryDarkBlueColor()
//            circle.fillColor = circle.strokeColor?.colorWithAlphaComponent(0.1)
            circle.lineWidth = 1
            return circle
        }else{
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    let annotationReuseId = "myAnnotationView"
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 48, height:48))
        }
        
        // dont show current location
        if let title = annotation.title {
            if title == mapView.userLocation.title {
                annotationView!.hidden = true
                return annotationView
            }
        }
        
        ParseDB.currentPerson!.getImage { (image, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    annotationView!.hidden = false
                    let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
                    imageView.image = image
                }
            }else{
                print("error getting image for person \(error)")
                annotationView!.image = nil
            }
        }
        
        return annotationView
    }
    
    // this and the next function are to prevent the map from automatically
    //  recentering on the user's current location if the user scrolls away from
    //  the current location
    private var regionChangeIsFromUserInteraction = false
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let view = self.locationMapView.subviews.first
        if let gestureRecognizers = view?.gestureRecognizers {
            for gesture in gestureRecognizers {
                if gesture.state == .Began || gesture.state == .Ended {
                    self.regionChangeIsFromUserInteraction = true
                    break
                }
            }
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if self.regionChangeIsFromUserInteraction {
            self.regionChangeIsFromUserInteraction = false
            self.centerOnPerson = false
        }
    }
//      add if want to do something fancy with a HUD while map is still loading
//    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
//    }
    
    // MARK: show location functions
    private func addClassLocationToMap(){
        if let classGeofence = currentClass.geofenceRegion {
            // show class geofence
            let classCircle = MKCircle(centerCoordinate: classGeofence.center, radius: classGeofence.radius)
            self.locationMapView.addOverlay(classCircle)
        }
            
    }
    
    func goToClassLocation() {
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud.labelText = "Let's show where \(currentClass.name) is...."
        self.isShowingPersonRegion = false
        if let classGeofence = currentClass.geofenceRegion {
            // show class region
            self.locationMapView.deselectAnnotation(self.personAnnotation, animated: true)
            let classRegion = MKCoordinateRegionMake(classGeofence.center, MKCoordinateSpanMake(0.005, 0.005))
            self.locationMapView.setRegion(classRegion, animated: true)
        }
        self.hud.hide(true)
    }
    
    private func addPersonLocationToMap(){
        LocationProvider.location { (location, error) -> Void in
            if error == nil || (location != nil && location!.address.isEmpty){
                self.personAnnotation.title = self.personName
                self.personAnnotation.coordinate = (location?.coordinates)!
            }else{
                print("map view: error getting location \(error)")
            }
        }
    }
    
    func goToPersonLocation() {
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud.labelText = "Let's show where you are..."
        isShowingPersonRegion = true
        centerOnPerson = true
        let personRegion = MKCoordinateRegionMake(self.personAnnotation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
        self.locationMapView.setRegion(personRegion, animated: true)
        self.hud.hide(true)
    }
    
    func didUpdateLocation(location:Location?) {
        dispatch_async(dispatch_get_main_queue()){
            self.personAnnotation.coordinate = (location?.coordinates)!
            self.personAnnotation.title = self.personName
            self.locationMapView.selectAnnotation(self.personAnnotation, animated: true)
            
            if self.centerOnPerson {
                let personRegion = MKCoordinateRegionMake(self.personAnnotation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
                self.locationMapView.setRegion(personRegion, animated: true)
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
