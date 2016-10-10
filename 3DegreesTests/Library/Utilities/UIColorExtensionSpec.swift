//
//  UIColorExtensionTests.swift
//  3Degrees
//
//  Created by Gigster Developer on 4/26/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import UIKit
import Nimble
import Quick

@testable import _Degrees

class UIColorExtensionSpec : QuickSpec {
    override func spec() {
        describe("init method with Ints for rgb and alpha is 1 by default") {
            let test: UIColor = UIColor(r: 0, g: 0, b: 0)
            
            it("should preserve color components") {
                let expected = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                let unexpected = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                
                expect(test).to(equal(expected))
                expect(test).notTo(equal(unexpected))
            }
        }
        
        describe("init with Ints for rgb and 'alpha: CGFLoat'") {
            let test = UIColor(r: 0, g: 0, b: 0, a: 0)
        
            it("should preserve color components") {
                let expected = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                let unexpected = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                
                expect(test).to(equal(expected))
                expect(test).notTo(equal(unexpected))
            }
        }
    }
}