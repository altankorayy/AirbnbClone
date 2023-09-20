//
//  ExploreTableViewCell.swift
//  Airbnb
//
//  Created by Altan on 18.09.2023.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {

    static let identifier = "ExploreTableViewCell"
    
    private let houseImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "house")
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Laya Bungalow"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Luxury bungalow you have ever seen. Please contact for any details."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$127 night"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(houseImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(priceLabel)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        let houseImageViewConstraints = [
            houseImageView.topAnchor.constraint(equalTo: topAnchor),
            houseImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            houseImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            houseImageView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: houseImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        
        let priceLabelConstraints = [
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ]
        
        NSLayoutConstraint.activate(houseImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(priceLabelConstraints)
    }
}
