//
//  ViewController.swift
//  FinamNewsApp
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import UIKit

class NewsListViewController: UIViewController {
    
    //MARK: - Const
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        
        return table
    }()
        
    private var viewModels = [NewsTableViewModel]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        settingUI()
        
        view.addSubview(tableView)
        
        setupSearchBar()
        
        getNews(searchText: "")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    //MARK: - Layout and UI
    private func settingUI() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Новости"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tableView.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .gray
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - Download news with NetworkManager
    private func getNews(searchText: String) {
        NetworkManager.shared.getNews(keyWord: searchText) {[weak self] result in
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

//MARK: Search controller
extension NewsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getNews(searchText: searchText)
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

