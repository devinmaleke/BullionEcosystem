//
//  LoginVM.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

class LoginVM{
    
    private let nService = NetworkingService()
    typealias CompletionHandler = (_ message: String?, _ success:Bool)->Void
    
    func signInUser(email:String, password:String, completion: @escaping CompletionHandler) {
        let param = ["email": email, "password": password]
        let endpoint = "/api/v1/auth/login"
        nService.requestPOST(endpoint: endpoint, parameters: param, token: nil, expecting: BaseModel<LoginModel>.self)
        { result in
            switch result {
            case.success(let respon):
                UserDefaultService.shared.saveToken(respon.data?.token ?? "")
                completion(nil,true)
            case.failure(let error):
                if let errorResponse = error as? ErrorResponse {
                    completion(errorResponse.err_message, false)
                    print(errorResponse.err_message)
                } else {
                    completion(error.localizedDescription, false)
                    print(error)
                }
            }
        }
    }
}
