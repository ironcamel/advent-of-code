use std::collections::HashMap;
use std::fs;

const UNIT_CIRCLE: [(i32, i32); 8] = [
    (-1, -1), (-1, 0), (-1, 1),
    ( 0, -1),          ( 0, 1),
    ( 1, -1), ( 1, 0), ( 1, 1),
];

fn main() {
    let input = fs::read_to_string("input-large.txt").expect("Failed to read input");
    let grid: HashMap<(i32, i32), char> = input
        .lines()
        .enumerate()
        .flat_map(|(i, line)| {
            line.chars()
                .enumerate()
                .map(move |(j, c)| ((i as i32, j as i32), c))
        })
        .collect();

    let ans = grid
        .iter()
        .filter(|(&point, &val)| {
            val == '@' && UNIT_CIRCLE.iter().filter(|&&(di, dj)| {
                grid.get(&(point.0 + di, point.1 + dj)) == Some(&'@')
            }).count() < 4
        })
        .count();

    println!("{}", ans);
}
