## 다음 블로그 검색 앱
작업 툴 : Swift, Xcode, SnapKit, OpenAPI, RxSwift, MVVM
#### 앱 소개
* 다음 블로그를 키워드로 검색할 수 있는 기능을 구현
* MVVM 패턴으로 리팩토링
#### 실행 화면
![SearchDaumBlog](https://github.com/shimdy1013/SearchDaumBlog/assets/79740101/81cd18c1-d44c-47c2-91b3-68bdf359dfa6)
#### 코드 : 네트워크 통신, 디코딩 메소드
```
    func searchBlog(query: String) -> Single<Result<DaumKakaoBlog, SearchNetworkError>> {
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 820e80014bffc814b1c6d5e49baa517d", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest) 
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
```
