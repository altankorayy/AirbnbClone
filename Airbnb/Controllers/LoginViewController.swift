//
//  LoginViewController.swift
//  Airbnb
//
//  Created by Altan on 19.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 232/255, green: 28/255, blue: 84/255, alpha: 1)
        return button
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.black
        spinner.style = .medium
        return spinner
    }()
    
    private let titleLine: UIView = {
        let titleLine = UIView()
        titleLine.translatesAutoresizingMaskIntoConstraints = false
        titleLine.backgroundColor = .systemGray4
        return titleLine
    }()
    
    private let viewModel = LoginViewModel()
    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log in"

        view.backgroundColor = .systemBackground
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(titleLine)
        view.addSubview(loginButton)
        view.addSubview(spinnerView)
        
        isModalInPresentation = true
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        setupBindings()
        setConstraints()
    }
    
    private func setupBindings() {
        let emailTextObservable = emailTextField.rx.text.orEmpty.asObservable()
        let passwordTextObservable = passwordTextField.rx.text.orEmpty.asObservable()
        
        emailTextObservable.bind(to: viewModel.emailRelay).disposed(by: bag)
        passwordTextObservable.bind(to: viewModel.passwordRelay).disposed(by: bag)
        
        viewModel.loading.bind(to: self.spinnerView.rx.isAnimating).disposed(by: bag)
        
        viewModel.error.observe(on: MainScheduler.instance).subscribe { [weak self] errorString in
            self?.makeAlert(title: "Error", message: errorString)
        }.disposed(by: bag)
        
        viewModel.didFinishLoginUser.observe(on: MainScheduler.instance).subscribe { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }.disposed(by: bag)
    }
    
    @objc private func didTapLoginButton() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            makeAlert(title: "Error", message: "Please fill all the fields.")
            return
        }
        
        viewModel.loginUser()
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissButton = UIAlertAction(title: "Dismiss", style: .default)
        alert.addAction(dismissButton)
        present(alert, animated: true)
    }

    private func setConstraints() {
        let emailTextFieldConstraints = [
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let passwordTextFieldConstraints = [
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let loginButtonConstraints = [
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let spinnerViewConstraints = [
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let titleLineConstraints = [
            titleLine.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationController?.navigationBar.frame.height ?? 0),
            titleLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLine.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(spinnerViewConstraints)
        NSLayoutConstraint.activate(titleLineConstraints)
    }
}
