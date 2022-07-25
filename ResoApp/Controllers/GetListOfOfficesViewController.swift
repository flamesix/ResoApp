//
//  ViewController.swift
//  ResoApp
//
//  Created by Юрий Гриневич on 12.07.2022.
//

import UIKit

final class GetListOfOfficesViewController: UIViewController {
    
    // MARK: - UIElements
    
    private lazy var getOfficesButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.backgroundColor = .lightGray
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.setTitle("Получить список \n офисов", for: .normal)
        return button
    }()
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getOfficesButton.layer.cornerRadius = 8
        getOfficesButton.frame = CGRect(x: (view.width - 200) / 2,
                                        y: (view.height - 50) / 2,
                                        width: 200,
                                        height: 50)
        getOfficesButton.addTarget(self, action: #selector(didTapGetOfficesButton), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(getOfficesButton)
    }
    
    // MARK: - Method
    
    @objc private func didTapGetOfficesButton() {
        let vc = ListOfOfficesViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

