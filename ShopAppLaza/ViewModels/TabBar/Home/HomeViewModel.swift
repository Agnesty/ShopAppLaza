//
//  HomeViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 22/08/23.
//

import Foundation

class HomeViewModel {
    weak var delegateSearch: searchProductHomeProtocol?
    var searchTextActive: Bool = false
    
    func performSearch(with searchText: String) {
        if searchText.isEmpty {
            searchTextActive = false
        } else {
            searchTextActive = true
        }
        delegateSearch?.searchProdFetch(isActive: searchTextActive, textString: searchText)
    }
}
