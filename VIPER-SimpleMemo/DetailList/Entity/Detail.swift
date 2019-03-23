//
//  DetailItem.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/21.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import Foundation
import RealmSwift

class Detail : Object {
    @objc dynamic var contents: String = ""
    @objc dynamic var detailId: String = UUID().uuidString
    @objc dynamic var categoryId: String = ""
}
