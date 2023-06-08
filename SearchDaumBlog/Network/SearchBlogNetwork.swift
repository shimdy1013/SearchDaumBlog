//
//  SearchBlogNetwork.swift
//  SearchDaumBlog
//
//  Created by 심두용 on 2023/05/25.
//

import Foundation
import RxSwift

enum SearchNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
}

class SearchBlogNetwork {
    private let session: URLSession
    let api = SearchBlogAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchBlog(query: String) -> Single<Result<DaumKakaoBlog, SearchNetworkError>> {
        // 네트워크는 성공 or 실패 -> Single
        // Result<Success, failure>는 enum 유형으로 성공과 실패 두 가지
        
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        //var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 820e80014bffc814b1c6d5e49baa517d", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)    // request에 대한 응답 -> Observable<Data>
            .asSingle()
            .map { data in
                do {
                    let blogData = try JSONDecoder().decode(DaumKakaoBlog.self, from: data)
                    return .success(blogData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                .just(.failure(.networkError))
            }
    }
}
