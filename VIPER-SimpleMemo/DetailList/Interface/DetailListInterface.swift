//
//  DetailListInterface.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/21.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import Foundation

protocol DetailListView {
    
    func closeBlurViewAndButtons()
    
    func add(item: Detail)
    
    func shakeTextField()
}

protocol DetailListUseCase {
    
    func create(contentsOf contents: String, categoryId: String)
    
    func read(of categoryId: String)
    
    func update()
    
    func delete()
}

protocol DetailListPresentation {
    
    func didAddButtonClicked(contents: String, category: Category)
    
    func viewDidLoad(categoryOf title: String)
    
}

protocol DetailListInteractorOutput {
    
    func didCreated(detail: Detail)
    
    func didRead(detail: Detail)
    
    func didUpdated()
    
    func didDeleted()
    
}

protocol DetailListWireframe {
    
}
