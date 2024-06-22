//
//  UserDetailVM.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

class UserDetailVM{
    
    private let nService = NetworkingService()
    typealias CompletionHandler = (_ message: String?, _ success:Bool, _ data: UserDetailModel?)->Void
    private let token = UserDefaultService.shared.getToken()
    
    func getUserDetail(id:String, completion: @escaping CompletionHandler) {
        let endpoint = "/api/v1/admin/\(id)"
        nService.requestGET(endpoint: endpoint, token: token, expecting: BaseModel<UserDetailModel>.self){ result in
            
            switch result{
            case.success(let respon):
                completion(nil,true,respon.data)
            case.failure(let error):
                if let errorResponse = error as? ErrorResponse {
                    completion(errorResponse.err_message, false, nil)
                } else {
                    completion(error.localizedDescription, false, nil)
                    print(error)
                }
            }
            
        }
    }
}
