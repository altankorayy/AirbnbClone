//
//  StorageManager.swift
//  Airbnb
//
//  Created by Altan on 22.09.2023.
//

import Foundation
import FirebaseStorage

enum StorageError: Error {
    case failedToGetDownloadUrl
}

class StorageManager {
    
    static let shared = StorageManager()
    let storageRef = Storage.storage().reference()
    
    func uploadImage(image: Data, randomId: String, completion: @escaping(Bool, String?) -> Void) {
        storageRef.child("images/\(randomId).jpg").putData(image, metadata: nil) { metaData, error in
            guard error == nil else {
                completion(false, error?.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    func getImageDownloadUrl(path: String, completion: @escaping(Result<URL, Error>) -> Void) {
        storageRef.child("images/\(path).jpg").downloadURL { url, error in
            guard error == nil else {
                completion(.failure(StorageError.failedToGetDownloadUrl))
                return
            }
            guard let myUrl = url else { return }
            completion(.success(myUrl))
        }
    }
}
