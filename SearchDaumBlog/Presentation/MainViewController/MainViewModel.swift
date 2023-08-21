//
//  MainViewModel.swift
//  SearchDaumBlog
//
//  Created by 심두용 on 2023/06/16.
//

import Foundation
import RxCocoa
import RxSwift

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    let shouldPresentAlert: Signal<MainViewController.Alert>

    
    init(model: MainModel = MainModel()) {
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest {
                model.searchNetwork($0)
                // Single<Result<DaumKakaoBlog, SearchNetworkError>>
            }
            .share()
            
        let blogValue = blogResult  // Observable<DaumKakaoBlog>
            .compactMap {
                model.getBlogValue($0)
            }
        
        let blogError = blogResult
            .compactMap {
                model.getBlogError($0)
            }
        
        // 네트워크로 가져온 데이터를 cellData로 변환
        let cellData = blogValue
            .map {
                model.getBlogListCellData($0)
            }
        
        // FilterView를 선택했을 때 나오는 alertSheet를 선택했을 때 type
        let sortedtype = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        // MainViewController -> ListView
        Observable
            .combineLatest(
                cellData,
                sortedtype
            ) { data, type -> [BlogListCellData] in
                return model.sort(by: type, of: data)
            }
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return (
                    title: "오류",
                    message: "예상치 못한 오류가 발생하였습니다. \(message)",
                    actions: [.confirm],
                    style: .alert)
            }
        
        self.shouldPresentAlert = Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
    }
}
