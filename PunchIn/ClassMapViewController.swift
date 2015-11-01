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

class ClassMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var showClassLocation: UIImageView!
    @IBOutlet weak var showPersonLocation: UIImageView!
    
    var currentClass:Class!
    var person:Person!
    private var personImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.person = ParseDB.currentPerson
        self.locationMapView.delegate = self
        self.locationMapView.showsUserLocation = true

        setupNavigationImages()
        
        showClassLocationOnMap()
        goToClassLocation()
        showPersonLocationOnMap()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationImages() {
        currentClass.parentCourse.getImage { (image, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.showClassLocation.image = image
                    self.showClassLocation.alpha = 0
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.showClassLocation.alpha = 1
                    })
                }
            }
        }
    }
    
    // MARK: MapView delegates
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
//            circle.strokeColor = UIColor.redColor()
//            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.strokeColor = ThemeManager.theme().primaryDarkBlueColor()
            circle.fillColor = circle.strokeColor?.colorWithAlphaComponent(0.1)
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
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        }
        
        person.getImage { (image, error) -> Void in
            if error == nil {
                // resize the immage to show in the annotation
                let resizeImageView = UIImageView(frame: CGRectMake(0, 0, 45, 45))
                resizeImageView.layer.borderColor = ThemeManager.theme().primaryDarkBlueColor().CGColor
                resizeImageView.layer.borderWidth = CGFloat(3.0)
                resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
                resizeImageView.image = image
                
                UIGraphicsBeginImageContext(resizeImageView.frame.size)
                resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                let thumb = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                dispatch_async(dispatch_get_main_queue()){
                    annotationView!.image = thumb
                }
            }else{
                print("error getting image for person \(error)")
                annotationView!.image = nil
            }
        }
        
        return annotationView
    }
    
    // MARK: show location functions
    private func showClassLocationOnMap(){
        if let classGeofence = currentClass.geofenceRegion {
            // show class geofence
            let classCircle = MKCircle(centerCoordinate: classGeofence.center, radius: classGeofence.radius)
            self.locationMapView.addOverlay(classCircle)
        }
            
    }
    
    func goToClassLocation() {
        if let classGeofence = currentClass.geofenceRegion {
            // show class region
            let classRegion = MKCoordinateRegionMake(classGeofence.center, MKCoordinateSpanMake(0.01, 0.01))
            self.locationMapView.setRegion(classRegion, animated: true)
        }
    }
    
    private func showPersonLocationOnMap(){
        var name: String!
        if let student = person as? Student {
            name = student.studentName
        }else{
            let instructor = person as? Instructor
            name = instructor?.instructorName
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Getting location..."
        
        LocationProvider.location { (location, error) -> Void in
            if error == nil {
                let annotation = MKPointAnnotation()
                annotation.coordinate = (location?.coordinates)!
                annotation.title = name
                self.locationMapView.addAnnotation(annotation)
            }else{
                print("map view: error getting location \(error)")
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    func goToPersonLocation() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "Getting location..."
        
        LocationProvider.location { (location, error) -> Void in
            if error == nil {
                let personRegion = MKCoordinateRegionMake((location?.coordinates)!, MKCoordinateSpanMake(0.01, 0.01))
                self.locationMapView.setRegion(personRegion, animated: true)
            }else{
                print("map view: error getting location \(error)")
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
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
