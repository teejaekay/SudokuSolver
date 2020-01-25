//
//  ViewController.swift
//  SudokuSolver
//
//  Created by Taylor Kelly on 12/23/19.
//  Copyright © 2019 Taylor Kelly. All rights reserved.
//

import UIKit

//          TO-DO

// feedback when right answer
// timer?
// solver visual


class ViewController: UIViewController {
    
    var numStrikes = -1
    var touchLocation = CGPoint()
    var boxIsSelected = false
    var cellNumber = -1
    @IBOutlet var fullBoard: UIStackView!
    @IBOutlet var cells: [UILabel]!
    
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var strikes: [UILabel]!
    
    var board = [ [7, 8, 0, 4, 0, 0, 1, 2, 0],
                  [6, 0, 0, 0, 7, 5, 0, 0, 9],
                  [0, 0, 0, 6, 0, 1, 0, 7, 8],
                  [0, 0, 7, 0, 4, 0, 2, 6, 0],
                  [0, 0, 1, 0, 5, 0, 9, 3, 0],
                  [9, 0, 4, 0, 6, 0, 0, 0, 5],
                  [0, 7, 0, 3, 0, 0, 0, 1, 2],
                  [1, 2, 0, 0, 0, 7, 4, 0, 0],
                  [0, 4, 9, 2, 0, 6, 0, 0, 7]]
    
    var testBoard = [ [7, 8, 0, 4, 0, 0, 1, 2, 0],
                      [6, 0, 0, 0, 7, 5, 0, 0, 9],
                      [0, 0, 0, 6, 0, 1, 0, 7, 8],
                      [0, 0, 7, 0, 4, 0, 2, 6, 0],
                      [0, 0, 1, 0, 5, 0, 9, 3, 0],
                      [9, 0, 4, 0, 6, 0, 0, 0, 5],
                      [0, 7, 0, 3, 0, 0, 0, 1, 2],
                      [1, 2, 0, 0, 0, 7, 4, 0, 0],
                      [0, 4, 9, 2, 0, 6, 0, 0, 7]]
    
    
    @IBAction func numberSelect(_ sender: UIButton) {
        
        if (boxIsSelected == true) {
            
            // determines which number was pressed
            let tag = sender.tag
            
            testBoard = board
            
            //checking if value passes row, col, box tests
            if checkValid(cell: cellNumber, value: tag) {
                
                // update testBoard with approved value
                testBoard[getRow(cell: cellNumber)][getCol(cell: cellNumber)] = tag
                
                // determine if a solution is possible with testes value
                if solve() {
                    
                    // update the main board with correct value
                    board[getRow(cell: cellNumber)][getCol(cell: cellNumber)] = tag
                    fillBoard()
                    
                } else {
                    // passes row, col, box test but no possible solution
                    print("impossible solution with that input")
                    strike()
                }
                
            } else {
//NOTE//        // TEST IF NECESSARY
                // value is in a row, col, or box. Reset in test board
                testBoard[getRow(cell: cellNumber)][getCol(cell: cellNumber)] = 0
                strike()
            }
             
            
        
        }
        
        
    }
    
    @IBAction func solveButton(_ sender: Any) {
        
       if solve() {
            board = testBoard
            fillBoard()
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillBoard()
        
    }
    
    func printBoard(boardIn: [[Int]]) {
        
        for i in 0...8 {
            if (i % 3 == 0 && i != 0) {
                print("- - - - - - - - - - - - - ")
            }
            
            for j in 0...8 {
                if (j % 3 == 0 && j != 0) {
                    print(" | ", terminator: "")
                }
                
                if j == 8 {
                    print(boardIn[i][j])
                } else {
                    print(String(boardIn[i][j]) + " ", terminator: "")
                }
            }
        }
    }
    
    func fillBoard() {
        
        var tempNum = 0
        for i in 0..<board.count {
            
            for j in 0..<board[i].count {
                
                if (board[i][j] == 0) {
                    cells[tempNum].text = ""
                } else {
                    cells[tempNum].text = "\(board[i][j])"
                }
                tempNum += 1
            }
            
        }
    }
    
  
    // determines which cell was tapped after board was tapped
    func selectBox(x: CGFloat, y: CGFloat) {
        
        //resets background color when unselected
        if cellNumber >= 0 {
            cells[cellNumber].backgroundColor = .white
        }
        
        let rowInt: Int = Int(y/39)
        let colInt: Int = Int(x/39)
    
        cellNumber = ((rowInt * 9) + colInt)
        
        if (cells[cellNumber].text!.isEmpty) {
            cells[cellNumber].backgroundColor = .systemYellow
            boxIsSelected = true
        }
        
        
    }
    
    func checkValid(cell: Int, value: Int) -> Bool {
        
        let row = getRow(cell: cell)
        let col = getCol(cell: cell)
        //print("row: \(row), col: \(col), value to test: \(value)")
        
        // check row
        for i in 0...8 {
            if (testBoard[row][i] == value && col != i) {
                print("row error")
                return false;
            }
        }
        
        // check column
        for i in 0...8 {
            if (testBoard[i][col] == value && row != i) {
                print("column error")
                return false;
            }
        }
        
        // check box
        let x = row / 3
        let y = col / 3
        let boxNum = "\(x)\(y)"
        
        for i in (x * 3)..<(x * 3 + 3) {
            for j in (y * 3)..<(y * 3 + 3) {
                
                if (boxNum.elementsEqual("00")) {
                    for i in 0...2 {
                        for j in 0...2 {
                            if testBoard[i][j] == value {
                                print("ivalid box")
                                return false
                            }
                        }
                    }
                } else if (boxNum.elementsEqual("\(i)\(j)")) {
                    print("same box")
                    return false
                    
                } else {
                    if (testBoard[i][j] == value) {
                    print("box error")
                    return false
                
                    }
                }
               
            }
        }
        return true
    }
    
    // finds empty cell
    func findEmpty() -> Int {
        
        for i in 0...8 {
            for j in 0...8 {
                if testBoard[i][j] == 0 {
                    return (9 * i) + j
                }
            }
        }
        
        print("no empty cells")
        return 100
    }
    
    func solve() -> Bool {
        
        let empCell = findEmpty()
        let empCellRow = getRow(cell: empCell)
        let empCellCol = getCol(cell: empCell)
        
        if (empCell == 100) {
            print("board was solved")
            return true
        }
        
        for i in 1...9 {
            print("testing value: \(i) in cell \(empCell)")
            if checkValid(cell: empCell, value: i) {
                testBoard[empCellRow][empCellCol] = i
                                
                if solve() {
                    return true
                }
                print("backtracking")
                testBoard[empCellRow][empCellCol] = 0
            }
        }
        
        return false
    }

    
    func getRow(cell: Int) -> Int {
        let row: Int = (cell / 9)
        return row
    }
    
    
    func getCol(cell: Int) -> Int {
        let col: Int = (cell % 9)
        return col
    }
    
    func strike() {
        
        numStrikes += 1
        if numStrikes < 3 {
            strikes[numStrikes].textColor = .systemRed
        }
        
        
        if (numStrikes > 1) {
//NOTE//    // add gameover feedback
            print("gameover")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            touchLocation = touch.location(in: fullBoard)
            
            if fullBoard.bounds.contains(touchLocation) {
                
                //print("you touched the board at: \(touchLocation.self)")
                selectBox(x: touchLocation.x, y: touchLocation.y)
            }
                
        }
    }
    
    

    
}
