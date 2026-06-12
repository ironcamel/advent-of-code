use std::fs;

fn main() {
    let input = fs::read_to_string("input-large.txt").expect("Failed to read input-large.txt");
    let mut cur: i64 = 50;
    let mut cnt = 0;

    for line in input.lines() {
        let line = line.trim();
        if line.is_empty() { continue; }
        let dir = &line[..1];
        let val: i64 = line[1..].parse().expect("Invalid number");
        cur = if dir == "L" {
            (cur - val).rem_euclid(100)
        } else {
            (cur + val).rem_euclid(100)
        };
        if cur == 0 {
            cnt += 1;
        }
    }

    println!("{}", cnt);
}
