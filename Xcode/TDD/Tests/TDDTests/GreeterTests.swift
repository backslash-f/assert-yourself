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
        let result = sut.greet(time: date(hour: 11, minute: 59))
        XCTAssertEqual(result, "Good morning.")
    }

    func test_greet_with5am_shouldSayGoodMorning() throws {
        let result = sut.greet(time: date(hour: 5, minute: 00))
        XCTAssertEqual(result, "Good morning.")
    }

    func test_greet_with8am_shouldSayGoodMorning() throws {
        let result = sut.greet(time: date(hour: 8, minute: 00))
        XCTAssertEqual(result, "Good morning.")
    }

    func test_greet_with1200pm_shouldSayGoodAfternoon() {
        let result = sut.greet(time: date(hour: 12, minute: 00))
        XCTAssertEqual(result, "Good afternoon.")
    }

    func test_greet_with459pm_shouldSayGoodAfternoon() {
        let result = sut.greet(time: date(hour: 16, minute: 59))
        XCTAssertEqual(result, "Good afternoon.")
    }

    func test_greet_with2pm_shouldSayGoodAfternoon() {
        let result = sut.greet(time: date(hour: 14, minute: 00))
        XCTAssertEqual(result, "Good afternoon.")
    }
    
    func test_greet_with5pm_shouldSayGoodEvening() {
        let result = sut.greet(time: date(hour: 17, minute: 00))
        XCTAssertEqual(result, "Good evening.")
    }

    func test_greet_with1159pm_shouldSayGoodEvening() {
        let result = sut.greet(time: date(hour: 23, minute: 59))
        XCTAssertEqual(result, "Good evening.")
    }

    func test_greet_with8pm_shouldSayGoodEvening() {
        let result = sut.greet(time: date(hour: 20, minute: 00))
        XCTAssertEqual(result, "Good evening.")
    }

    func test_greet_with0am_shouldSayGoodEvening() {
        let result = sut.greet(time: date(hour: 0, minute: 00))
        XCTAssertEqual(result, "Good evening.")
    }

    func test_greet_with459am_shouldSayGoodEvening() {
        let result = sut.greet(time: date(hour: 4, minute: 59))
        XCTAssertEqual(result, "Good evening.")
    }

    func test_greet_with2am_shouldSayGoodEvening() {
        let result = sut.greet(time: date(hour: 2, minute: 00))
        XCTAssertEqual(result, "Good evening.")
    }
}
