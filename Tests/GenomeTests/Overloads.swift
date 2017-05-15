//
//  Overloads.swift
//  Genome
//
//  Created by Tim Vermeulen on 14/05/2017.
//
//

func == <T: Equatable> (lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case let (left?, right?):
        return left == right
    case (nil, nil):
        return true
    default:
        return false
    }
}

func == <T: Equatable> (lhs: [[T]], rhs: [[T]]) -> Bool {
    return lhs.count == rhs.count && !zip(lhs, rhs).contains(where: !=)
}

func == <T: Equatable> (lhs: [[T]]?, rhs: [[T]]?) -> Bool {
    switch (lhs, rhs) {
    case let (left?, right?):
        return left == right
    case (nil, nil):
        return true
    default:
        return false
    }
}

func == <K, V: Equatable> (lhs: [K: V]?, rhs: [K: V]?) -> Bool {
    switch (lhs, rhs) {
    case let (left?, right?):
        return left == right
    case (nil, nil):
        return false
    default:
        return true
    }
}
