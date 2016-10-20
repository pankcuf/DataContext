//
//  DataRequestContext.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 17/10/16.
//  Copyright © 2016 Vladimir Pirogov. All rights reserved.
//

import Foundation

open class DataRequestContext<ResponseType: DataResponseContext>: NSObject {
	
	var responseType:ResponseType.Type
	
	public init(responseType: ResponseType.Type) {
		
		self.responseType = responseType
	}
}
