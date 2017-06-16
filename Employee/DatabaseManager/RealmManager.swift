//
//  RealmManager.swift
//  Employee
//
//  Created by Gohar on 6/16/17.
//  Copyright © 2017 secretOrganization. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWrapper {
    
    
    class var sharedInstance: RealmWrapper {
        struct Singleton {
            static let instance = RealmWrapper()
        }
        return Singleton.instance
    }
    
    // Select object with primary key from db
    func getObjectFromTable(withPrimaryKey pk:String, objectType:Object.Type ) -> Object {
        var returnObject = Object.init()
        
        let obj = uiRealm.object(ofType: objectType, forPrimaryKey: pk)
        
        if obj != nil {
            returnObject = obj!
        }
        
        return returnObject
    }
    
    // Select All from db
    func getAllObjectsOfModelFromRealmDB(_ objectType:Object.Type)->[Object] {
        var returnObjects = [Object]()
        
        let objects = uiRealm.objects(objectType)
        
        for object in objects {
            returnObjects.append(object)
        }
        return returnObjects
    }
    

    // Insert object into db, if exist update
    func addObjectInRealmDB(_ object: Object, update: Bool = false ) {
        do {
            try uiRealm.write({
                uiRealm.add(object, update: update)
            })
        } catch {
            print("Something went wrong!")
        }
    }
    
    // delete object from db
    func deleteObjectFromRealmDB(_ object: Object)  {
        do {
            try uiRealm.write({
                uiRealm.delete(object)
            })
        } catch {
            print("Something went wrong!")
        }
    }
    
    func deleteObjectsOfModelInRealmDB(_ objectType:Object.Type) -> Void {
        let objects = uiRealm.objects(objectType)
        if objects.count == 0 {
            return
        }
        do {
            try uiRealm.write({
                uiRealm.delete(objects)
            })
        } catch {
            print("Something went wrong!")
        }
    }
    
    func deleteAllFromDB(complation:()->Void )  {
        do {
            try uiRealm.write({
                uiRealm.deleteAll()
                complation()
            })
        } catch {
            print("Something went wrong!")
        }
    }
}

