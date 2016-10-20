//
//  URLRequestContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 18/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class URLRequestContext: DataRequestContext<DataResponseContext> {

	open func toURLRequest() -> URLRequest {
		
		return URLRequest(url: URL(string: "")!)
	}
	
	open func escapeUrl(_ url:String) -> String {
		return url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
	}

}
