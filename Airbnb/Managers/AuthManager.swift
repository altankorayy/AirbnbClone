//
//  AuthManager.swift
//  Airbnb
//
//  Created by Altan on 20.09.2023.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa

class AuthManager {
    
    static let shared = AuthManager()
    
    func registerUser(email: String, password: String, completion: @escaping(Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authdata, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping(Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authdata, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
}
