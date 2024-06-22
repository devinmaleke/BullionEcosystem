//
//  RegisterUserVM.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

class RegisterUserVM{
    
    private let nService = NetworkingService()
    typealias CompletionHandler = (_ message: String?, _ success:Bool)->Void
    
    func registerUser(first_name: String, last_name:String, gender:String, date_of_birth:String, email:String, phone:String, address:String, photo:URL, password:String, completion: @escaping CompletionHandler) {
        let param = ["first_name": first_name,
                     "last_name": last_name,
                     "gender": gender,
                     "date_of_birth": date_of_birth,
                     "email": email,
                     "phone": phone,
                     "address": address,
                     "password": password]
        let endpoint = "/api/v1/auth/register"
        nService.requestPOST2(endpoint: endpoint, parameters: param, token: nil, photoURL: photo, expecting: BaseModel<RegisterUserModel>.self)
        { result in
            switch result {
            case.success(let respon):
                completion(respon.message,true)
            case.failure(let error):
                if let errorResponse = error as? ErrorResponse {
                    completion(errorResponse.err_message, false)
                    print(errorResponse)
                } else {
                    completion(error.localizedDescription, false)
                    print(error.localizedDescription)
                }
            }
        }
    }
}
