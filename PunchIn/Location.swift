//
//  Location.swift
//  PunchIn
//
//  Created by Sumeet Shendrikar on 10/24/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import Parse

class Location : PFObject, PFSubclassing {
    
    // MARK: Parse subclassing
    private static let className = "Location"
    private static var initialized = false
    
    override class func initialize() {
        if !initialized {
            print("registered \(className) with parse!")
            registerSubclass()
            initialized=true
        }
    }
    
    class func parseClassName() -> String {
        return className
    }
 
    // MARK: Properties stored to Parse
    @NSManaged private(set) var address : String!
    @NSManaged private(set) var latitude: String!
    @NSManaged private(set) var longitude: String!
    
    private(set) var coordinates: CLLocation?
    
    override init() {
        super.init()
    }
    
    init(address:String, coordinates:CLLocation){
        super.init()
        self.address = address
        self.coordinates = coordinates
        self.latitude = "\(coordinates.coordinate.latitude)"
        self.longitude = "\(coordinates.coordinate.longitude)"
    }
}