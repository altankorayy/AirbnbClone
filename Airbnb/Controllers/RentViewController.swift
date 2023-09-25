//
//  RentViewController.swift
//  Airbnb
//
//  Created by Altan on 22.09.2023.
//

import UIKit
import RxSwift
import RxCocoa

class RentViewController: UIViewController {
    
    private let selectPhotoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "select")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .systemGray5
        textField.leftViewMode = .always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private let priceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .systemGray5
        textField.leftViewMode = .always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private let descTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        textView.textContainerInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        textView.font = .systemFont(ofSize: 17)
        textView.backgroundColor = .systemGray5
        return textView
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.black
        spinner.style = .medium
        return spinner
    }()
    
    private let viewModel = RentViewModel()
    let bag = DisposeBag()
    let imageRX: PublishSubject<UIImage> = PublishSubject()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(selectPhotoImage)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(descLabel)
        view.addSubview(titleTextField)
        view.addSubview(priceTextField)
        view.addSubview(descTextView)
        view.addSubview(spinnerView)
        
        setupGestureRecognizer()
        setupBindings()
        setConstraints()
        setupNavigationBar()
        
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUploadPhoto))
        selectPhotoImage.addGestureRecognizer(tapGesture)
    }
    
    func setupBindings() {
        let titleTextObservable = titleTextField.rx.text.orEmpty.asObservable()
        let priceTextObservable = priceTextField.rx.text.orEmpty.asObservable()
        let descTextObservable = descTextView.rx.text.orEmpty.asObservable()
        let selectPhotoImage = selectPhotoImage.rx.image
        
        titleTextObservable.bind(to: viewModel.titleRelay).disposed(by: bag)
        priceTextObservable.bind(to: viewModel.priceRelay).disposed(by: bag)
        descTextObservable.bind(to: viewModel.descRelay).disposed(by: bag)
        imageRX.bind(to: selectPhotoImage).disposed(by: bag)
        viewModel.imageRelay.bind(to: selectPhotoImage).disposed(by: bag)
        
        viewModel.loading.bind(to: spinnerView.rx.isAnimating).disposed(by: bag)
        viewModel.error.observe(on: MainScheduler.instance).subscribe { [weak self] errorString in
            self?.makeAlert(title: "Error", message: errorString)
        }.disposed(by: bag)
        viewModel.didFinishUpload.observe(on: MainScheduler.instance).subscribe { [weak self] completed in
            self?.makeAlert(title: "Success", message: "")
        }.disposed(by: bag)
    }
    
    private func setupNavigationBar() {
        let postButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(didTapPostButton))
        navigationItem.rightBarButtonItem = postButton
        navigationController?.navigationBar.tintColor = UIColor(red: 232/255, green: 28/255, blue: 84/255, alpha: 1)
    }
    
    @objc private func didTapUploadPhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.chooseImage(sourceType: .camera)
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.chooseImage(sourceType: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapPostButton() {
        guard let titleText = titleTextField.text, !titleText.isEmpty, let priceText = priceTextField.text, !priceText.isEmpty, let descText = descTextView.text, !descText.isEmpty else {
            makeAlert(title: "", message: "Please fill all the fields.")
            return
        }
        
        viewModel.uploadHouseInfo()
    }
    
    private func chooseImage(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    private func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissButton = UIAlertAction(title: "Dismiss", style: .default)
        alert.addAction(dismissButton)
        present(alert, animated: true)
    }
    
    private func setConstraints() {
        let selectPhotoConstraints = [
            selectPhotoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectPhotoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectPhotoImage.heightAnchor.constraint(equalToConstant: 300),
            selectPhotoImage.widthAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: selectPhotoImage.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ]
        
        let titleTextFieldConstraints = [
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleTextField.heightAnchor.constraint(equalToConstant: 35),
            titleTextField.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        let priceLabelConstraints = [
            priceLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ]
        
        let priceTextFieldConstraints = [
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            priceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            priceTextField.heightAnchor.constraint(equalToConstant: 35),
            priceTextField.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        let descLabelConstraints = [
            descLabel.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 15),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ]
        
        let descTextViewConstraints = [
            descTextView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 5),
            descTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            descTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        let spinnerViewConstraints = [
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(selectPhotoConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(titleTextFieldConstraints)
        NSLayoutConstraint.activate(priceLabelConstraints)
        NSLayoutConstraint.activate(priceTextFieldConstraints)
        NSLayoutConstraint.activate(descLabelConstraints)
        NSLayoutConstraint.activate(descTextViewConstraints)
        NSLayoutConstraint.activate(spinnerViewConstraints)
    }
    
}

extension RentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        self.imageRX.onNext(selectedImage)
        dismiss(animated: true, completion: nil)
    }
}
