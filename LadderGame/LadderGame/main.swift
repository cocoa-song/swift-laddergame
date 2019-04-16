//
//  main.swift
//  LadderGame
//
//  Created by JK on 09/10/2017.
//  Copyright © 2017 Codesquad Inc. All rights reserved.
//

import Foundation

//유저가 입력하는 사람수와 사다리수를 받는 함수
func inputUserPeopleAndLadderCounts()->[Int]{
    print("참여할 사람은 몇 명 인가요?")
    let inputPeopleCount = readLine()!
    let peopleCount = Int(inputPeopleCount)!
    
    print("최대 사다리 높이는 몇 개인가요?")
    let inputLadderCount = readLine()!
    let ladderCount = Int(inputLadderCount)!
    
    let peopleNum = peopleCount
    let ladderNum = ladderCount
    
    return [peopleNum, ladderNum]
}


//랜덤한숫자를 받아서 Bool값으로 저장하는 함수 ->사다리 가로의 값을 저장하는 함수
func hasHorizontalValues(ladderHeightAndWidthNum:[Int])->[[Bool]]{
    let ladderWidth = ladderHeightAndWidthNum[0]
    let ladderHeight = ladderHeightAndWidthNum[1]
    
    var horizontalValues : [[Bool]] = Array(repeating: Array(repeating: true,count: ladderWidth-1 ), count: ladderHeight)
    
    for horizontalValuesIndex in 0 ..< ladderHeight {
        for InIndex in 0 ..< ladderWidth - 1 {
            if arc4random_uniform(2) % 2 == 1 {
                horizontalValues[horizontalValuesIndex][InIndex]=(true)
            }else {
                horizontalValues[horizontalValuesIndex][InIndex]=(false)
            }
        }
    }
    return horizontalValues
}

//가로줄이 중복되지 않도록 걸러주는 코드 추가->함수로 분리함
func checkHorizontalValues(horizontalValues: [[Bool]])->[[Bool]]{
    let ladderWidth = horizontalValues[0].count
    let ladderHeight = horizontalValues.count
    var copyHorizontalValues = horizontalValues
    
    if ladderWidth == 1 {
        return copyHorizontalValues
    }else {
        for horizontalValuesIndex in 0 ..< ladderHeight {
            for InIndex in 1 ..< ladderWidth - 1 {
                if InIndex > 0 {
                    if copyHorizontalValues[horizontalValuesIndex][InIndex-1] == true {
                        copyHorizontalValues[horizontalValuesIndex][InIndex] = false
                    } else {
                        copyHorizontalValues[horizontalValuesIndex][InIndex] = Bool.random()
                    }
                }
            }
        }
    }
    return copyHorizontalValues
}

//이중배열에 들어있는 Bool값을 그림으로 전환하여 저장하는 함수->가로값을 그림으로 전화하여 저장하는 함수
func horizontalValuesChangeHorizontalLadders(changValues: [[Bool]])->[[String]]{
    let ladderWidth = changValues[0].count
    let ladderHeight = changValues.count
    
    
    var horizontalLadders : [[String]] = Array(repeating: Array(repeating: "-", count: ladderWidth), count: ladderHeight)
    
    for horizontalLaddersIndex in 0..<ladderHeight {
        for InIndex in 0..<ladderWidth {
            if changValues[horizontalLaddersIndex][InIndex] == true {
                horizontalLadders[horizontalLaddersIndex][InIndex]=("-")
            } else {
                horizontalLadders[horizontalLaddersIndex][InIndex]=(" ")
            }
        }
    }
    return horizontalLadders
}


//배열에있는 그림으로 사다리1행 만드는 함수
func makeLadderOneLine (lineCount : Int, ladderValues : [[String]]) {
    let ladderWidth = ladderValues[0].count
    
    var verticalLine = "|"
    for oneLineladderCount in 0..<ladderWidth {
        verticalLine = verticalLine + ladderValues[lineCount][oneLineladderCount]
        verticalLine = verticalLine + "|"
    }
    print(verticalLine)
    verticalLine = " "
}


//사다리높이만큼 사다리그림을 1행씩 증가시키는 함수
func increaseByladderLine (ladders: [[String]]) {
    let ladderHeight = ladders.count
    
    for ladderHeightCount in 0..<ladderHeight {
        makeLadderOneLine(lineCount: ladderHeightCount, ladderValues: ladders)
    }
}

//게임 실행하는 함수
func playGame() {
    //inputUserPeopleAndLadderCount()
    let values = hasHorizontalValues(ladderHeightAndWidthNum: inputUserPeopleAndLadderCounts())
    let check = checkHorizontalValues(horizontalValues: values)
    let ladders = horizontalValuesChangeHorizontalLadders(changValues: check)
    increaseByladderLine(ladders: ladders)
}

playGame()
