//
//  NetworkService.swift
//  Bullion Ecosystem
//
//  Created by Cyberindo Sinergi Sistem on 22/06/24.
//

import Foundation
import UIKit

class NetworkingService{
    let prefixURL = "https://api-test.bullionecosystem.com"
    
    //MARK: - Retrieve Data (get method)
    func requestGET<T:Decodable>(endpoint: String,
                                 token: String?,
                                 expecting: T.Type,
                                 completion: @escaping (Result<T, Error>) -> Void){
        
        
        //step 1. guard let url since we dont have data yet
        guard let url = URL(string: prefixURL + endpoint) else{
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        //step2. set request header/body
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if token != nil {
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                //if ada error print error
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                //simpan response, else tunjukin error
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                print("\(response.statusCode) - \(endpoint)")
                
                //simpan data
                if let data = data {
                    do{
                        if let user = try? JSONDecoder().decode(expecting.self, from: data){
                            completion(.success(user))
                        }else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            completion(.failure(errorResponse ))
                        }
                    }catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK: - Send Data (post method) (to create or whatever)
    func requestPOST<T:Decodable>(endpoint: String,
                                  parameters: [String: Any],
                                  token: String?,
                                  expecting: T.Type,
                                  completion: @escaping (Result<T, Error>) -> Void){
        
        //step 1. guard let url since we dont have data yet
        guard let url = URL(string: prefixURL + endpoint) else{
            completion(.failure(NetworkingError.badUrl))
            return
        }
        //step 2. set the request body/header
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if token != nil {
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
        
        
        //step 3. actual networking
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                //if ada error tunjukin error
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                //if ada response-simpan, else tunjukin error
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                print("\(response.statusCode) - \(endpoint)")
                
                //actual networking
                if let data = data {
                    do{
                        if let user = try? JSONDecoder().decode(expecting.self, from: data){
                            completion(.success(user))
                            
                        }else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            completion(.failure(errorResponse ))
                        }
                    }catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func requestPOST2<T: Decodable>(endpoint: String,
                                    parameters: [String: String],
                                    token: String?,
                                    photoURL: URL?,
                                    expecting: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        
        // Step 1: Create URL
        guard let url = URL(string: prefixURL + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        // Step 2: Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Step 3: Set Content-Type and Authorization Header if token is provided
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Step 4: Create the body of the request
        var body = Data()
        
        // Append parameters
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Append photo if provided
        if let photoURL = photoURL {
            do {
                let photoData = try Data(contentsOf: photoURL)
                let filename = photoURL.lastPathComponent
                let mimetype = "image/jpeg" // Adjust according to your file type
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
                body.append(photoData)
                body.append("\r\n".data(using: .utf8)!)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Assign the body to URLRequest
        request.httpBody = body
        
        // Perform the data task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                
                print("\(response.statusCode) - \(endpoint)")
                
                if let data = data {
                    do {
                        if let user = try? JSONDecoder().decode(expecting.self, from: data){
                            completion(.success(user))
                        } else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            completion(.failure(errorResponse))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK: - Update Data (change data)
    func requestPUT<T:Decodable>(endpoint: String,
                                 parameters: [String: Any],
                                 token: String?,
                                 expecting: T.Type,
                                 completion: @escaping (Result<T, Error>) -> Void){
        
        //step 1. guard let url since we dont have data yet
        guard let url = URL(string: prefixURL + endpoint) else{
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        //step 2. set the request body/header
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if token != nil {
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
        
        //step 3. actual networking
        URLSession.shared.dataTask(with: request){ (data, res, error) in
            DispatchQueue.main.async {
                
                
                //print error kalau ada
                if error != nil {
                    completion(.failure(error!))
                }
                
                //if ada response-simpan, else tunjukin error
                guard let response = res as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                print("\(response.statusCode) - \(endpoint)")
                
                //cek data ada tidak
                if let data = data {
                    do{
                        if let user = try? JSONDecoder().decode(expecting.self, from: data){
                            completion(.success(user))
                            
                        }else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            completion(.failure(errorResponse ))
                        }
                    }catch {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
}

enum NetworkingError: Error{
    case badUrl
    case badResponse
}
