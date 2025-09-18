//
//  APiClient.swift
//  SearchApp
//
//  Created by JuYoung choi on 8/20/25.
//  Copyright © 2025 com.portfolio. All rights reserved.
//
import Foundation
import Alamofire
import Core

/// 다양한 데이터 가져오기
public enum APIType: String, Codable {

    case blogSearch  = "/v2/search/blog"
    case imageSearch = "/v2/search/image"
    case videoSearch = "/v2/search/vclip"
    case bookSearch  = "/v3/search/book"


    public var url: String {
        let baseUrl = "https://dapi.kakao.com"

        return baseUrl.appending(self.rawValue)
    }

    public var method: HTTPMethod {

        switch self {
        case .blogSearch, .imageSearch, .videoSearch, .bookSearch:
            return .get
        }
    }

    public var header: HTTPHeaders {

        var header = HTTPHeaders()
        
        header.add(name: "Authorization", value: "KakaoAK \(ConstNo.apiKey)")

        return header
    }
    
}

class SessionInfo {

    static let session: Session = {

        let configuration = URLSessionConfiguration.default

        configuration.timeoutIntervalForRequest  = 10
        configuration.timeoutIntervalForResource = 30

        configuration.httpAdditionalHeaders = ["Accept": "application/json",
                                               "charset": "utf8"]

        return Session(configuration: configuration)
    }()
}

/// HTTP 통신 모듈
public protocol NetworkComm {

    /// 데이터 요청하기
    /// - Parameters:
    ///   - router: 파라매터를 제외한 요청 정보
    ///   - parameters: 전달 파라매터
    /// - Returns: 데이터 리턴
    func request<T: Decodable>(router: APIType,
                               parameters: Parameters?,
                               header: HTTPHeaders?) async throws -> T
}

public extension NetworkComm {

    func request<T: Decodable>(router: APIType,
                               parameters: Parameters?,
                               header: HTTPHeaders? = nil) async throws -> T {

        print("parameters : \(parameters)")

        return try await withCheckedThrowingContinuation({ cont in

            SessionInfo.session.request(
                router.url,
                method: router.method,
                parameters: parameters,
                encoding: router.method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: router.header
            )
            .validate()
            .responseDecodable(of: T.self) { response in

                switch response.result {
                case .success(let data):
                    cont.resume(returning: data)
                case .failure(let error):
                    #if DEBUG
                    print("com error : \(error as NSError)")
                    #endif

                    cont.resume(throwing: error as NSError)
                }
            }
        })
    }
}

