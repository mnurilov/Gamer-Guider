//
//  UIButtonExtension.swift
//  Gamer Guider
//
//  Created by Michael Nurilov on 5/16/20.
//  Copyright © 2020 Michael Nurilov. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func shake() {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut,
            animations: {
                self.transform = .init(scaleX: 1.5, y: 1.5)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    self.transform = .init(scaleX: 1.0, y: 1.0)
                }
            }
        )

    }
}
