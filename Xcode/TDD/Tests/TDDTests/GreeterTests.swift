import XCTest

@testable import TDD

final class GreeterWithoutNameTests: XCTestCase {

    private var sut: Greeter!

    override func setUp() {
        super.setUp()
        sut = Greeter(name: "")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_greet_with1159am_shouldSayGoodMorning() throws {
        guard let time = date(hour: 11, minute: 59) else {
            XCTFail("Could not create a valid date")
            return
        }

        let result = sut.greet(time: time)

        XCTAssertEqual(result, "Good morning.")
    }

    func test_greet_with1200pm_shouldSayGoodAfternoon() {
        guard let time = date(hour: 12, minute: 00) else {
            XCTFail("Could not create a valid date")
            return
        }

        let result = sut.greet(time: time)

        XCTAssertEqual(result, "Good afternoon.")
    }
}
