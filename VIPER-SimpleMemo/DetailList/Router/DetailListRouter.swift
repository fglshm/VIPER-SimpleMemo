//
//  DetailListRouter.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/21.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import Foundation

class DetailListRouter: DetailListWireframe {
    
    private var viewController: DetailListViewController?
    
    init(viewController: DetailListViewController) {
        self.viewController = viewController
    }
    
}
