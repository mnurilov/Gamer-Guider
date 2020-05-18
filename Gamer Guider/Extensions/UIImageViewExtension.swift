//
//  UIImageViewExtension.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/16/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import Foundation
import UIKit

// I have gotten this code off stack overflow, It was the only piece of code I had used without modifying.
// Downloading images asynchronously was one of the hardest parts of this project
// https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
