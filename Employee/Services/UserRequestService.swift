//
//  UserRequestService.swift
//  Employee
//
//  Created by Gohar on 6/16/17.
//  Copyright © 2017 secretOrganization. All rights reserved.
//

import Foundation


class UserRequestsService {
    
    var currentUser: UserModel? {
        let cUser = uiRealm.objects(UserModel.self).filter("currentUser == true")
        return cUser.last
    }
    
    func registerRequest(number: String, user_status: UserType, success:@escaping (String)->Void, failer: @escaping (String)->Void  ) {
        
        //PALoading.sharedInstance.showImageIndicator()
        let params = ["phone": number, user_status.description : true] as [String : Any]
        
        ApiClientService.postRequest(Constants.SEND_PHONE_NUMBER_ENDPOINT, params: params, success: { (json: JSON) in
            
            if let pass_code = json["pass"] as? String {
                success(pass_code)
            }
        }) { (httpError: HTTPError?) in
            failer((httpError?.statusMessage!)!)
            
        }
    }
    
    
    // Registration second step to confirm phone number
    // Auth header(see misc1)
    // 'phone' and 'password' keys with appropriate values
    
    func confirmRegistration(number: String, password: String, success:@escaping (Bool) -> Void, failer: @escaping (String)->Void ){
        
        let params = ["phone": number, "password": password]
        
        ApiClientService.postRequest(Constants.CONFIRM_USER_ENDPOINT, params: params, success: {
            (json: JSON) in
            success(true)
            
        }) { (httpError: HTTPError?) in
            failer((httpError?.statusMessage!)!)
        }
    }
    
    
    
    // Resend the sms/response with password
    // Auth header(see misc1)
    
    func getResendPassCode(number:String,success:@escaping (String) -> Void, failer: @escaping (String)->Void) {
        let urlParam = number + Constants.RESEND_CODE_ENDPOINT
        ApiClientService.getRequest(urlParam, success: { (json:JSON) in
            print(json)
        }) { (httpError: HTTPError?) in
            failer((httpError?.statusMessage!)!)
        }
    }
    
    
    // Submit name and profile pic
    //    Auth header(see misc1)
    //    ‘name’ key for the user name, should be 2-32 latin or cyrillic,
    //    ‘img’ should be base64 png (not required),
    //    ‘sex’ - 0 for male, 1 - for female,
    //    ‘birthdate’ - standard ISO format or epoch time
    
    
    func userInitialization(userData: RegisterRequestData, success: @escaping (Bool) -> Void, failer: @escaping (String)->Void){
        
        let endPoint = userData.phone + "/init"
        
        let params = userData.JSON
        
        ApiClientService.postRequest(endPoint, params: params, success: { (json:JSON) in
            success(true)
            
            
        }) { (httpError: HTTPError?) in
            failer((httpError?.statusMessage!)!)
        }
    }
    
    
    // Update profile
    //    Auth header(see misc1)
    //    ‘name’ key for the user name, should be 2-32 latin or cyrillic,
    //    ‘sex’ - 0 for male, 1 - for female,
    //    ‘birthdate’ - standard
    
    func userUpdate(number:String,userData:RegisterRequestData,success:@escaping (Bool) -> Void, failer: @escaping (String)->Void){
        
        let params = RegisterRequestData().JSON
        ApiClientService.postRequest(number, params: params, success: { (json:JSON) in
            print(json)
        }) { (httpError: HTTPError?) in
            failer((httpError?.statusMessage!)!)
        }
        
    }
    
    // User Login
    // JSON with ‘phone’ as phone number, and ‘password’ as the user password
    
    func userLogin(number: String, password: String, success:@escaping (UserModel) -> Void, failer: @escaping (String)->Void) {
        let params = ["phone": number, "password": password]
        
        ApiClientService.postRequest(Constants.USER_LOGIN_ENDPOINT, params: params, success: {
            (result: JSON) in
            
            let cUser = UserModel.init(json: result)
            
            DatabaseManager().currentToken = result.first?.value as? String
            cUser.currentUser = true
            RealmWrapper.sharedInstance.addObjectInRealmDB(cUser,update:DatabaseManager().currentUser != nil)
            
            success(cUser)
            
            
        }) { (httpError: HTTPError?) in
            failer((httpError?.statusMessage!)!)
        }
    }
    
    
    // Retrieve user data
    // /:phone - URL parameter
    // Auth header(see misc1)
    
    func retrieveUser(number: String, success: @escaping(UserModel) -> Void, failer: @escaping (String)->Void) {
        
        ApiClientService.getRequest(number, success: { (responce: JSON) in
            let loginUser = UserModel.init(json: responce)
            loginUser.currentUser = true
            RealmWrapper.sharedInstance.addObjectInRealmDB(loginUser, update: loginUser.currentUser == true)
            success(loginUser)
            
        }){ (httpError: HTTPError?) in
            failer((httpError?.statusMessage!)!)
        }
        
    }
    
}
