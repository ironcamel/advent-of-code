use std::fs;

fn main() {
    let input = fs::read_to_string("input-large.txt").expect("Failed to read input-large.txt");
    let mut cur: i64 = 50;
    let mut cnt: i64 = 0;

    for line in input.lines() {
        let line = line.trim();
        if line.is_empty() { continue; }
        let dir = &line[..1];
        let dist: i64 = line[1..].parse().expect("Invalid number");
        let tmp = if dir == "L" { cur - dist } else { cur + dist };
        let mut inc = if tmp == 0 || (tmp < 0 && cur != 0) { 1 } else { 0 };
        inc += tmp.abs() / 100;
        cnt += inc;
        cur = tmp.rem_euclid(100);
    }

    println!("{}", cnt);
}
