//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by 심두용 on 2023/06/16.
//

import Foundation
import RxCocoa
import RxSwift

struct FilterViewModel {
    // FilterView 외부에서 관찰
    let sortButtonTapped = PublishRelay<Void>()
}
