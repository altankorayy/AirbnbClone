//
//  ProfileViewModel.swift
//  Airbnb
//
//  Created by Altan on 21.09.2023.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class ProfileViewModel {
    
    let fetchedUsername: PublishSubject<String> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    
    func fetchUsername() {
        loading.onNext(true)
        guard let email = Auth.auth().currentUser?.email else { return }
        
        DatabaseManager.shared.fetchUsername(email: email) { [weak self] result in
            self?.loading.onNext(false)
            switch result {
            case .success(let username):
                self?.fetchedUsername.onNext(username)
            case .failure(let error):
                self?.error.onNext(error.localizedDescription)
            }
        }
    }
}
