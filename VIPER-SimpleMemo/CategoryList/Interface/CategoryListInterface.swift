//
//  CategoryListInterface.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/20.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import Foundation

protocol CategoryListView {
    
    func shakeTextField()
    
    func closeBlurViewAndButtons()
    
    func add(category: Category)
}

protocol CategoryListUseCase {
    
    // CRUD - create
    func createCategory(withTitle title: String)
    
    // CRUD - read
    func readCategory()
    
    // CRUD - update
    func updateCategory()
    
    // CRUD - delete
    func deleteCategory()
}

protocol CategoryListInteractorOutput {
    
    func didCreate(category: Category)
    
    func didRead(category: Category)
    
    func didUpdate()
    
    func didDelete()
}

protocol CategoryListPresentation {
    
    func didCheckButtonTapped(titleWith title: String?)
    
    func fetchCategory()
    
    func didItemSelected(of category: Category)
}

protocol CategoryListWireframe {
    
    func presentDetailListViewController(with category: Category)
}
