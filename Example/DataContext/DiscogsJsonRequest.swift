//
//  DiscogsJsonRequest.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 19/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import DataContext

class DiscogsJsonRequest: URLRequestContext {
	
	var artistID:Int
	
	init(artistID:Int, responseType:DataResponseContext.Type) {
		
		self.artistID = artistID
		
		super.init(responseType: responseType)
	}

	override func toURLRequest() -> URLRequest {
		
		let urlString = self.escapeUrl("https://api.discogs.com/artists/\(self.artistID)/releases")

		return URLRequest(url: URL(string: urlString)!)
	}

}
