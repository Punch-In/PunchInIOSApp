//
//  LocationManager.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/26/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationProviderGeofenceDelegate {
    func isInsideGeofence()
    func isOutsideGeofence()
    func isUnknown()
}

class LocationProvider : NSObject, CLLocationManagerDelegate {
    
    static let errorDomain = "LocationProvider"
    static let errorCodeNoLocation = 1234
    static let errorCodeLocationMonitoringNotAvailable = 1235
    static let errorCodeUnknownState = 1236
    
    static let locationAvailableNotificationName = "DidUpdateLocation"
    static let didEnterGeofenceNotificationName = "DidEnterGeofence"
    static let didExitGeofenceNotificationName = "DidExitGeofence"
    
    static let defaultGeofenceDistance = 20.0 // 20 meters
    
    private let manager: CLLocationManager = {
        let mgr = CLLocationManager()
        mgr.distanceFilter = kCLDistanceFilterNone
        mgr.desiredAccuracy = kCLLocationAccuracyBest
        return mgr
    }()
    
    private let geocoder = CLGeocoder()
    
    private static let instance = LocationProvider()
    
    private override init() {
        super.init()
        manager.delegate = self
    }
    
    private func checkAuthorizationState() {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            // do nothing
            print("always authorized!")
        case .NotDetermined:
            self.manager.requestAlwaysAuthorization()
        case .AuthorizedWhenInUse, .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to check in, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            print("restricted, denied, or authorized when in use")
            
            //           self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }

    private func startUpdatingLocation() {
        self.checkAuthorizationState()
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            print("started updating location")
            self.manager.startUpdatingLocation()
        }else{
            print("ruh roh.... not authorized")
        }
    }
    
    class func stopUpdatingLocation() {
        print("stopped updating location")
        instance.manager.stopUpdatingLocation()
    }
    
    private var locationCompletionHandler: ((location:Location?,error:NSError?)->Void)?
    private var includeAddress: Bool = true
    
    class func continuousLocation(withAddress: Bool=true, completion: ((location:Location?, error:NSError?)->Void)) {
        instance.locationCompletionHandler = completion
        instance.includeAddress = withAddress
        instance.startUpdatingLocation()
    }
    
    class func location(withAddress: Bool=true, completion: ((location:Location?, error:NSError?)->Void)) {
        instance.checkAuthorizationState()
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            print("requesting location")
            instance.locationCompletionHandler = completion
            instance.includeAddress = withAddress
            instance.manager.requestLocation()
        }else{
            print("ruh roh.... not authorized")
        }
    }
    
    // MARK: CLLocationManagerDelegate delegates
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("location authorization status change! \(status.rawValue)") // TODO:  need to handle 
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard self.locationCompletionHandler != nil else {
            print("location update but no completion handler")
            return
        }
        
        let handler = self.locationCompletionHandler!
        // now provide the location to the completion handler
        if let location = locations.last {
            if !self.includeAddress {
                handler(location: Location(address:"", coordinates: location), error:nil)
            }else{
                // caller wants the address as well as coordinates. so provide 'em
                self.geocoder.reverseGeocodeLocation(location, completionHandler: {
                    (placemarks: [CLPlacemark]?, error:NSError?) -> Void in
                    if error == nil {
                        if let placemark = placemarks?.last {
                            if let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
                                let address =  addrList.joinWithSeparator(",")
                                handler(location: Location(address: address, coordinates: location), error: nil)
                            }
                        }
                    }else{
                        print("error obtaining address from reverseGeocodeLocation \(error)")
                        handler(location:Location(address: "", coordinates: location), error:error)
                    }
                })
            }
            
            // stop updates
            self.manager.stopUpdatingLocation()
            // reset completion handler
            self.locationCompletionHandler = nil
        }
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("monitoringDidFailForRegion \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("in geofence for region \(region.identifier)!")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("outside geofence \(region.identifier)!")
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        guard self.requestStateCompletionHandler != nil else {
            print("didDetermineState but no completion handler")
            return
        }
        
        let handler = self.requestStateCompletionHandler!
        print("did determine state \(state)for region")
        switch state {
        case .Inside:
            handler(status: true, error: nil)
        case .Outside:
            handler(status: false, error: nil)
        case .Unknown:
            // TODO: fix me
            handler(status: false, error: NSError(domain: LocationProvider.errorDomain, code: LocationProvider.errorCodeUnknownState, userInfo:nil))
        }
    }
    
    class func createGeofenceRegion(location: Location, distance: CLLocationDistance=LocationProvider.defaultGeofenceDistance, id:String) -> CLCircularRegion? {
        guard CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) else {
            return nil
        }
        
        let radius = distance > instance.manager.maximumRegionMonitoringDistance ? instance.manager.maximumRegionMonitoringDistance : distance
        return CLCircularRegion(center:location.coordinates, radius: radius, identifier: id)
    }
    
    class func addNotifyForRegion(region:CLCircularRegion) {
        guard CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) else {
            print("monitoring not available for geofence. Have to manually poll")
            return
        }
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        instance.manager.startMonitoringForRegion(region)
    }
    
    class func removeNotifyForRegion(region:CLCircularRegion) {
        region.notifyOnEntry = false
        region.notifyOnExit = false
        instance.manager.stopMonitoringForRegion(region)
    }
    
    private var requestStateCompletionHandler: ((status:Bool, error:NSError?)->Void)?
    
    // checks if current location is inside current geofence
    class func isInsideGeofence(region:CLCircularRegion, completion:((status:Bool, error:NSError?)->Void)) {
        instance.requestStateCompletionHandler = completion
        instance.manager.requestStateForRegion(region)
    }
}