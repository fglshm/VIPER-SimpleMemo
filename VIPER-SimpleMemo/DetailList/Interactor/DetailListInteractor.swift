//
//  DetailListInteractor.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/21.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import Foundation
import RealmSwift

class DetailListInteractor: DetailListUseCase {
    
    private var realm: Realm?
    
    private var output: DetailListInteractorOutput?
    
    init(output: DetailListInteractorOutput) {
        self.output = output
        self.realm = try! Realm()
    }
    
    func create(contentsOf contents: String, categoryId: String) {
        let detail = Detail()
        detail.contents = contents
        detail.categoryId = categoryId
        try! realm?.write {
            realm?.add(detail)
            output?.didCreated(detail: detail)
        }
    }
    
    func read(of categoryId: String) {
        if let detailList = realm?.objects(Detail.self).filter("categoryId == '\(categoryId)'") {
            detailList.forEach { (detail) in
                output?.didRead(detail: detail)
            }
        }
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
    
    
}
