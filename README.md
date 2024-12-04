# Advent of Code 2024

I use Perl for all the solutions.

Most assume the input data is in a file called `input.txt` in the
same directory as the file.

### A note on scoring

I award myself one point per star, but only if I manage to solve it
myself without help.

## TODO

- nothing yet...

## Solution comments in reverse order

Running score: 8 / 8

### Day 4: Ceres Search

Not a difficult problem, but a fiddly one. 

As usual I represent the "map" as a hashref of hashrefs, because I want to be able to use negative indices without the risk of "wrapping around" which is a risk if you use arrays or arrayrefs. 

Score: 2

Leaderboard completion time: 05m41s

### Day 3: Mull It Over

I'm going to add a new section to my "HOWTO AoC" post - a little regex
goes a long way.

Score: 2

Leaderboard completion time: 3m22s

### Day 2: Red-Nosed Reports

I'm sure there's a smarter way to handle part 2 than simply removing
each element one by one and testing the result, but it's still fast
enough for this dataset.

Every year there’s a day when I have to use Perl’s `splice` function,
and every year I stare at the man page in mystification. Where does
this syntax come from?!

Score: 2

Leaderboard completion time: 04m42s

### Day 01: Historian Hysteria

Not a difficult problem, as expected from day 1. For some reason I
just guessed that the items in the left list would be unique, but wise
from previous problems I actually checked this.

Score: 2

Leaderboard completion time: 02m31s

### Puzzles by difficulty  (leaderboard completion times)

1. Day 04 - Ceres Search: 05m41s
1. Day 02 - Red Nosed Reports: 04m42s
1. Day 03 - Mull It Over: 3m22s
1. Day 01 - Historian Hysteria: 02m31s

