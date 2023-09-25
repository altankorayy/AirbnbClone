//
//  RentViewModel.swift
//  Airbnb
//
//  Created by Altan on 22.09.2023.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import UIKit

class RentViewModel {
    
    let titleRelay = BehaviorRelay<String>(value: "")
    let priceRelay = BehaviorRelay<String>(value: "")
    let descRelay = BehaviorRelay<String>(value: "")
    let imageRelay = BehaviorRelay<UIImage>(value: UIImage(named: "select") ?? UIImage())
    
    let loading: PublishSubject<Bool> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    let didFinishUpload: PublishSubject<Bool> = PublishSubject()
    let urlString: PublishSubject<String> = PublishSubject()
    
    func uploadHouseInfo() {
        loading.onNext(true)
        
        guard let email = Auth.auth().currentUser?.email else { return }
        let title = titleRelay.value
        let price = priceRelay.value
        let desc = descRelay.value
        let myImage = imageRelay.value
        let uuid = UUID().uuidString
        guard let image = myImage.jpegData(compressionQuality: 0.5) else { return }
        
        StorageManager.shared.uploadImage(image: image, randomId: uuid) { [weak self] success, errorString in
            self?.loading.onNext(false)
            if let error = errorString {
                self?.error.onNext(error)
                self?.didFinishUpload.onNext(false)
            } else if success {
                StorageManager.shared.getImageDownloadUrl(path: uuid) { result in
                    switch result {
                    case .success(let url):
                        let urlString = url.absoluteString
                        
                        DatabaseManager.shared.uploadRentHouseInfo(url: urlString, title: title, price: price, desc: desc, email: email) { success, errorString in
                            if let error = errorString {
                                self?.error.onNext(error)
                                self?.didFinishUpload.onNext(false)
                            } else if success {
                                self?.didFinishUpload.onNext(true)
                            }
                        }
                    case .failure(let error):
                        self?.error.onNext(error.localizedDescription)
                        self?.didFinishUpload.onNext(false)
                    }
                }
            }
        }
    }
}
