//
// APIRequest.swift
// GreyLearn

//  Created by Emmanuel Omokagbo on 5/18/26
//  Copyright © 2026 Emmanuel Omokagbo. All rights reserved.
	
import Foundation

/// Encapsulates everything needed to describe an HTTP request.
struct APIRequest {
    
    let path: String
    let method: Method
    /// Query params for GET, body params for POST/PUT (JSON-encoded).
    let parameters: [String: Any]?
    let headers: [String: String]?

    init(
        path: String,
        method: Method = .get,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}
