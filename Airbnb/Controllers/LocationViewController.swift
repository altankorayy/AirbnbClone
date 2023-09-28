//
//  LocationViewController.swift
//  Airbnb
//
//  Created by Altan on 27.09.2023.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import CoreLocation

class DataStore {
    static let shared = DataStore()
    
    var chosenLatitude: Double = 0.0
    var chosenLongitude: Double = 0.0
}

class LocationViewController: UIViewController {
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.black
        spinner.style = .medium
        return spinner
    }()
    
    var locationManager = CLLocationManager()
    private let viewModel = LocationViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Location"
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        view.addSubview(spinnerView)
        
        setConstraints()
        setNavigationBar()
        
        mapView.delegate = self
        locationManager.delegate = self
        requestLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.loading.bind(to: spinnerView.rx.isAnimating).disposed(by: bag)
        viewModel.error.observe(on: MainScheduler.instance).subscribe { errorString in
            print(errorString)
        }.disposed(by: bag)
        viewModel.didFinishUpload.observe(on: MainScheduler.instance).subscribe { [weak self] completed in
            if completed {
                self?.dismiss(animated: true, completion: nil)
            }
        }.disposed(by: bag)
    }
    
    private func requestLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func didTapSaveButton() {
        viewModel.uploadCoordinates()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: mapView)
            let touchedCoordinates = mapView.convert(touchedPoint, toCoordinateFrom: mapView)
            
            let chosenLatitude = touchedCoordinates.latitude
            let chosenLongitude = touchedCoordinates.longitude
            
            viewModel.latitudeRelay.accept(chosenLatitude)
            viewModel.longitudeRelay.accept(chosenLongitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = "Your House"
            mapView.addAnnotation(annotation)
        }
    }
    
    private func setNavigationBar() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveButton
        navigationController?.navigationBar.tintColor = UIColor(red: 232/255, green: 28/255, blue: 84/255, alpha: 1)
    }
    
    private func setConstraints() {
        let mapViewConstraints = [
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let spinnerViewConstraints = [
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(mapViewConstraints)
        NSLayoutConstraint.activate(spinnerViewConstraints)
    }

}

extension LocationViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
}
