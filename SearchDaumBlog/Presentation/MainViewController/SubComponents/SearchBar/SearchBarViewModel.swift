//
//  SearchBarViewModel.swift
//  SearchDaumBlog
//
//  Created by 심두용 on 2023/06/16.
//

import Foundation
import RxCocoa
import RxSwift

struct SearchBarViewModel {
    let queryText = PublishRelay<String?>()
    let shouldLoadResult: Observable<String>
    let searchButtonTapped = PublishRelay<Void>()

    init() {
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) {
                $1 ?? ""    // text가 nil일 때 빈 값 반환
            }
            .filter {
                !$0.isEmpty     // 빈 값일 때 거름
            }
            .distinctUntilChanged()     // 중복값 제외
    }
}
