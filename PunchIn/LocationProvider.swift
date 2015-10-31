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
    func errorGettingLocation(error:NSError)
}

class LocationProvider : NSObject, CLLocationManagerDelegate {
    
    // MARK: static constants
    static let errorDomain = "LocationProvider"
    static let errorCodeNoLocation = 1234
    static let errorCodeLocationMonitoringNotAvailable = 1235
    static let errorCodeUnknownState = 1236
    
    static let locationAvailableNotificationName = "DidUpdateLocation"
    static let didEnterGeofenceNotificationName = "DidEnterGeofence"
    static let didExitGeofenceNotificationName = "DidExitGeofence"
    
    static let defaultGeofenceDistance = 20.0 // 20 meters
    
    // MARK: CLLocation Manager instance
    private let manager: CLLocationManager = {
        let mgr = CLLocationManager()
        mgr.distanceFilter = kCLDistanceFilterNone
        mgr.desiredAccuracy = kCLLocationAccuracyBest
        return mgr
    }()
    
    private let geocoder = CLGeocoder()
    
    // MARK: singleton instanc
    private static let instance = LocationProvider()
    
    private var monitoredRegions: [CLCircularRegion:LocationProviderGeofenceDelegate] = [:]
    
    private var canMonitorForRegion = true
    
    private override init() {
        print("Creating LocationProvider")
        super.init()
        manager.delegate = self
        
        // check authorization state
        checkAuthorizationState()
        
        // check if can monitor
        canMonitorForRegion = CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)
    }
    
    private func checkAuthorizationState() {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            // do nothing
            break
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
        instance.isContinuousLocation = false
        instance.manager.stopUpdatingLocation()
    }
    
    private var isContinuousLocation = false
    private var locationCompletionHandler: ((location:Location?,error:NSError?)->Void)?
    
    class func continuousLocation(completion: ((location:Location?, error:NSError?)->Void)) {
        instance.locationCompletionHandler = completion
        instance.isContinuousLocation = true
        instance.startUpdatingLocation()
    }
    
    class func location(completion: ((location:Location?, error:NSError?)->Void)) {
        instance.checkAuthorizationState()
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            instance.locationCompletionHandler = completion
            instance.manager.requestLocation()
        }else{
            print("ruh roh.... not authorized to get location")
        }
    }
    
    // MARK: CLLocationManagerDelegate delegates
    class func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("location authorization status change! \(status.rawValue)") // TODO:  need to handle 
        switch status {
        case .NotDetermined:
            //instance.requestAlwaysAuthorization()
            
            break
        case .AuthorizedWhenInUse:
           instance.startUpdatingLocation()
            break
        case .AuthorizedAlways:
            instance.startUpdatingLocation()
            break
        case .Restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .Denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let handler = self.locationCompletionHandler else {
            return
        }
        
        // now provide the location to the completion handler
        if let location = locations.last {
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
            
            if !isContinuousLocation {
                // stop updates
                self.manager.stopUpdatingLocation()
                // reset completion handler
                self.locationCompletionHandler = nil
            }
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
        if let region = region as? CLCircularRegion {
            if let delegate = self.monitoredRegions[region] {
                delegate.isInsideGeofence()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("outside geofence \(region.identifier)!")
        if let region = region as? CLCircularRegion {
            if let delegate = self.monitoredRegions[region] {
                delegate.isOutsideGeofence()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        guard (region as? CLCircularRegion != nil) else {
            print("region \(region.identifier) not a circular region")
            return
        }
        
        let region = region as! CLCircularRegion
        guard  let delegate = self.monitoredRegions[region] else {
            print("didDetermineState but no completion handler")
            return
        }
        
        print("did determine state \(state)for region")
        switch state {
        case .Inside:
            // always notify if inside geofence
            delegate.isInsideGeofence()
        case .Outside:
            break
        case .Unknown:
            // TODO: fix me
            break
        }
        
        // remove delegate; was a onetime operation
        self.monitoredRegions.removeValueForKey(region)
    }
    
    class func createGeofenceRegion(location: Location, distance: CLLocationDistance=LocationProvider.defaultGeofenceDistance, id:String) -> CLCircularRegion? {
        guard CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) else {
            return nil
        }
        
        let radius = distance > instance.manager.maximumRegionMonitoringDistance ? instance.manager.maximumRegionMonitoringDistance : distance
        return CLCircularRegion(center:location.coordinates, radius: radius, identifier: id)
    }
    
    class func addNotifyForRegion(region:CLCircularRegion, delegate: LocationProviderGeofenceDelegate) {
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        instance.monitoredRegions[region] = delegate
        instance.manager.startMonitoringForRegion(region)
        print("monitoring \(instance.manager.monitoredRegions.count)")
    }
    
    class func removeNotifyForRegion(region:CLCircularRegion) {
        region.notifyOnEntry = false
        region.notifyOnExit = false
        instance.manager.stopMonitoringForRegion(region)
        
        instance.monitoredRegions.removeValueForKey(region)
    }
    
    class func notifyWhenInsideGeofence(region:CLCircularRegion, delegate: LocationProviderGeofenceDelegate){
        LocationProvider.location { (location, error) -> Void in
            if location == nil {
                print("error getting location!")
                addNotifyForRegion(region, delegate: delegate) //TODO: fix me!
                delegate.errorGettingLocation(error!)
//                delegate.isUnknown()
            }else{
                if region.containsCoordinate((location?.coordinates)!) {
                    delegate.isInsideGeofence()
                }else{
                    // if request for region is outside the geofence, then add notify for region
                    addNotifyForRegion(region, delegate: delegate)
                }
            }
        }

    }
}