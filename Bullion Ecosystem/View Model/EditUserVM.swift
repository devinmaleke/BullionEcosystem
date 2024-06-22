//
//  EditUserVM.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation

class EditUserVM{
    
    private let nService = NetworkingService()
    typealias CompletionHandler = (_ message: String?, _ success:Bool)->Void
    private let token = UserDefaultService.shared.getToken()
    
    func updateUser(id: String, first_name: String, last_name:String, gender: String, date_of_birth:String, email:String, phone:String, address:String,  completion: @escaping CompletionHandler) {
        let param = ["first_name": first_name,
                     "last_name": last_name,
                     "gender": gender,
                     "date_of_birth": date_of_birth,
                     "email": email,
                     "phone": phone,
                     "address": address,]
        let endpoint = "/api/v1/admin/\(id)/update"
        nService.requestPUT(endpoint: endpoint, parameters: param, token: token, expecting: BaseModel<UserDetailModel>.self) { result in
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
//
//func updateFittingOut(refId: Int, refType: String, completion: @escaping CompletionHandler){
//    guard let id = createdFO.id else {
//        completion("Fitting out not found", false)
//        return
//    }
//    let param = createdFO.dictionaryRepresentation(propertyType: refType, refId: refId)
//    let endpoint = "/api/fitting_out/update/\(id)"
//
//    service.requestPUT(endpoint: endpoint, parameters: param, token: token, expecting: BaseResponse.self) { result in
//        switch result{
//        case.success(let respon):
//            if respon.success{
//                completion(nil, true)
//            } else {
//                completion(respon.message , false)
//            }
//        case.failure(let error):
//            print(error.localizedDescription)
//            completion("Failed to update fitting out. server error", false)
//        }
//    }
//}
