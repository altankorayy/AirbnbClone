//
//  MapViewModel.swift
//  Airbnb
//
//  Created by Altan on 28.09.2023.
//

import Foundation
import RxSwift
import RxCocoa

class MapViewModel {
    
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    let didFinishFetchData: PublishSubject<Bool> = PublishSubject()
    let coordinates: PublishSubject<[CoordinateModel]> = PublishSubject()
    
    func fetchCoordinates() {
        loading.onNext(true)
        
        DatabaseManager.shared.fetchCoordinates { [weak self] result in
            self?.loading.onNext(false)
            switch result {
            case .success(let coordinatesModel):
                self?.coordinates.onNext(coordinatesModel)
                self?.didFinishFetchData.onNext(true)
            case .failure(let error):
                self?.error.onNext(error.localizedDescription)
                self?.didFinishFetchData.onNext(false)
            }
        }
    }
}
