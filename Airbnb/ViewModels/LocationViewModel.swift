//
//  LocationViewModel.swift
//  Airbnb
//
//  Created by Altan on 27.09.2023.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class LocationViewModel {
    
    let latitudeRelay = BehaviorRelay<Double?>(value: nil)
    let longitudeRelay = BehaviorRelay<Double?>(value: nil)
    
    let didFinishUpload: PublishSubject<Bool> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<String?> = PublishSubject()
    
    func uploadCoordinates() {
        loading.onNext(true)
        guard let latitude = latitudeRelay.value else { return }
        guard let longitude = longitudeRelay.value else { return }
        DatabaseManager.shared.uploadCoordinates(latitude: latitude, longitude: longitude) { [weak self] success, errorString in
            self?.loading.onNext(false)
            if let error = errorString {
                self?.error.onNext(errorString)
                self?.didFinishUpload.onNext(false)
            } else if success {
                self?.didFinishUpload.onNext(true)
            }
        }
    }
}
