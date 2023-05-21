//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by 심두용 on 2023/05/21.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}

