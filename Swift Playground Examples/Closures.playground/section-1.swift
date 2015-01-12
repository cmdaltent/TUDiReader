// Playground - noun: a place where people can play

import Cocoa

let array = [1, 5, 2, 100, 30, 45, 28, 78, 76,  10]

sorted(array, { (s1: Int, s2: Int) -> Bool in
    return s1 < s2
})

/*!
    Inferring type from context.
 */
sorted(array, { (s1, s2) -> Bool in
    return s1 < s2
})

/*!
    Inferring type from context.
    Wrote in one line.
 */
sorted(array, { s1, s2 in return s1 < s2 } )

/*!
    Inferring type from context.
    Wrote in one line.
    Implicit return statement, because there is only one expression in the closures body. Single-Expression-Closure.
 */
sorted(array, { s1, s2 in s1 < s2} )

/*!
    Shorthand argument names for inline closures.
    Refer to the values of the closures arguments.
    in-statement can also be omitted, because the closure is completely made of its body.
 */
sorted(array, { $0 < $1} )

/*!
    Operator Functions.
    This works because the type sorted in the closure implements the < operator.
    Swift infers the remaining parts of the body (so that it will behave like the examples above).
 */
sorted(array, <)

/*!
    Trailing Closures.
    Especially useful, when the closure is too long to write it inline.
    Closure must be the last argument of the function, of course.
 */
sorted(array) { $0 < $1 }


//-----------------------
// Implementation Example
//-----------------------


func own_filter<T: SequenceType>(input: T, element: (T.Generator.Element) -> Bool) -> [T.Generator.Element]
{
    var result = Array<T.Generator.Element>()
    for inputElement in input {
        if element(inputElement) {
            result.append(inputElement)
        }
    }
    return result
}

own_filter(array, { (s1) -> Bool in
    return s1 < 50
})

own_filter(array, { $0 < 50 } )