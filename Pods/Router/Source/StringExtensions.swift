import Foundation

extension String {
    var trimmed: String {
        return self.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
    }
}
