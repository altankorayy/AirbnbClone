//
//  MapViewController.swift
//  Airbnb
//
//  Created by Altan on 18.09.2023.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
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
    private let viewModel = MapViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        view.addSubview(spinnerView)
        
        mapView.delegate = self
        
        setConstraints()
        requestLocation()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapView.frame = view.bounds
    }
    
    private func setupBindings() {
        viewModel.loading.bind(to: spinnerView.rx.isAnimating).disposed(by: bag)
        viewModel.error.observe(on: MainScheduler.instance).subscribe { errorString in
            print(errorString)
        }.disposed(by: bag)
        viewModel.didFinishFetchData.observe(on: MainScheduler.instance).subscribe { completed in
            if completed {
                print("success")
            } else {
                print("failed")
            }
        }.disposed(by: bag)
        viewModel.coordinates.subscribe { [weak self] coordinateModels in
            var annotations = [MKPointAnnotation]()
            for coordinateModel in coordinateModels {
                let annonation = MKPointAnnotation()
                annonation.coordinate = CLLocationCoordinate2D(latitude: coordinateModel.latitude ?? 0.0, longitude: coordinateModel.longitude ?? 0.0)
                annonation.title = "Airbnb House"
                annotations.append(annonation)
            }
            self?.mapView.addAnnotations(annotations)
        }.disposed(by: bag)
        
        viewModel.fetchCoordinates()
    }

    private func requestLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setConstraints() {
        let spinnerViewConstraints = [
        spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(spinnerViewConstraints)
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.tintColor = .label
            
            let detailButton = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = detailButton
        } else {
            pinView?.annotation = annotation
        }
        
        pinView?.image = UIImage(named: "pin")
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        
        let destinationCoordinate = annotation.coordinate
        let requestLocation = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
            guard let placemark = placemarks else { return }
            
            if placemark.count > 0 {
                let newPlacemark = MKPlacemark(placemark: placemark[0])
                let item = MKMapItem(placemark: newPlacemark)
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                item.name = "Airbnb House"
                item.openInMaps(launchOptions: launchOptions)
            }
        }
        
    }
}
