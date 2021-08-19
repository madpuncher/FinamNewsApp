//
//  NewsViewModel.swift
//  FinamNewsApp
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import Foundation

class NewsTableViewModel {
    let title: String
    let author: String?
    let subtitle: String
    let imageURL: URL?
    var publishedAt: String
    var name: String
    
    init(title: String, subtitle: String, imageURL: URL?,
         author: String?, publishedAt: String, name: String) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.author = author
        self.publishedAt = publishedAt
        self.name = name
    }
    
}
