//
//  ExploreViewModel.swift
//  Airbnb
//
//  Created by Altan on 25.09.2023.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class ExploreViewModel {
    
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    let didFinishFetch: PublishSubject<Bool> = PublishSubject()
    let houseModelSubject: PublishSubject<[HouseModel]> = PublishSubject()
    
    func fetchRentHouseInfo() {
        loading.onNext(true)
        DatabaseManager.shared.fetchRentHouseInfo { [weak self] result in
            self?.loading.onNext(false)
            switch result {
            case .success(let houseModel):
                self?.houseModelSubject.onNext(houseModel)
                self?.didFinishFetch.onNext(true)
            case .failure(let error):
                self?.error.onNext(error.localizedDescription)
                self?.didFinishFetch.onNext(false)
            }
        }
    }
}
