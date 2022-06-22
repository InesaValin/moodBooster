//
//  ViewController.swift
//  MoodBooster
//
//  Created by Inesa on 2022-06-07.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private static let backgroundImage = UIImage.init(imageLiteralResourceName: "backgroundImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIElements()
    }
    
    private func setUpUIElements(){
        let imageView = UIImageView(image: ViewController.backgroundImage)
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(view.frame.size.height / 2)
        }
        
        let jokeButton = customButton(title: "Get a Dad Joke")
        view.addSubview(jokeButton)
        let factButton = customButton(title: "Get a Chuck Norris fact")
        view.addSubview(factButton)
        
        let offset = 20.0
        let height = 40.0
        
        jokeButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.equalTo(self.view).offset(offset)
            make.trailing.equalTo(self.view).offset(-offset)
            make.height.equalTo(height)
        }
        jokeButton.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        
        factButton.snp.makeConstraints { make in
            make.top.equalTo(jokeButton.snp.bottom).offset(offset / 2)
            make.leading.equalTo(self.view).offset(offset)
            make.trailing.equalTo(self.view).offset(-offset)
            make.height.equalTo(height)
        }
        
        factButton.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
    }
    
    //MARK: - UI elements
    
    private func customButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 40.0
        button.layer.borderColor = UIColor.systemCyan.cgColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .heavy)
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true
        button.backgroundColor = .systemMint
        button.setTitle(title, for: .normal)
        return button
    }
    
    //MARK: - Button actions
    
    @objc private func buttonTapped(sender : UIButton) {
        let quoteViewController = QuoteViewController()
        let navigationController = UINavigationController(rootViewController: quoteViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
        
        if sender.titleLabel?.text == "Get a Dad Joke" {
            quoteViewController.isJokeSelected = true
            quoteViewController.loadJokeData()
        } else {
            quoteViewController.isJokeSelected = false
            quoteViewController.loadFactData()
        }
    }
    
}

