//
//  ViewController.swift
//  ProjectLocationAlertChallenge
//
//  Created by Leonardo Maia Pugliese on 04/06/20.
//  Copyright © 2020 Leonardo Maia Pugliese. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let randomButtom = UIButton()
    let titleLabel = UILabel()
    
    let padding : CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureUI()
    }
    
    func configureUI() {
        configureLabel()
        configureButton()
    }

    func configureLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Go Neon! Mask Localized POC"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .label
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureButton() {
        view.addSubview(randomButtom)
        randomButtom.translatesAutoresizingMaskIntoConstraints = false
        randomButtom.setTitle("Generate Location", for: .normal)
        randomButtom.layer.cornerRadius = 12
        
        
        NSLayoutConstraint.activate([
            randomButtom.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            randomButtom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            randomButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            randomButtom.heightAnchor.constraint(equalToConstant: 50)
        
        ])
        
    }

}

