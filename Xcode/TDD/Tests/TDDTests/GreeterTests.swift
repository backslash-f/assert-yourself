import XCTest

@testable import TDD

final class GreeterTests: XCTestCase {

    func test_greet_with1159am_shouldSayGoodMorning() throws {
        guard let time = date(hour: 11, minute: 59) else {
            XCTFail("Could not create a valid date")
            return
        }

        let sut = Greeter(name: "")
        let result = sut.greet(time: time)

        XCTAssertEqual(result, "Good morning.")
    }
}
