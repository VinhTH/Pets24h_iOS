//
//  UIControl+Pets24h.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/21/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

fileprivate final class ClosureSleeve {
    let closure: () -> Void
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    @objc func invoke() {
        self.closure()
    }
}

extension UIControl {
    func addAction(for controlEvent: UIControl.Event, _ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(sleeve.invoke), for: controlEvent)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, .OBJC_ASSOCIATION_RETAIN)
    }
}
