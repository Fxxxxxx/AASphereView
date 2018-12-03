//
//  MatrixSubscripting.swift
//  SwiftNum
//
//  Created by Donald Pinckney on 1/1/17.
//
//

public extension Matrix {
    public subscript(row: Int, column: Int) -> Double {
        get {
            return data[width*row + column]
        }
        set(val) {
            data[width*row + column] = val
        }
    }
    
    public subscript(rows: Range<Int>, columns: Range<Int>) -> Matrix {
        get {
            let width = columns.count
            let height = rows.count
            var values: [Double] = [Double](repeating: 0, count: width * height)
            
            for r in rows.lowerBound..<rows.upperBound {
                let base = (r - rows.lowerBound) * width
                let selfBase = r * self.width + columns.lowerBound
                let selfEnd = r * self.width + columns.upperBound
                //                values[base..<(base + width)] = data[selfBase..<selfEnd]
                values.replaceSubrange(base..<(base+width), with: data[selfBase..<selfEnd])
            }
            return Matrix(rowMajorData: values, width: width)
        }
        set(subMatrix) {
            precondition(rows.count == subMatrix.height)
            precondition(columns.count == subMatrix.width)
            
            let width = columns.count
            
            for r in rows.lowerBound..<rows.upperBound {
                let base = (r - rows.lowerBound) * width
                let selfBase = r * self.width + columns.lowerBound
                let selfEnd = r * self.width + columns.upperBound
                //                data[selfBase..<selfEnd] = subMatrix.data[base..<(base + width)]
                data.replaceSubrange(selfBase..<selfEnd, with: subMatrix.data[base..<(base + width)])
            }
        }
    }
    public subscript(rows: ClosedRange<Int>, columns: Range<Int>) -> Matrix {
        get {
            return self[Range(rows), columns]
        }
        set(m) {
            self[Range(rows), columns] = m
        }
    }
    public subscript(rows: Range<Int>, columns: ClosedRange<Int>) -> Matrix {
        get {
            return self[rows, Range(columns)]
        }
        set(m) {
            self[rows, Range(columns)] = m
        }
    }
    public subscript(rows: ClosedRange<Int>, columns: ClosedRange<Int>) -> Matrix {
        get {
            return self[Range(rows), Range(columns)]
        }
        set(m) {
            self[Range(rows), Range(columns)] = m
        }
    }
    
    
    
    public subscript(row: Int, columns: ClosedRange<Int>) -> Matrix {
        get {
            return self[row..<(row + 1), Range(columns)]
        }
        set(m) {
            self[row..<(row + 1), Range(columns)] = m
        }
    }
    public subscript(row: Int, columns: Range<Int>) -> Matrix {
        get {
            return self[row..<(row + 1), columns]
        }
        set(m) {
            self[row..<(row + 1), columns] = m
        }
    }
    
    public subscript(rows: Range<Int>, column: Int) -> Matrix {
        get {
            return self[rows, column..<(column + 1)]
        }
        set(m) {
            self[rows, column..<(column + 1)] = m
        }
    }
    
    
    public subscript(rows: ClosedRange<Int>, column: Int) -> Matrix {
        get {
            return self[Range(rows), column]
        }
        set(m) {
            self[Range(rows), column] = m
        }
    }
    
    public subscript(rows: Range<Int>, columns: [Int]) -> Matrix {
        get {
            var cols: [Matrix] = []
            for c in columns {
                cols.append(self[rows, c])
            }
            return Matrix.horizontalConcatenate(cols)
        }    }
    
    public subscript(rows: ClosedRange<Int>, columns: [Int]) -> Matrix {
        get {
            return self[Range(rows), columns]
        }
    }
    
    public subscript(row: Int, columns: [Int]) -> Matrix {
        get {
            return self[row..<(row + 1), columns]
        }
    }
    
    
    public subscript(rows: [Int], columns: Range<Int>) -> Matrix {
        get {
            var rs: [Matrix] = []
            for r in rows {
                rs.append(self[r, columns])
            }
            return Matrix.verticalConcatenate(rs)
        }
    }
    
    public subscript(rows: [Int], columns: ClosedRange<Int>) -> Matrix {
        get {
            return self[rows, Range(columns)]
        }
    }
    
    public subscript(rows: [Int], column: Int) -> Matrix {
        get {
            return self[rows, column..<(column+1)]
        }
    }
    
    public subscript(rows: [Int], columns: [Int]) -> Matrix {
        get {
            var data: [Double] = []
            for r in rows {
                for c in columns {
                    data.append(self[r, c])
                }
            }
            return Matrix(rowMajorData: data, width: columns.count)
        }
    }
    
    // Only valid for row or column matrices
    public subscript(i: Int) -> Double {
        get {
            precondition(width == 1 || height == 1)
            return self.data[i]
        }
        set(m) {
            precondition(width == 1 || height == 1)
            self.data[i] = m
        }
    }
    public subscript(i: Range<Int>) -> Matrix {
        get {
            precondition(width == 1 || height == 1)
            if width == 1 {
                return Matrix(rowMajorData: Array(data[i]), width: 1)
            } else {
                return Matrix(rowMajorData: Array(data[i]), width: i.count)
            }
        }
        set(m) {
            precondition((width == 1 && m.width == 1) || (height == 1 && m.height == 1))
            data.replaceSubrange(i, with: m.data)
        }
    }
    
    
    
    
}
