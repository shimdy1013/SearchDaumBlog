//
//  DaumKakaoBlog.swift
//  SearchDaumBlog
//
//  Created by 심두용 on 2023/05/25.
//

import Foundation

struct DaumKakaoBlog: Decodable {
    let documents: [DaumKakaoDocument]
}

struct DaumKakaoDocument: Decodable {
    let title: String?
    let name: String?
    let thumbnail: String?
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey {
        case title, thumbnail, datetime
        case name = "blogname"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // 디코더에 저장된 데이터를 주어진 keyedBy 형식으로 반환
        
        self.title = try values.decode(String.self, forKey: .title)
        self.name = try values.decode(String.self, forKey: .name)
        self.thumbnail = try values.decode(String.self, forKey: .thumbnail)
        self.datetime = Date.parse(values, key: .datetime)
    }
}

extension Date {
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
                let date = from(dateString: dateString) else {
            return nil
        }
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return nil
    }
}
