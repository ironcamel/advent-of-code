use std::collections::HashSet;

fn main() {
    let mut grid = parse_input("input-large.txt");
    let orig_size = grid.len();
    let mut size = orig_size;
    loop {
        grid = reduce_grid(&grid);
        if grid.len() == size { break }
        size = grid.len();
    }
    println!("{}", orig_size - size);
}

fn reduce_grid(grid: &HashSet<(i32, i32)>) -> HashSet<(i32, i32)> {
    grid.iter().filter(|p| !can_remove(p, grid)).cloned().collect()
}

fn can_remove(p: &(i32, i32), grid: &HashSet<(i32, i32)>) -> bool {
    let unit_circle = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)];
    let count = unit_circle.iter().filter(|v| grid.contains(&(p.0 + v.0, p.1 + v.1))).count();
    count < 4
}

fn parse_input(path: &str) -> HashSet<(i32, i32)> {
    let mut grid = HashSet::new();
    let contents = std::fs::read_to_string(path).expect("Failed to read file");
    for (i, line) in contents.lines().enumerate() {
        for (j, c) in line.chars().enumerate() {
            if c == '@' {
                grid.insert((i as i32, j as i32));
            }
        }
    }
    grid
}




