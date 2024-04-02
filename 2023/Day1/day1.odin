package day1

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:unicode"

calibration_value_p1 :: proc(line: string) -> int {
    first, _ := extract_digits_from_number(line)
    last, _ := extract_digits_from_number(strings.reverse(line))
    return first * 10 + last
}

calibration_value_p2 ::proc(line: string) -> int {
    first_digit, first_position := extract_digits_from_number(line)

    last_digit, last_position := extract_digits_from_number(strings.reverse(line))

    if last_position != -1 {
        last_position = len(line) - last_position
    }

    first_spelled, first_spelled_position, last_spelled, last_spelled_position := extract_digits_from_string(line)
    
    first, last: int

    if first_position != -1 && first_position < first_spelled_position {
        first = first_digit
    } else {
        first = first_spelled
    }

    if last_position != -1 && last_position > last_spelled_position {
        last = last_digit
    } else {
        last = last_spelled
    }
    return first * 10 + last
}

extract_digits_from_number :: proc(line: string) -> (int, int) {
    for c, i in line {
        if unicode.is_digit(c) {
            first_num := int(c - '0')
            return first_num, i
        }
    }
    return 0, -1
}

extract_digits_from_string :: proc(line: string) -> (int, int, int, int) {
    spelled_digits := map[string]int{
        "one" = 1,
        "two" = 2,
        "three" = 3,
        "four" = 4,
        "five" = 5,
        "six" = 6,
        "seven" = 7,
        "eight" = 8,
        "nine" = 9
    }
    first_spelled: int
    last_spelled: int
    first_spelled_position: int = 100000
    last_spelled_position: int = -100000
    for key, value in spelled_digits {
        first_position := strings.index(line, key)
        last_position := strings.last_index(line, key)

        if first_position != -1 && first_position < first_spelled_position {
            first_spelled = spelled_digits[key]
            first_spelled_position = first_position
        }
        if last_position != -1 && last_position > last_spelled_position {
            last_spelled = spelled_digits[key]
            last_spelled_position = last_position
        }
    }
    return first_spelled, first_spelled_position, last_spelled, last_spelled_position
}

main :: proc() {
    data := os.read_entire_file("input") or_else os.exit(1)
    defer delete(data)
    lines := string(data)
    sum1 := 0
    sum2 := 0

    for line in strings.split_iterator(&lines, "\n") {
        // sum1+= calibration_value_p1(line)
        sum2+= calibration_value_p2(line)
    }
    // number := calibration_value_p2("7pqrstsixteen")
    fmt.println("sum2 = ", sum2)
}