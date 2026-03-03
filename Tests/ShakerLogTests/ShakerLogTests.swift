import XCTest
@testable import ShakerLog

final class ShakerLogTests: XCTestCase {

    override func setUp() {
        super.setUp()
        ShakerLog.configure(.init(printToConsole: false))
        ShakerLog.clearAll()
    }

    func testConfigureEnablesLogging() {
        XCTAssertTrue(ShakerLog.shared.isEnabled)
    }

    func testLogEntriesAreStored() {
        ShakerLog.debug("debug")
        ShakerLog.info("info")
        ShakerLog.warning("warning")
        ShakerLog.error("error")
        ShakerLog.critical("critical")

        XCTAssertEqual(ShakerLog.allEntries().count, 5)
    }

    func testMinimumLevelFilters() {
        ShakerLog.configure(.init(minimumLevel: .warning, printToConsole: false))
        ShakerLog.debug("filtered")
        ShakerLog.info("filtered")
        ShakerLog.warning("visible")
        ShakerLog.error("visible")

        XCTAssertEqual(ShakerLog.allEntries().count, 2)
    }

    func testClearRemovesEntries() {
        ShakerLog.info("test")
        XCTAssertEqual(ShakerLog.allEntries().count, 1)

        ShakerLog.clearAll()
        XCTAssertTrue(ShakerLog.allEntries().isEmpty)
    }

    func testLogLevelOrdering() {
        XCTAssertTrue(LogLevel.debug < LogLevel.info)
        XCTAssertTrue(LogLevel.info < LogLevel.warning)
        XCTAssertTrue(LogLevel.warning < LogLevel.error)
        XCTAssertTrue(LogLevel.error < LogLevel.critical)
    }

    func testLogEntryContainsCorrectData() {
        ShakerLog.info("hello world")
        let entry = ShakerLog.allEntries().first

        XCTAssertNotNil(entry)
        XCTAssertEqual(entry?.level, .info)
        XCTAssertEqual(entry?.message, "hello world")
    }
}
