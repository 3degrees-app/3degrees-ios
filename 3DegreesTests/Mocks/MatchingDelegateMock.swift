//
//  MatchingDelegateMock.swift
//  3Degrees
//
//  Created by Gigster Developer on 7/17/16.
//  Copyright © 2016 Gigster. All rights reserved.
//

import Foundation

@testable import _Degrees

class MatchingDelegateMock: PersonForMatchingSelected {
    var single: UserInfo? = nil
    var matchmaker: UserInfo? = nil

    func selectSingleForMatching(single: UserInfo) {
        self.single = single
    }

    func selectMatchmakerForMatching(matchmaker: UserInfo) {
        self.matchmaker = matchmaker
    }
}