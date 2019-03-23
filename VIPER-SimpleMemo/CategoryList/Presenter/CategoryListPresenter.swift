//
//  CategoryListPresenter.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/20.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import Foundation

class CategoryListPresenter : CategoryListPresentation, CategoryListInteractorOutput {
    
    private var view: CategoryListView?
    private var router: CategoryListWireframe?
    
    private var interactor: CategoryListUseCase?
    
    init(view: CategoryListView, router: CategoryListWireframe) {
        self.view = view
        self.router = router
        self.interactor = CategoryListInteractor(output: self)
    }
    
    func didCheckButtonTapped(titleWith title: String?) {
        guard let categoryTitle = title else {
            return
        }
        
        if categoryTitle.isEmpty {
            view?.shakeTextField()
            return
        }
        
        interactor?.createCategory(withTitle: categoryTitle)
    }
    
    func fetchCategory() {
        interactor?.readCategory()
    }
    
    func didItemSelected(of category: Category) {
        router?.presentDetailListViewController(with: category)
    }
    
    func didCreate(category: Category) {
        view?.add(category: category)
        view?.closeBlurViewAndButtons()
    }
    
    func didRead(category: Category) {
        view?.add(category: category)
    }
    
    func didUpdate() {
        
    }
    
    func didDelete() {
        
    }
    
}
