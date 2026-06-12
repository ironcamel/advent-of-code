use std::fs;

fn is_mirror(n: u64) -> bool {
    let s = n.to_string();
    let len = s.len();
    if len % 2 != 0 {
        return false;
    }
    s[..len / 2] == s[len / 2..]
}

fn main() {
    let input = fs::read_to_string("input-large.txt").expect("Failed to read input-large.txt");
    let ans: u64 = input
        .split(',')
        .flat_map(|s| {
            let s = s.trim();
            let (r1, r2) = s.split_once('-').expect("Invalid range");
            let r1: u64 = r1.parse().expect("Invalid number");
            let r2: u64 = r2.parse().expect("Invalid number");
            (r1..=r2).filter(|&n| is_mirror(n))
        })
        .sum();
    println!("{}", ans);
}
