//
//  CategoryListRouter.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/20.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import Foundation


class CategoryListRouter: CategoryListWireframe {
    
    private var viewController: CategoryListViewController?
    
    init(viewController: CategoryListViewController) {
        self.viewController = viewController
    }
    
    func presentDetailListViewController(with category: Category) {
        let detailListViewController = DetailListViewController()
        detailListViewController.category = category
        viewController?.navigationController?.pushViewController(detailListViewController, animated: true)
    }
    
}
