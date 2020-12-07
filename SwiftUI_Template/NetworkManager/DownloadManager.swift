//
//  DownloadManager.swift
//  SwiftUI_Template
//
//  Created by Vasileios  Gkreen on 07/12/20.
//

import UIKit


class DownloadManager {
	
	static let shared = DownloadManager()
	
	let cache = NSCache<NSString, UIImage>()
	
	private init() {}
	
	func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
		let cacheKey = NSString(string: urlString)
		if let image = cache.object(forKey: cacheKey) {
			completed(image)
			return
		}
		
		guard let url = URL(string: urlString) else {
			completed(nil)
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			guard let self = self,
				  error == nil,
				  let response = response as? HTTPURLResponse, response.statusCode == 200,
				  let data = data,
				  let image = UIImage(data: data) else {
				completed(nil)
				return
			}
			
			self.cache.setObject(image, forKey: cacheKey)
			completed(image)
		}
		task.resume()
	}
}
