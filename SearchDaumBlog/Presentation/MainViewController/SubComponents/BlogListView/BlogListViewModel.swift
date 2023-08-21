//
//  BlogListViewModel.swift
//  SearchDaumBlog
//
//  Created by 심두용 on 2023/06/16.
//

import Foundation
import RxCocoa
import RxSwift

struct BlogListViewModel {
    let filterViewModel = FilterViewModel()
    
    // MainViewController -> BlogListView
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init() {
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
}

