//
//  CallHistoryCallEventTargetTests.swift
//  Telephone
//
//  Copyright (c) 2008-2016 Alexey Kuznetsov
//  Copyright (c) 2016-2017 64 Characters
//
//  Telephone is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Telephone is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//

import UseCases
import UseCasesTestDoubles
import XCTest

final class CallHistoryCallEventTargetTests: XCTestCase {
    func testCreatesUseCaseWithExpectedArgumentsOnDidDisconnect() {
        let account = SimpleAccount(uuid: "any-id", domain: "any-domain")
        let history: CallHistory = TruncatingCallHistory()
        let histories = DefaultCallHistories(factory: CallHistoryFactorySpy(history: history))
        let factory = CallHistoryRecordAddUseCaseFactoryStub(add: UseCaseSpy())
        let sut = CallHistoryCallEventTarget(histories: histories, factory: factory)
        let call = makeCall(account: account)

        sut.didDisconnect(call)

        XCTAssertTrue(factory.invokedHistory === history)
        XCTAssertEqual(factory.invokedRecord, CallHistoryRecord(call: call))
        XCTAssertEqual(factory.invokedDomain, account.domain)
    }

    func testExecutesUseCaseOnDidDisconnect() {
        let histories = DefaultCallHistories(factory: CallHistoryFactorySpy(history: TruncatingCallHistory()))
        let add = UseCaseSpy()
        let sut = CallHistoryCallEventTarget(histories: histories, factory: CallHistoryRecordAddUseCaseFactoryStub(add: add))
        let call = makeCall(account: SimpleAccount(uuid: "any-id", domain: "any-domain"))

        sut.didDisconnect(call)

        XCTAssertTrue(add.didCallExecute)
    }
}

private func makeCall(account: Account) -> Call {
    return SimpleCall(
        account: account,
        remote: URI(user: "any-user", host: "any-host"),
        date: Date(),
        duration: 60,
        isIncoming: false,
        isMissed: false
    )
}
