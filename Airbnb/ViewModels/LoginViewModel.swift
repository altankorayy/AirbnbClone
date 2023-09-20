//
//  LoginViewModel.swift
//  Airbnb
//
//  Created by Altan on 20.09.2023.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    let emailRelay = BehaviorRelay<String>(value: "")
    let passwordRelay = BehaviorRelay<String>(value: "")
    
    let error: PublishSubject<String> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let didFinishLoginUser: PublishSubject<Bool> = PublishSubject()
    
    func loginUser() {
        loading.onNext(true)
        let email = emailRelay.value
        let pasword = passwordRelay.value
        
        AuthManager.shared.loginUser(email: email, password: pasword) { [weak self] completed, errorString in
            self?.loading.onNext(false)
            if let error = errorString {
                self?.error.onNext(error)
                self?.didFinishLoginUser.onNext(false)
            } else if completed {
                self?.didFinishLoginUser.onNext(true)
            }
        }
    }
}
