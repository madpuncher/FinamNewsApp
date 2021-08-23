//
//  ViewController.swift
//  FinamNewsApp
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import UIKit

class NewsListViewController: UIViewController {
    
    //MARK: - Const
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        return table
    }()
    
    let segmentControl = UISegmentedControl(items: ["Все", "Спорт", "Здоровье", "Бизнес"])
        
    private var viewModels = [NewsTableViewModel]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        tableView.delegate = self
        
        settingUI()
        
        view.addSubview(tableView)
        
        getNews(type: 0)
        
        segmentControl.addTarget(self,
                                 action: #selector(segmentedValueChanged),
                                 for: .valueChanged)
                
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Layout and UI
    private func settingUI() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tableView.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .gray
        
        createHeader()
    }
    
    private func createHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))
        tableView.tableHeaderView = headerView
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EEE, d MMMM"
        let dateString = dateFormatter.string(from: date)
        
        let dateLabel = UILabel()
        dateLabel.text = String(dateString)
        dateLabel.textColor = .secondaryLabel
        
        let titleLabel = UILabel()
        titleLabel.text = "Свежие новости"
        titleLabel.font = UIFont(name: "Avenir-Black", size: 20)
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel,titleLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(segmentControl)
        headerView.addSubview(stackView)
       
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            segmentControl.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
        ])
        
    }
    
    @objc private func segmentedValueChanged() {
        let segmentIndex = segmentControl.selectedSegmentIndex
        getNews(type: segmentIndex)
    }
    
    //MARK: - Download news with NetworkManager
    private func getNews(type: Int) {
        NetworkManager.shared.getNews(newsType: type) {[weak self] result in
            switch result {
            case .success(let news):
                self?.viewModels = news.compactMap({
                    NewsTableViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No description",
                        imageURL: URL(string: $0.urlToImage ?? ""),
                        author: $0.author,
                        publishedAt: $0.publishedAt,
                        name: $0.source.name
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

    }
}

//MARK: DELEGATE AND DATA SOURCE TABLE VIEW
extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = SelectedNewsViewController()
        secondVC.configure(with: viewModels[indexPath.row])
        self.navigationController?.pushViewController(secondVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
}

//MARK: Setup Canvas
import SwiftUI

struct ViewControllerProvider: PreviewProvider {
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

