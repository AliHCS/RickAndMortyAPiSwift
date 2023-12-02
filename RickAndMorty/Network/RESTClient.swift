//
//  RESTClient.swift
//  RickAndMorty
//
//  Created by Gustavo Ali Gómez Trejo on 02/12/23.
//

import Foundation

struct RESTClient<T: Codable> {
    let client: Client
    let decoder: JSONDecoder = {
            var dec = JSONDecoder()
            dec.keyDecodingStrategy = .convertFromSnakeCase
            return dec
    }()
    
    init(client: Client) {
        self.client = client
    }
    
    typealias successHandler = ((T) -> Void)
    
    func show(_ path: String, queryParams: [String:String] = ["page":"1"], success: @escaping successHandler ){
        client.get(path,queryParams: queryParams ) { data in
            guard let data = data else { return }
            
            do {
                let json = try self.decoder.decode(T.self, from: data)
                DispatchQueue.main.async { success(json) }
            } catch let err {
                #if DEBUG
                debugPrint(err)
                #endif
            }
        }
    }
}

