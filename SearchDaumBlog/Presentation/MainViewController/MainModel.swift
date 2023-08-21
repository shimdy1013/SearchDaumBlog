//
//  MainModel.swift
//  SearchDaumBlog
//
//  Created by 심두용 on 2023/06/16.
//

import Foundation
import RxSwift

struct MainModel {
    let network = SearchBlogNetwork()
    
    func searchNetwork(_ query: String) -> Single<Result<DaumKakaoBlog, SearchNetworkError>> {
        return network.searchBlog(query: query)
    }
    
    func getBlogValue(_ result: Result<DaumKakaoBlog, SearchNetworkError>) -> DaumKakaoBlog? {
        guard case .success(let value) = result else {
            return nil
        }
        return value
    }
    
    func getBlogError(_ result: Result<DaumKakaoBlog, SearchNetworkError>) -> String? {
        guard case .failure(let error) = result else {
            return nil
        }
        return error.localizedDescription
    }
    
    func getBlogListCellData(_ data: DaumKakaoBlog) -> [BlogListCellData] {
        return data.documents
            .map { doc in
                let thumbnail = URL(string: doc.thumbnail ?? "")
                return BlogListCellData(thumbnailURL: thumbnail, name: doc.name, title: doc.title, datetime: doc.datetime)
            }
    }
    
    func sort(by type: MainViewController.AlertAction, of data: [BlogListCellData]) -> [BlogListCellData] {
        switch type {
        case .title:
            return data.sorted { $0.title ?? "" < $1.title ?? "" }
        case .datetime:
            return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date()}
        default:
            return data
        }
    }
}
