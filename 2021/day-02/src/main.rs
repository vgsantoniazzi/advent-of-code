use std::fs;

fn main() {
    let filecontent =
        fs::read_to_string("input.txt").expect("Something went wrong reading the file");
    let movements: Vec<String> = filecontent.split("\n").map(|s| s.to_string()).collect();

    println!("Part 1: {}", part_one(movements.clone()));
    println!("Part 2: {}", part_two(movements.clone()));
}

fn part_one(movements: Vec<String>) -> i32 {
    let mut horizontal = 0;
    let mut depth = 0;
    for movement in movements {
        if movement.is_empty() {
            continue;
        }

        let action: Vec<&str> = movement.split_whitespace().collect();
        let value: i32 = action[1].parse().unwrap();

        match action[0] {
            "forward" => horizontal += value,
            "down" => depth += value,
            "up" => depth -= value,
            _ => panic!("Invalid action: {}", action[0]),
        }
    }
    return horizontal * depth;
}

fn part_two(movements: Vec<String>) -> i32 {
    let mut horizontal = 0;
    let mut depth = 0;
    let mut aim = 0;

    for movement in movements {
        if movement.is_empty() {
            continue;
        }

        let action: Vec<&str> = movement.split_whitespace().collect();
        let value: i32 = action[1].parse().unwrap();

        match action[0] {
            "forward" => {
                horizontal += value;
                depth += value * aim
            }
            "down" => aim += value,
            "up" => aim -= value,
            _ => panic!("Invalid action: {}", action[0]),
        }
    }
    return horizontal * depth;
}
