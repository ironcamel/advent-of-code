use std::fs;
use std::thread;

fn is_repeating(n: u64) -> bool {
    let s = n.to_string();
    let len = s.len();
    for i in 1..=(len / 2) {
        if s[..i].repeat(len / i) == s {
            return true;
        }
    }
    false
}

fn solve(r1: u64, r2: u64) -> u64 {
    (r1..=r2).filter(|&n| is_repeating(n)).sum()
}

fn main() {
    let input = fs::read_to_string("input-large.txt").expect("Failed to read input-large.txt");
    let ranges: Vec<(u64, u64)> = input
        .split(',')
        .map(|s| {
            let s = s.trim();
            let (r1, r2) = s.split_once('-').expect("Invalid range");
            (r1.parse().unwrap(), r2.parse().unwrap())
        })
        .collect();

    let handles: Vec<_> = ranges
        .into_iter()
        .map(|(r1, r2)| thread::spawn(move || solve(r1, r2)))
        .collect();

    let ans: u64 = handles.into_iter().map(|h| h.join().unwrap()).sum();
    println!("{}", ans);
}
