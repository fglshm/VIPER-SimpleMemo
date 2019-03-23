//
//  DetailListPresenter.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/21.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import Foundation

class DetailListPresenter: DetailListPresentation, DetailListInteractorOutput {
   
    private var view: DetailListView?
    private var router: DetailListWireframe?
    
    private var interactor: DetailListUseCase?
    
    init(view: DetailListView, router: DetailListWireframe) {
        self.view = view
        self.router = router
        self.interactor = DetailListInteractor(output: self)
    }
    
    func viewDidLoad(categoryOf categoryId: String) {
        interactor?.read(of: categoryId)
    }
    
    func didAddButtonClicked(contents: String, category: Category) {
        if (contents.isEmpty) {
            view?.shakeTextField()
            return
        }
        interactor?.create(contentsOf: contents, categoryId: category.categoryId)
    }
    
    func didCreated(detail: Detail) {
        view?.add(item: detail)
        view?.closeBlurViewAndButtons()
    }
    
    func didRead(detail: Detail) {
        view?.add(item: detail)
    }
    
    func didUpdated() {
        
    }
    
    func didDeleted() {
        
    }
    
    
}
