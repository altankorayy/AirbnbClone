//
//  RegisterViewModel.swift
//  Airbnb
//
//  Created by Altan on 20.09.2023.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class RegisterViewModel {
    
    let usernameRelay = BehaviorRelay<String>(value: "")
    let emailRelay = BehaviorRelay<String>(value: "")
    let passwordRelay = BehaviorRelay<String>(value: "")
    
    let didRegisterUser: PublishSubject<Bool> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    
    //MARK: - Making observable object for BehaviorRelay
    var usernameObservable: Observable<String> {
        return usernameRelay.asObservable()
    }
    
    var emailObservable: Observable<String> {
        return emailRelay.asObservable()
    }
    
    var passwordObservable: Observable<String> {
        return passwordRelay.asObservable()
    }
    
    func updateUsername(_ username: String) {
        usernameRelay.accept(username)
    }
    
    func updateEmail(_ email: String) {
        emailRelay.accept(email)
    }
    
    func updatePassword(_ password: String) {
        passwordRelay.accept(password)
    }
    
    func registerUser() {
        loading.onNext(true)
        
        let username = usernameRelay.value
        let email = emailRelay.value
        let password = passwordRelay.value
        
        AuthManager.shared.registerUser(username: username, email: email, password: password) { [weak self] completed, error in
            self?.loading.onNext(false)
            if let error = error {
                self?.error.onNext(error)
                self?.didRegisterUser.onNext(false)
            } else if completed {
                self?.didRegisterUser.onNext(true)
            }
        }
    }
}
