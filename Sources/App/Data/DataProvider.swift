//
//  DataProvider.swift
//  App
//
//  Created by Denis Zubkov on 09/08/2019.
//

import Foundation
import Routing
import Vapor

class DataProvider: NSObject {
    
    var dataCache = NSCache<NSString, NSData>()
    var globalSettings = GlobalSettings()
    
    lazy var conn: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    func getUrlComponents(server: ODataServer, query: ODataQuery, format: QueryResultFormat) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = server.scheme
        urlComponents.host = server.host
        if let port = server.port {
            urlComponents.port = port
        }
        urlComponents.path = server.server + server.oData + query.table
        var queryItems: [URLQueryItem] = []
        
        
        if let select = query.select {
            let selectItem = URLQueryItem(name: "$select", value: select)
            queryItems.append(selectItem)
        }
        
        if let orderBy = query.orderBy {
            let orderItem = URLQueryItem(name: "$orderby", value: orderBy)
            queryItems.append(orderItem)
        }
        
        switch format {
        case .json:
            if let filter = query.filter {
                let filterItem = URLQueryItem(name: "$filter", value: filter)
                queryItems.append(filterItem)
            }
            let formatItem = URLQueryItem(name: "$format", value: format.rawValue)
            queryItems.append(formatItem)
        case .tfs:
            if let filter = query.filter {
                let filterItem = URLQueryItem(name: "ids", value: filter)
                queryItems.append(filterItem)
            }
            let expandItem = URLQueryItem(name: "$expand", value: "relations")
            queryItems.append(expandItem)
            let formatItem = URLQueryItem(name: "api-version", value: format.rawValue)
            queryItems.append(formatItem)
        default:
            break
        }
        urlComponents.queryItems = queryItems
        //        urlComponents.user = globalSettings.login
        //        urlComponents.password = globalSettings.password
        return urlComponents
    }
    
    func downloadData(url: URL, completion: @escaping (Data?) -> Void) {
        let request = getRequest(url: url, login: globalSettings.login, password: globalSettings.password)
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(error?.localizedDescription.data(using: .utf8))
                }
            }
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode != 200 {
                let statusCodeString = String(response.statusCode)
                completion(statusCodeString.data(using: .utf8))
                return
            }
            guard let _ = self else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }
        
        dataTask.resume()
    }
    
    func downloadDataNTLM(url: URL, completion: @escaping (Data?) -> Void) {
        let request = NSMutableURLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60000)
        request.httpMethod = "GET"
        let task = conn.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                completion(error?.localizedDescription.data(using: .utf8))
            }
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode != 200 {
                let statusCodeString = String(response.statusCode)
                completion(statusCodeString.data(using: .utf8))
                return
            }
            //guard let `self` = self else { return }
            self.dataCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
            completion(data)
        }
        task.resume()
        
    }
    
    func downloadDataFromTFS(url: URL, completion: @escaping (Data?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url)  { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(error?.localizedDescription.data(using: .utf8))
                }
            }
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode != 200 {
                let statusCodeString = String(response.statusCode)
                completion(statusCodeString.data(using: .utf8))
                return
            }
            //guard let `self` = self else { return }
            self.dataCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
    
    
    
    
    func getRequest(url: URL, login: String, password: String) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 100)
        let loginString = NSString(format: "%@:%@", login as! CVarArg, password as! CVarArg)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: NSData.Base64EncodingOptions())
        let parameters = ["Authorization": "Basic \(base64LoginString)",
            "Accept-Encoding": "gzip, deflate", "Accept": "*/*", "Accept-Language": "ru"]
        request.httpMethod = "GET"
        request.timeoutInterval = 100
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        for parameter in parameters {
            request.addValue(parameter.value, forHTTPHeaderField: parameter.key)
        }
        return request
    }
    
    func getPatchUrlComponents(server: ODataServer, workItem: Int) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = server.scheme
        urlComponents.host = server.host
        if let port = server.port {
            urlComponents.port = port
        }
        urlComponents.path = server.server + server.oData + "workitems/\(workItem)"
        var queryItems: [URLQueryItem] = []
        let formatItem = URLQueryItem(name: "api-version", value: "3.2")
        queryItems.append(formatItem)
        urlComponents.queryItems = queryItems
        urlComponents.user = globalSettings.login
        urlComponents.password = globalSettings.password
        return urlComponents
    }
    
    func getPatchPriorityRequest(url: URL, priority: Int, rev: Int) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 100)
        let loginString = NSString(format: "%@:%@", globalSettings.login as! CVarArg, globalSettings.password as! CVarArg)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: NSData.Base64EncodingOptions())
        let parameters = ["Authorization": "Basic \(base64LoginString)",
            "Accept-Encoding": "gzip, deflate", "Accept": "*/*", "Accept-Language": "ru"]
        request.httpMethod = "PATCH"
        request.timeoutInterval = 100
        request.addValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        for parameter in parameters {
            request.addValue(parameter.value, forHTTPHeaderField: parameter.key)
        }
        let json: [[String: Any]] = [
            [
                "op": "test",
                "path": "/rev",
                "value": rev
            ],
            [
                "op": "add",
                "path": "/fields/Microsoft.VSTS.Common.Priority",
                "value": priority
            ],
            [
                "op": "add",
                "path": "/fields/System.History",
                "value": "Изменение приоритета из мобильного приложения"
            ]
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return request
        }
        request.httpBody = httpBody
        return request
    }
    
    func patchPriority(server: ODataServer, rev: Int, workItem: Int, priority: Int, completion: @escaping (Data?) -> Void) {
        let urlComponents = getPatchUrlComponents(server: server, workItem: workItem)
        guard let url = urlComponents.url else { return }
        
        let request = getPatchPriorityRequest(url: url, priority: priority, rev: rev)
        let config = URLSessionConfiguration.default
        if workItem == 4019 {
            print("sss")
        }
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request)  { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(error?.localizedDescription.data(using: .utf8))
                }
            }
            //guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            //if response.statusCode != 200 {
            let statusCodeString = String(response.statusCode)
            completion(statusCodeString.data(using: .utf8))
            return
            //}
            //            DispatchQueue.main.async {
            //                completion(data)
            //            }
        }
        task.resume()
    }
    
}


extension DataProvider: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("got challenge")
        
        guard challenge.previousFailureCount == 0 else {
            print("too many failures")
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM else {
            print("unknown authentication method \(challenge.protectionSpace.authenticationMethod)")
            challenge.sender?.cancel(challenge)
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        
        let credentials = URLCredential(user: globalSettings.login, password: globalSettings.password, persistence: .forSession)
        challenge.sender?.use(credentials, for: challenge)
        completionHandler(.useCredential, credentials)
    }
    
    
}

