//
//  HomeCategory.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/25/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

struct HomeCategory {
    let id: String
    let title: String
    let subtitle: String
    let isViewableAll: Bool
    let colors: [Int]
    let items: [CategoryItem]
    
    init(id: String = "",
         title: String = "",
         subtitle: String = "",
         isViewableAll: Bool = false,
         colors: [Int] = [0xFFFFFF, 0x000000],
         items: [CategoryItem] = []) {
        
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.isViewableAll = isViewableAll
        self.colors = colors
        self.items = items
    }
}

struct CategoryItem {
    let id: String
    let title: String
    let thumb: String
    
    init(id: String = "",
        title: String = "",
        thumb: String = "") {
        
        self.id = id
        self.title = title
        self.thumb = thumb
    }
}
