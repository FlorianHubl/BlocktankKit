import Foundation

@available(iOS 13, macOS 12, *)
public struct Blocktank {
    
    enum Request: String {
        case info = "api/v1/node/info"
        case buyChannel = "api/v1/channel/buy"
        case finaliseChannel = "api/v1/channel/manual_finalise"
        case getOrder = "api/v1/channel/order"
        case lnurl = "api/v1/lnurl/channel"
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    let debugMode: Bool
    
    let url: String
    
    public init(url: String = "https://blocktank.synonym.to", debugMode: Bool = false) {
        self.url = url
        self.debugMode = debugMode
    }
    
    private func addPayload(payload: String, _ urlr: URLRequest) -> URLRequest {
        var url = urlr
        url.httpBody = payload.data(using: .utf8)
        return url
    }
    
    private func getRequest(for i: Request, method: HTTPMethod, urlExtention: String? = nil, payLoad: String? = nil, extWithSlash: Bool = false) -> URLRequest {
        var rqUrl = "\(url)/\(i.rawValue)"
        if let ext = urlExtention {
            if extWithSlash {
                rqUrl += "/"
            }
            rqUrl += ext.removingWhitespaces().withoutEmoji()
        }
        if debugMode {
            print("Dezzy Requesting: \(rqUrl)")
        }
        var request = URLRequest(url: URL(string: rqUrl)!)
        request.httpMethod = method.rawValue
        if let payLoad = payLoad {
            request = addPayload(payload: payLoad, request)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue(apiKey, forHTTPHeaderField: "x-api-token")
        return request
    }
    
    enum BlocktankError: Error {
        case error(String)
    }
    
    func request(for req: Request, method: HTTPMethod, payload: String? = nil) async throws {
        let result = try await URLSession.shared.data(for: getRequest(for: req, method: method, payLoad: payload)).0
        if debugMode {
            print(String(data: result, encoding: .utf8)!)
        }
        do {
            let a = try JSONDecoder().decode(BTError.self, from: result)
            throw BlocktankError.error(a.error)
        }catch {
            return
        }
    }
    
    func request<T: Codable>(for req: Request, method: HTTPMethod, type: T.Type, payload: String? = nil, urlExtention: String? = nil) async throws -> T {
        let result = try await URLSession.shared.data(for: getRequest(for: req, method: method, urlExtention: urlExtention, payLoad: payload)).0
        do {
            if debugMode {
                print(String(data: result, encoding: .utf8)!)
            }
            let a = try JSONDecoder().decode(type.self, from: result)
            return a
        }catch {
            do {
                let a = try JSONDecoder().decode(BTError.self, from: result)
                throw BlocktankError.error(a.error)
            }catch {
                guard let a = String(data: result, encoding: .utf8) else {throw BlocktankError.error("BoltzKit Unknown Error")}
                throw BlocktankError.error(a)
            }
        }
    }
}

extension String {
    func withoutEmoji() -> String {
        filter { $0.isASCII }
    }
    func removingWhitespaces() -> String {
        components(separatedBy: .whitespaces).joined()
    }
}

public struct BTError: Codable {
    public let error: String
}

