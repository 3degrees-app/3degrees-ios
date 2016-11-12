//
//  Loggable.swift
//  3Degrees
//
//  Created by Ryan Martin on 11/12/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

protocol Loggable {
    func debug(message: String)
    func error(message: String)
    func info(message: String)
    func warn(message: String)
}

extension Loggable {
    func debug(message: String) {
        print("[\(timeStamp())] DEBUG: \(message)")
    }

    func error(message: String) {
        print("[\(timeStamp())] ERROR: \(message)")
    }

    func info(message: String) {
        print("[\(timeStamp())] INFO: \(message)")
    }

    func warn(message: String) {
        print("[\(timeStamp())] WARN: \(message)")
    }
    
    private func timeStamp() -> String {
        return "\(NSDate())";
    }
}