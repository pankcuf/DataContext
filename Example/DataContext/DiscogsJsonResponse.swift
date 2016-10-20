//
//  DiscogsJsonResponse.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 19/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import DataContext

class ReleaseVO: NSObject {
	
	var artist:String?
	var id:Int?
	var main_release:Int?
	var resource_url:String?
	var role:String?
	var thumb:String?
	var title:String?
	var type:String?
	var year:Int?
	
	init(dict:NSDictionary) {
		
		super.init()
		
		self.artist = dict["artist"] as? String
		self.id = dict["id"] as? Int
		self.main_release = dict["main_release"] as? Int
		self.resource_url = dict["resource_url"] as? String
		self.role = dict["role"] as? String
		self.thumb = dict["thumb"] as? String
		self.title = dict["title"] as? String
		self.type = dict["type"] as? String
		self.year = dict["year"] as? Int
	}
}

class DiscogsJsonResponse: DataResponseContext {
	
	override func parse() -> Any? {
		
		var parsedReleases:[ReleaseVO] = []
		
		if let root = self.result as? NSDictionary {
			
			if let releases = root["releases"] as? [NSMutableDictionary] {
				
				for release in releases {
					
					parsedReleases.append(ReleaseVO(dict: release))
				}
			}
		}
		
		return parsedReleases
	}

}
