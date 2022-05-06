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
    
    lazy var dragonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Dragons")
        
        return imageView
    }()
    
    lazy var decodeJSONBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decode JSON", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo
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
        self.alertView.addSubview(self.dragonImage)
        
        self.dragonImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        self.dragonImage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        self.dragonImage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        self.dragonImage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
        
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
        var base = "\(dragons.pokemon.compactMap({ $0.pokemon.name }))"
        for _ in base {
            if let clean = base.firstIndex(of: ",") {
                base.remove(at: clean)
            }
            if let clean = base.firstIndex(of: "[") {
                base.remove(at: clean)
            }
            if let clean = base.firstIndex(of: "]") {
                base.remove(at: clean)
            }
            if let clean = base.firstIndex(of: "\"") {
                base.remove(at: clean)
            }
        }
        let messageString = base.replacingOccurrences(of: " ", with: "\n")
        let alert = UIAlertController(title: "Dragon-Types\n", message: messageString, preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.view.tintColor = .systemIndigo
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view ?? alertView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.5)
        alert.view.addConstraint(height)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

