//
//  DiscogsTableViewCell.swift
//  DataContext
//
//  Created by Vladimir Pirogov on 20/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import DataContext

class DiscogsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	override func contextDidChange() {
		
		if let dctx = self.context as? DiscogsCellContext {
			
			//self.imageView?.image
			self.textLabel?.text = dctx.releaseVO.artist! + " – " + dctx.releaseVO.title!
		}
	}
	
	
}
