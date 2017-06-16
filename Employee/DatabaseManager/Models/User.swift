//
//  User.swift
//  Employee
//
//  Created by Gohar on 6/16/17.
//  Copyright © 2017 secretOrganization. All rights reserved.
//

import Foundation
import RealmSwift

class UserModel: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var address = ""
    dynamic var office = ""
    dynamic var payonline = ""
    
    dynamic var email = ""
    dynamic var img = ""
    dynamic var orders = "" // [] should be array of orders
    dynamic var executor = false
    dynamic var customer = false
    dynamic var banned = false
    dynamic var online = false
    dynamic var sex = ""
    dynamic var birthdate = ""
    
    dynamic var phone = ""
    dynamic var coordinates = "" // example [59.9171483, 30.0448817]
    
    dynamic var currentUser = false
    
    // dynamic var token = ""
    
    
    override static func primaryKey() -> String? {
        return "phone"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self.name = json["name"] as? String ?? ""
        self.address = json["address"] as? String ?? ""
        self.payonline = json["payonline"] as? String ?? ""
        self.office = json["office"] as? String ?? ""
        
        self.email = json["email"] as? String ?? ""
        self.img = json["img"] as? String ?? ""
        self.orders = json["orders"] as? String ?? ""
        self.sex = json["sex"] as? String ?? ""
        self.birthdate = json["birthdate"] as? String ?? ""
        
        self.phone = json["phone"] as? String ?? ""
        
        self.coordinates = json["coordinates"] as? String ?? ""
    }
}

