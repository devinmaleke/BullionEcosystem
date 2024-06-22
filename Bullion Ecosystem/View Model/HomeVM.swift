//
//  HomeVM.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

class HomeVM{
    
    private let nService = NetworkingService()
    typealias CompletionHandler = (_ message: String?, _ success:Bool, _ data: [UserModel]?)->Void
    private let token = UserDefaultService.shared.getToken()
    
    func getUserList(completion: @escaping CompletionHandler) {
        let endpoint = "/api/v1/admin?offset=5&limit=5"
        nService.requestGET(endpoint: endpoint, token: token, expecting: BaseModel<[UserModel]>.self){ result in
            
            switch result{
            case.success(let respon):
                completion(nil,true,respon.data ?? [])
            case.failure(let error):
                if let errorResponse = error as? ErrorResponse {
                    completion(errorResponse.err_message, false, nil)
                    print(errorResponse.err_message)
                } else {
                    completion(error.localizedDescription, false, nil)
                    print(error)
                }
            }
            
        }
    }
}
