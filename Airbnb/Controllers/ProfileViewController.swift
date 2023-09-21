//
//  ProfileViewController.swift
//  Airbnb
//
//  Created by Altan on 18.09.2023.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(logoutButton)
        
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        setConstraints()
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
        let logoutButtonConstraints = [
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(logoutButtonConstraints)
    }

}
