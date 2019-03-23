//
//  CategoryListInteractor.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/20.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryListInteractor: CategoryListUseCase {
    
    private let TAG = "CategoryListInteractor"
    
    private var realm: Realm?
    
    private var output: CategoryListInteractorOutput?
    
    init(output: CategoryListInteractorOutput) {
        self.output = output
        realm = try! Realm()
    }
    
    func createCategory(withTitle title: String) {
        
        let category = Category()
        category.title = title
        try! realm?.write {
            realm?.add(category)
            output?.didCreate(category: category)
        }
    }
    
    func readCategory() {
        if let categoryList = realm?.objects(Category.self) {
            categoryList.forEach { (category) in
                output?.didRead(category: category)
            }
        }
    }
    
    func updateCategory() {
        print("\(TAG): createCategory")
    }
    
    func deleteCategory() {
        print("\(TAG): createCategory")
    }
}
