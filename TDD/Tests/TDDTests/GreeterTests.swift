import XCTest

@testable import TDD

final class GreeterTests: XCTestCase {

    func test_greet_with1159am_shouldSayGoodMorning() throws {
        let sut = Greeter(name: "")
        let components = DateComponents(calendar: Calendar.current,
                                        hour: 11, minute: 59)
        guard let time = components.date else {
            XCTFail("Could not create date from components: \(components)")
            return
        }
    }
}
