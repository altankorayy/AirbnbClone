//
//  ProfileViewController.swift
//  Airbnb
//
//  Created by Altan on 18.09.2023.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let personImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "person")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let rentHomeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Rent your house"
        configuration.image = UIImage(named: "houselogo")
        configuration.imagePadding = 15
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.tintColor = .black
        button.backgroundColor = .systemGray5
        button.clipsToBounds = true
        return button
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.black
        spinner.style = .medium
        return spinner
    }()
    
    private let viewModel = ProfileViewModel()
    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()

        view.backgroundColor = .systemBackground
        view.addSubview(usernameLabel)
        view.addSubview(logoutButton)
        view.addSubview(rentHomeButton)
        view.addSubview(personImage)
        view.addSubview(spinnerView)
        
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBindings()
    }
    
    private func setupNavigation() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupBindings() {
        viewModel.loading.bind(to: spinnerView.rx.isAnimating).disposed(by: bag)
        
        viewModel.fetchUsername()
        
        viewModel.error.observe(on: MainScheduler.instance).subscribe { errorString in
            print(errorString)
        }.disposed(by: bag)
        
        viewModel.fetchedUsername.bind(to: usernameLabel.rx.text).disposed(by: bag)
    }
    
    @objc private func didTapLogoutButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutButton = UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            do {
                try Auth.auth().signOut()
                let registerVC = UINavigationController(rootViewController: RegisterViewController())
                self?.tabBarController?.selectedIndex = 0
                self?.present(registerVC, animated: true)
            } catch {
                print("Failed to logout")
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(logoutButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    private func setConstraints() {
        let personImageConstraints = [
            personImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            personImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            personImage.heightAnchor.constraint(equalToConstant: 64),
            personImage.widthAnchor.constraint(equalToConstant: 64)
        ]
        
        let usernameLabelConstraints = [
            usernameLabel.leadingAnchor.constraint(equalTo: personImage.trailingAnchor, constant: 10),
            usernameLabel.centerYAnchor.constraint(equalTo: personImage.centerYAnchor)
        ]
        
        let rentHomeButtonConstraints = [
            rentHomeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            rentHomeButton.topAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 50),
            rentHomeButton.heightAnchor.constraint(equalToConstant: 45),
            rentHomeButton.widthAnchor.constraint(equalToConstant: 220)
        ]
        
        let logoutButtonConstraints = [
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        let spinnerViewConstraints = [
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(personImageConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(rentHomeButtonConstraints)
        NSLayoutConstraint.activate(logoutButtonConstraints)
        NSLayoutConstraint.activate(spinnerViewConstraints)
    }

}
