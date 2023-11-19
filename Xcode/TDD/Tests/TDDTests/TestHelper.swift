import Foundation
import XCTest

func date(hour: Int, minute: Int) -> Date {
    guard let date = DateComponents(
        calendar: Calendar.current,
        hour: hour,
        minute: minute
    ).date else {
        XCTFail("Could not create a valid date")
        return Date()
    }
    return date
}
