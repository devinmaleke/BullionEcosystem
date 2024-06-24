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
    
    private var offset = 0
    private let limit = 5
    private var hasMoreData = true
    
    var userList = [UserModel]()
    
    func getUserListPaging(completion: @escaping CompletionHandler) {
        guard hasMoreData else {
            completion(nil, true, userList)
            return
        }
        
        let endpoint = "/api/v1/admin?offset=\(offset)&limit=\(limit)"
        nService.requestGET(endpoint: endpoint, token: token, expecting: BaseModel<[UserModel]>.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let respon):
                if let data = respon.data {
                    if data.isEmpty || data.count < limit {
                        hasMoreData = false
                    }
                    userList.append(contentsOf: data)
                    offset += limit
                    completion(nil, true, userList)
                } else {
                    self.hasMoreData = false
                    completion(nil, true, userList)
                }
            case .failure(let error):
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
    
    func resetData(){
        offset = 0
        userList.removeAll()
        hasMoreData = true
    }
}
