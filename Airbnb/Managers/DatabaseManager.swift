//
//  DatabaseManager.swift
//  Airbnb
//
//  Created by Altan on 21.09.2023.
//

import Foundation
import FirebaseFirestore

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
}
