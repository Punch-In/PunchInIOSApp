//
//  LocationManager.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/26/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Foundation
import CoreLocation

class LocationProvider : NSObject, CLLocationManagerDelegate {
    
    static let errorDomain = "LocationProvider"
    static let errorCodeNoLocation = 1234
    
    static let locationAvailableNotificationName = "DidUpdateLocation"
    
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

    class func startUpdatingLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            // do nothing
            print("always authorized!")
            instance.manager.startUpdatingLocation()
        case .NotDetermined:
            instance.manager.requestAlwaysAuthorization()
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
    
    class func currentLocation(withAddress: Bool=true, completion: ((location:Location?, error:NSError?)->Void))  {
        if let currentLocation = instance.manager.location {
            if !withAddress {
                return completion(location: Location(address:"", coordinates: currentLocation), error:nil)
            }
            
            instance.geocoder.reverseGeocodeLocation(currentLocation, completionHandler: {
                (placemarks: [CLPlacemark]?, error:NSError?) -> Void in
                if error == nil {
                    if let placemark = placemarks?.last {
                        if let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
                            let address =  addrList.joinWithSeparator(",")
                            return completion(location: Location(address: address, coordinates: currentLocation), error: nil)
                        }
                    }
                }else{
                    print("error obtaining address from reverseGeocodeLocation \(error)")
                    return completion(location:Location(address: "", coordinates: currentLocation), error:error)
                }
            })
        }else{
            completion(location:nil, error:NSError(domain: LocationProvider.errorDomain, code: LocationProvider.errorCodeNoLocation, userInfo:nil))
        }
    }
    
    class func stopUpdatingLocation() {
        print("stopped updating location")
        instance.manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("location authorization status change! \(status.rawValue)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            NSLog("new location! \(location)")
            NSNotificationCenter.defaultCenter().postNotificationName(LocationProvider.locationAvailableNotificationName, object: nil)
        }
    }
}