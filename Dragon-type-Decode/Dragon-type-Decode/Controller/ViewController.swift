//
//  ViewController.swift
//  Dragon-type-Decode
//
//  Created by Frederic Rey Llanos on 05/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var alertView: UIView = {
       let aView = UIView()
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.backgroundColor = .white
        aView.layer.cornerRadius = 25.0
        
        return aView
    }()
    
    lazy var decodeJSONBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decode JSON", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 20.0
        button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .gray
        self.view.addSubview(self.alertView)
        self.view.addSubview(self.decodeJSONBtn)
        
        self.alertView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.alertView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.alertView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.alertView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        
        self.decodeJSONBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive =  true
        self.decodeJSONBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive =  true
        self.decodeJSONBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive =  true
        self.decodeJSONBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    @objc
    func buttonPressed() {
        guard let dragons = NetworkManager.shared.getDragonsManually() else {
            print("Network Error")
            return }
        presentAlert(dragons: dragons)
    }
    
    func presentAlert(dragons: Dragons) {
        let alert = UIAlertController(title: "Dragons", message: "\(dragons.pokemon.map({ $0.pokemans.name }))\n", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

