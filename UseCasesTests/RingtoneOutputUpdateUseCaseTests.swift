//
//  RingtoneOutputUpdateUseCaseTests.swift
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

final class RingtoneOutputUpdateUseCaseTests: XCTestCase {
    private var playback: RingtonePlaybackUseCaseSpy!
    private var sut: ThrowingUseCase!

    override func setUp() {
        super.setUp()
        playback = RingtonePlaybackUseCaseSpy()
        sut = RingtoneOutputUpdateUseCase(playback: playback)
    }

    func testRestartsPlaybackWhenPlaying() {
        try! playback.start()

        try! sut.execute()

        XCTAssertTrue(playback.didCallStop)
        XCTAssertTrue(playback.didCallStart)
    }

    func testDoesNotRestartPlaybackWhenNotPlaying() {
        try! sut.execute()

        XCTAssertFalse(playback.didCallStop)
        XCTAssertFalse(playback.didCallStart)
    }
}
