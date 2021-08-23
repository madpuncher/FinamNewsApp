//
//  SelectedNewsViewController.swift
//  FinamNewsApp
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import UIKit

class SelectedNewsViewController: UIViewController {
    
    //MARK: - Const
    
    private let indicator = UIActivityIndicatorView()
    
    private let newsImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOffset = .init(width: 4, height: 4)
        image.layer.shadowRadius = 10
        image.layer.shadowOpacity = 1
        
        return image
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Bold", size: 15)
        label.textAlignment = .center
        label.textColor = .systemPink
        return label
    }()
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-Bold", size: 18)
        label.textAlignment = .left
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.allowsDefaultTighteningForTruncation = true
        return label
    }()
    
    private let authorTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-Bold", size: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GillSans-LightItalic", size: 15)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.allowsDefaultTighteningForTruncation = true
        return label
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "Главное меню"

        view.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        setupConstraints()
    }
    
    //MARK: - Convert date
    private func returnedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        guard let date = dateFormatter.date(from: date) else {
            return "Error date"
        }
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date)
        
        return "Дата публикации: \(timeStamp)"
        
    }
    
    //MARK: - Layout
    private func setupConstraints() {
        
        let stackView = UIStackView(arrangedSubviews: [newsTitleLabel, subtitleLabel, authorTitleLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        
        view.addSubview(newsImage)
        view.addSubview(stackView)
        view.addSubview(indicator)

        
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newsImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newsImage.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            newsImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            indicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            indicator.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            indicator.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
    }
    
    //MARK: - Get data
    func configure(with viewModel: NewsTableViewModel) {
        
        subtitleLabel.text = viewModel.subtitle
        authorTitleLabel.text = "Источник: \(viewModel.name)"
        newsTitleLabel.text = viewModel.title
        dateLabel.text = returnedDate(date: viewModel.publishedAt)
        
        indicator.isHidden = false
        indicator.startAnimating()
        
        if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard
                    let data = data,
                    error == nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300
                else { return }
                
                DispatchQueue.main.async {
                    self?.indicator.isHidden = true
                    self?.indicator.stopAnimating()
                    self?.newsImage.image = UIImage(data: data)
                }
            }
            .resume()
        }
    }
}

//MARK: Setup Canvas
import SwiftUI

struct SelectedNewsViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .preferredColorScheme(.dark)
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            let nav = UINavigationController(rootViewController: NewsListViewController())
            return nav
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

