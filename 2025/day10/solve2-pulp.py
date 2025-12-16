#!/bin/env python
import pulp, re

def main():
    with open('input-large.txt', 'r') as file:
        lines = file.readlines()
    pat = re.compile(r'\] (.+) \{(.+)\}')
    machines = []
    for line in lines:
        (buttons, values) = pat.search(line).groups()
        buttons = buttons.replace('(', '').replace(')', '').split()
        buttons = [ list(map(int, b.split(','))) for b in buttons ]
        values = list(map(int, values.split(',')))
        machines.append((buttons, values))
    print(sum([ solve_machine(m) for m in machines ]))

def solve_machine(machine):
    (buttons, values) = machine
    prob = pulp.LpProblem('problem', pulp.LpMinimize)
    vars1 = pulp.LpVariable.dicts("a", range(len(buttons)), lowBound=0, cat='Integer')
    prob += pulp.lpSum(vars1)
    for i, value in enumerate(values):
        vars2 = []
        for j, button in enumerate(buttons):
            if i in button:
                vars2.append(vars1[j])
        prob += pulp.lpSum(vars2) == value

    prob.solve(pulp.PULP_CBC_CMD(msg=False))
    return int(prob.objective.value())

main()

# 33 - input-small.txt answer
# 20298 - input-large.txt answer
