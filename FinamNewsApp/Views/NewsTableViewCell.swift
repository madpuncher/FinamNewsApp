//
//  NewTableViewCell.swift
//  FinamNewsApp
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    //MARK: - Const
    static let identifier = "newsCell"
        
    private let indicator = UIActivityIndicatorView()
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .gray
        return label
    }()
    
    //MARK: - Initialisation
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsTitleLabel.text = nil
        newsImageView.image = nil
        nameLabel.text = nil
    }
    
    //MARK: - Setup constraints
    private func setupConstraints() {
        
        let chevronRight = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronRight.tintColor = .white
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(indicator)
        contentView.addSubview(chevronRight)

        self.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)

        indicator.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronRight.translatesAutoresizingMaskIntoConstraints = false
        
        let rectangleOne = UIView()
        rectangleOne.backgroundColor = .gray
        
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            newsImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            newsImageView.heightAnchor.constraint(equalToConstant: 90),
            newsImageView.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 90),
            indicator.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 16),
            newsTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            newsTitleLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            chevronRight.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevronRight.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    //MARK: - Get data
    func configure(with viewModel: NewsTableViewModel) {
        newsTitleLabel.text = viewModel.title
        nameLabel.text = "Источник: \(viewModel.name)"
        
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
                    self?.newsImageView.image = UIImage(data: data)
                }
            }
            .resume()
        }
    }
}

//MARK: Setup Canvas
import SwiftUI

struct CellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView()
            .edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            NewsListViewController()
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

