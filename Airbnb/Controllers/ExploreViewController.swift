//
//  ExploreViewController.swift
//  Airbnb
//
//  Created by Altan on 18.09.2023.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let exploreTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExploreTableViewCell.self, forCellReuseIdentifier: ExploreTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(exploreTableView)
        
        exploreTableView.delegate = self
        exploreTableView.dataSource = self
        
        pushRegisterVC()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        exploreTableView.frame = view.bounds
    }
    
    private func pushRegisterVC() {
        let registerVC = UINavigationController(rootViewController: RegisterViewController())
        present(registerVC, animated: true)
    }

}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExploreTableViewCell.identifier, for: indexPath) as? ExploreTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
