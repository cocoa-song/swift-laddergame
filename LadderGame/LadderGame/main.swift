//
//  main.swift
//  LadderGame
//
//  Created by JK on 09/10/2017.
//  Copyright © 2017 Codesquad Inc. All rights reserved.
//
//  Forked and dev by HW on 09/04/2019
import Foundation


enum ValidRangeCode: Int {
    case validMarginalInputNumber = 2
}

enum ErrorCode: Error {
    case notANumber
    case outOfRangeNumber
    case invalidInput
}

struct ErrorValue {
    static let invalidNumber: Int = -1
    static let invalidInput: String = ""
}
enum LadderCode: String {
    case horizontalLadder = "-"  ///가로 사다리
    case emptyLadder = " "       ///사다리 없음
}


/// 입력값이 숫자인지 체크 - 1)빈문자열이 아니고, 2)정수숫자가 있어야하고, 3)다른 문자열이 없어야 한다
public extension String {
    func isNumber() -> Bool {
        return !self.isEmpty
            && self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
            && self.rangeOfCharacter(from: CharacterSet.letters) == nil
    }
}

func printLadder(ladder2dMap : [[Bool]]) -> Void {
    for (rowItems) in ladder2dMap {
        printEachRowLadder(rowItems)
    }
}

func printEachRowLadder(_ row: [Bool] ) -> Void {
    let eachRow = row.map{ (value) -> String in
        if value {
            return LadderCode.horizontalLadder.rawValue
        }
        return LadderCode.emptyLadder.rawValue
    }
    for (columnItem) in eachRow {
        print("|\(columnItem)", terminator: "")
    }
    print ("|")
}

func initLadder(numberOfPeople: Int, numberOfLadders: Int) -> [[Bool]] {
    let initialLadder = [[Bool]] (repeating: Array(repeating: false, count: numberOfPeople), count: numberOfLadders)
    return initialLadder
}

func binaryRandomGenerate() -> Bool {
    let binaryRange:UInt32 = 2
    return (Int(arc4random_uniform(binaryRange))) == 0 ? false : true
}

func buildLadder(ladder2dMap: [[Bool]]) -> [[Bool]] {
    var resultLadder2dMap = ladder2dMap
    for (rowIndex, rowItems) in ladder2dMap.enumerated() {
        resultLadder2dMap[rowIndex] = buildRandomLadder(rowItems)
        resultLadder2dMap[rowIndex] = eraseHorizonLadderByRule(resultLadder2dMap[rowIndex])
    }
    return resultLadder2dMap
}

func buildRandomLadder(_ ladderRowMap: [Bool]) -> [Bool] {
    return ladderRowMap.enumerated().map{ (index: Int, element: Bool) -> Bool in
        var ret = element
        if (index+1) % 2 == 0 {
            ret =  binaryRandomGenerate() ? true : false
        }
        return ret
    }
}

/// 연속해서 |-|-| 나오지 않도록 적용
func eraseHorizonLadderByRule(_ ladderRowMap: [Bool]) -> [Bool] {
    return ladderRowMap.enumerated().map { (index: Int, element: Bool) -> Bool in
        let leastBoundIndex = 2
        if index >= leastBoundIndex && ladderRowMap[index] == true && ladderRowMap[index-2] == ladderRowMap[index] {
            return false
        }
        return element
    }
}




func inputNumberOfPeople() -> String {
    print("참여할 사람은 몇 명 인가요? (\(ValidRangeCode.validMarginalInputNumber.rawValue)이상의 자연수 입력)")
    return inputString()
}

func inputMaximumHeightOfLadders() -> String  {
    print("최대 사다리 높이는 몇 개인가요? (\(ValidRangeCode.validMarginalInputNumber.rawValue)이상의 자연수 입력)")
    return inputString()
}

func checkValidNumber(_ inputString: String) throws -> Int {
    if !inputString.isNumber(){
        throw ErrorCode.notANumber
    }
    if let integerValue = Int (inputString){
        return integerValue
    }
    throw ErrorCode.notANumber
}

func checkValidRange(_ number: Int) throws -> Int {
    if number < ValidRangeCode.validMarginalInputNumber.rawValue {
        throw ErrorCode.outOfRangeNumber
    }
    return number
}

func checkValidInput() throws -> String{
    guard let input: String = readLine() else{ throw ErrorCode.invalidInput }
    return input
}


func inputString() -> String {
    do{
        let input: String = try checkValidInput()
        return input
    }catch ErrorCode.invalidInput {
        print("입력이 정확하지 않습니다")
    }catch{
        print("unknown error")
    }
    return ErrorValue.invalidInput
}

func convertStringToInteger(_ input: String) -> Int {
    do{
        let people: Int = try checkValidNumber(input)
        return people
    }catch ErrorCode.notANumber{
        print("입력값이 숫자가 아닙니다.")
    }catch{
        print("unknown error")
    }
    return ErrorValue.invalidNumber
}

func checkRange(_ number: Int ) -> Bool {
    do {
        let people: Int = try checkValidRange(number)
        return true
    }catch ErrorCode.outOfRangeNumber{
        print("입력값이 유효한 범위가 아닙니다.")
    }catch{
        print("unknown error")
    }
    return false
}



/// 입력 함수 - 입력단계, 범위 체크
func inputPairNumber() -> (String, String ) {
    let peopleInput: String = inputNumberOfPeople()
    let laddersInput: String = inputMaximumHeightOfLadders()
    return (peopleInput, laddersInput)
}

func startLadderGame() -> Void {
    let (peopleInput, laddersInput) = inputPairNumber()
    
    // check validation
    let numberOfPeople: Int = convertStringToInteger(peopleInput)
    let people: Int = checkRange(numberOfPeople) ? numberOfPeople : ErrorValue.invalidNumber
    
    let numberOfLadders: Int = convertStringToInteger(laddersInput)
    let ladders: Int = checkRange(numberOfLadders) ? numberOfLadders : ErrorValue.invalidNumber

    
    //    let isValid: ErrorCode = checkTotalInputValidity(people, ladders)
    
    //    if isValid == ErrorCode.valid {
    //        let initialLadder: [[Bool]] = initLadder(numberOfPeople: people, numberOfLadders: ladders)
    //        let resultLadder: [[Bool]] = buildLadder(ladder2dMap : initialLadder)
    //        printLadder(ladder2dMap: resultLadder)
    //        return
    //    }
}

startLadderGame()
