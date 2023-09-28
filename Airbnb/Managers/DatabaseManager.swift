//
//  DatabaseManager.swift
//  Airbnb
//
//  Created by Altan on 21.09.2023.
//

import Foundation
import FirebaseFirestore
import CoreLocation

enum FirebaseError: Error {
    case getDocumentError
    case documentFindError
    case documentFetchError
}

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let database = Firestore.firestore()
    
    func fetchUsername(email: String, completion: @escaping(Result<String, Error>) -> Void) {
        database.collection("users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            guard error == nil else {
                completion(.failure(FirebaseError.getDocumentError))
                return
            }
            
            if let document = querySnapshot?.documents.first {
                if let username = document.data()["username"] as? String {
                    completion(.success(username))
                } else {
                    completion(.failure(FirebaseError.documentFetchError))
                }
            } else {
                print("3")
                completion(.failure(FirebaseError.documentFindError))
            }
            
        }
    }
    
    func uploadRentHouseInfo(url: String, title: String, price: String, desc: String, email: String, completion: @escaping(Bool, String?) -> Void) {
        let houseData: [String: Any] = ["url": url, "title": title, "price": price, "desc": desc, "email": email]
        database.collection("houses").addDocument(data: houseData) { error in
            guard error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    func fetchRentHouseInfo(completion: @escaping(Result<[HouseModel], Error>) -> Void) {
        var houseModel = [HouseModel]()
        
        database.collection("houses").getDocuments { querySnapshot, error in
            guard error == nil else {
                completion(.failure(FirebaseError.getDocumentError))
                return
            }
            
            for document in querySnapshot?.documents ?? [] {
                guard let title = document.get("title") as? String,
                    let price = document.get("price") as? String,
                    let desc = document.get("desc") as? String,
                    let imageUrl = document.get("url") as? String else {
                        return
                }
                
                let model = HouseModel(title: title, price: price, description: desc, imageUrl: imageUrl)
                houseModel.append(model)
            }
            
            completion(.success(houseModel))
        }
    }
    
    func uploadCoordinates(latitude: Double, longitude: Double, completion: @escaping(Bool, String?) -> Void) {
        let coordinateData: [String: Any] = ["latitude": latitude, "longitude": longitude]
        database.collection("coordinates").addDocument(data: coordinateData) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func fetchCoordinates(completion: @escaping(Result<[CoordinateModel], Error>) -> Void) {
        var coordinateModel = [CoordinateModel]()
        
        database.collection("coordinates").getDocuments { querySnapshot, error in
            guard error == nil else {
                completion(.failure(FirebaseError.getDocumentError))
                return
            }
            
            for document in querySnapshot?.documents ?? [] {
                guard let latitude = document.get("latitude") as? Double,
                      let longitude = document.get("longitude") as? Double else {
                    completion(.failure(FirebaseError.documentFindError))
                    return
                }
                let model = CoordinateModel(latitude: latitude, longitude: longitude)
                coordinateModel.append(model)
            }
            completion(.success(coordinateModel))
        }
    }
}
