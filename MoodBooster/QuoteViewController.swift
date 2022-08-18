//
//  QuoteViewController.swift
//  MoodBooster
//
//  Created by Inesa on 2022-06-08.
//

import UIKit
import SnapKit

class QuoteViewController: UIViewController {
    private static let jokeImage = UIImage.init(imageLiteralResourceName: "joke")
    private static let chuckImage = UIImage.init(imageLiteralResourceName: "chuck-norris")
    
    var isJokeSelected: Bool = true
    private var quoteLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateQuoteView()
    }
    
    private func generateQuoteView(){
        view.backgroundColor = .systemMint
        view.layer.borderColor = UIColor.systemCyan.cgColor
        view.layer.cornerRadius = 50
        view.layer.borderWidth = 2.0
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back for more", style: .plain, target: self, action:  #selector(backForMore))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action:  #selector(closeApp))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        let label = customLabel()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(self.view.center)
            make.leading.equalTo(self.view).offset(40)
            make.trailing.equalTo(self.view).inset(40)
        }
        quoteLabel = label
        
        let imageView = customImageView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(40)
            make.centerX.equalTo(self.view.center)
            make.height.equalTo(160)
        }
        
        let reloadButton = reloadButton()
        view.addSubview(reloadButton)
        reloadButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10.0)
            make.centerX.equalTo(self.view.center)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        reloadButton.addTarget(self, action: #selector(reloadData), for: .touchUpInside)
    }
    
    //MARK: - UI elements
    
    private func customLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.sizeToFit()
        return label
    }
    
    private func customImageView() -> UIImageView {
        let imageView = isJokeSelected ? UIImageView(image: QuoteViewController.jokeImage) : UIImageView(image: QuoteViewController.chuckImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func reloadButton() -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = .white.withAlphaComponent(0.3)
        button.clipsToBounds = true
        button.setTitle("Get New", for: .normal)
        return button
    }
    
    //MARK: - Button actions
    
    @objc private func backForMore(sender : UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func closeApp(sender : UIButton) {
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
        
    }
    
    @objc func reloadData() {
        isJokeSelected ? loadJokeData() : loadFactData()
    }
    
    //MARK: - joke button
    
    private var joke: String? {
        didSet {
            guard let joke = joke else { return }
            guard let quoteLabel = quoteLabel else { return }
            quoteLabel.text = "\(joke)"
            quoteLabel.sizeToFit()
        }
    }

    struct Joke: Decodable {
        let id: String?
        let joke: String?
        let status: Int?
        
    }
    
    @objc func loadJokeData() {
        
        guard let url = URL(string: "https://icanhazdadjoke.com/") else { return }
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("I.V.K", forHTTPHeaderField: "User-Agent")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            if let decodedData = try? JSONDecoder().decode(Joke.self, from: data) {
                DispatchQueue.main.async {
                    self.joke = decodedData.joke
                }
            }
        }
        dataTask?.resume()
    }
    
    //MARK: - Chuck Norris fact button
    
    private var dataTask: URLSessionDataTask?
    
    private var fact: String? {
        didSet {
            guard let fact = fact else { return }
            guard let quoteLabel = quoteLabel else { return }
            quoteLabel.text = "\(fact)"
            quoteLabel.sizeToFit()
        }
    }
    
    struct Fact: Decodable {
        let icon_url: String?
        let id: String?
        let url: String?
        let value: String?
        
    }
    
    @objc func loadFactData() {
        
        guard let url = URL(string: "https://api.chucknorris.io/jokes/random") else { return }
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        urlRequest.httpMethod = "GET"
        
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else{
                return
            }
            if let decodedData = try? JSONDecoder().decode(Fact.self, from: data) {
                DispatchQueue.main.async {
                    self.fact = decodedData.value
                }
            }
        }
        dataTask?.resume()
    }
}
