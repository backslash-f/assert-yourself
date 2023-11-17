//
//  MockPasswordChanger.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 14.11.23.
//

import Foundation
import XCTest

@testable import AssertYourself

final class MockPasswordChanger: PasswordChanging {
    private var changeCallCount = 0
    private var changeArgsSecurityToken: [String] = []
    private var changeArgsOldPassword: [String] = []
    private var changeArgsNewPassword: [String] = []
    private var changeArgsOnSuccess: [() -> Void] = []
    private var changeArgsOnFailure: [(String) -> Void] = []

    func change(securityToken: String,
                oldPassword: String,
                newPassword: String,
                onSuccess: @escaping () -> Void,
                onFailure: @escaping (String) -> Void) {
        changeCallCount += 1
        changeArgsSecurityToken.append(securityToken)
        changeArgsOldPassword.append(oldPassword)
        changeArgsNewPassword.append(newPassword)
        changeArgsOnSuccess.append(onSuccess)
        changeArgsOnFailure.append(onFailure)
    }

    func verifyChange(securityToken: String,
                      oldPassword: String,
                      newPassword: String,
                      file: StaticString = #file,
                      line: UInt = #line) {
        if changeWasCalledOnce(file: file, line: line) {
            XCTAssertEqual(
                changeArgsSecurityToken.last,
                securityToken,
                "security token",
                file: file,
                line: line
            )
            XCTAssertEqual(
                changeArgsOldPassword.last,
                oldPassword,
                "old password",
                file: file,
                line: line
            )
            XCTAssertEqual(
                changeArgsNewPassword.last,
                newPassword, "new password",
                file: file,
                line: line
            )
        }
    }

    func verifyChangeNeverCalled(file: StaticString = #file, line: UInt = #line) {
        changeWasNeverCalled(file: file, line: line)
    }

    func changeCallSuccess(file: StaticString = #file,
                           line: UInt = #line) {
        guard changeWasCalledOnce(file: file, line: line) else { return }
        changeArgsOnSuccess.last!()
    }

    func changeCallFailure(message: String,
                           file: StaticString = #file,
                           line: UInt = #line) {
        guard changeWasCalledOnce(file: file, line: line) else { return }
        changeArgsOnFailure.last!(message)
    }
}

private extension MockPasswordChanger {
    func changeWasCalledOnce(file: StaticString = #file, line: UInt = #line) -> Bool {
        verifyMethodCalledOnce(
            methodName: changeMethodName,
            callCount: changeCallCount,
            describeArguments: changeMethodArguments,
            file: file,
            line: line
        )
    }

    func changeWasNeverCalled(file: StaticString = #file, line: UInt = #line) {
        verifyMethodNeverCalled(
            methodName: changeMethodName,
            callCount: changeCallCount,
            describeArguments: changeMethodArguments,
            file: file,
            line: line
        )
    }

    var changeMethodName: String {
        "change(securityToken:oldPassword:newPassword:onSuccess:onFailure:)"
    }

    var changeMethodArguments: String {
        "oldPasswords: \(changeArgsOldPassword), " +
        "newPasswords: \(changeArgsNewPassword)"
    }
}
