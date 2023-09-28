//
//  ExploreViewController.swift
//  Airbnb
//
//  Created by Altan on 18.09.2023.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class ExploreViewController: UIViewController {
    
    private let exploreTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExploreTableViewCell.self, forCellReuseIdentifier: ExploreTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.black
        spinner.style = .medium
        return spinner
    }()
    
    private let viewModel = ExploreViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(exploreTableView)
        view.addSubview(spinnerView)
        
        exploreTableView.rx.setDelegate(self).disposed(by: bag)
        
        setConstraints()
        configureNavigationBar()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            pushRegisterVC()
        }
        
        viewModel.fetchRentHouseInfo()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        exploreTableView.frame = view.bounds
    }
    
    private func setupBindings() {
        viewModel.loading.bind(to: spinnerView.rx.isAnimating).disposed(by: bag)
        viewModel.error.observe(on: MainScheduler.instance).subscribe { errorString in
            print(errorString)
        }.disposed(by: bag)
        viewModel.houseModelSubject.observe(on: MainScheduler.instance)
            .bind(to: exploreTableView.rx.items(cellIdentifier: ExploreTableViewCell.identifier, cellType: ExploreTableViewCell.self)) { row, item, cell in
            cell.item = item
        }.disposed(by: bag)
    }
    
    private func configureNavigationBar() {
        let logo = UIImage(named: "airbnb2")
        let imageView = UIImageView(image: logo)
        navigationItem.titleView = imageView
    }
    
    private func pushRegisterVC() {
        let registerVC = UINavigationController(rootViewController: RegisterViewController())
        present(registerVC, animated: true)
    }
    
    private func setConstraints() {
        let spinnerViewConstraints = [
        spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(spinnerViewConstraints)
    }

}

extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 410
    }
}
