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

Running score: 16 / 16

### Day 8: Resonant Collinearity

This wasn't a very hard problem really, but the description was
unusually vague for AoC. In the end I just had to work against the
example and change my code until I got the same result.

Also shoutout to Eric, that _scamp_, that included a zero in the data
set that totally broke my existence code in part 2. It was a fun thing
to figure out.

Score: 2

Leaderboard completion time: 07m12s

### Day 7: Bridge Repair

This was a fun one! I naively tried a combinatorics solution before
settling on a depth-first search instead. This is plenty fast for part
1 and still takes around 30s on part 2. 

Of course everyone and their preferred parental unit used recursion,
but that's too advanced for this smooth brain.

Rating: 4/5

Score: 2

Leaderboard completion time: 03m47s

### Day 6: Guard Gallivant

A tough but enjoyable puzzle. Part 2 threw me for a bit of a loop but
I opted for a brute-force solution. With some optimization it runs at
around 5m on my machine.

Rating: 4/5

Score: 2

Leaderboard completion time: 08m53s

### Day 5: Print Queue

This took me longer than it should have. I'll use yesterday's office
Christmas dinner as an excuse.

I could have tried to figure out a smarter way to sort each list
according to the rules... or I could just repeatedly switch elements I
know don't fit in until everything is ok. Runtime is less than a
second anyway.

Rating: 2/5

Score: 2

Leaderboard completion time: 03m43s

### Day 4: Ceres Search

Not a difficult problem, but a fiddly one. 

As usual I represent the "map" as a hashref of hashrefs, because I
want to be able to use negative indices without the risk of "wrapping
around" which is a risk if you use arrays or arrayrefs.

Rating: 3/5

Score: 2

Leaderboard completion time: 05m41s

### Day 3: Mull It Over

I'm going to add a new section to my "HOWTO AoC" post - a little regex
goes a long way.

Rating: 4/5

Score: 2

Leaderboard completion time: 03m22s

### Day 2: Red-Nosed Reports

I'm sure there's a smarter way to handle part 2 than simply removing
each element one by one and testing the result, but it's still fast
enough for this dataset.

Every year there’s a day when I have to use Perl’s `splice` function,
and every year I stare at the man page in mystification. Where does
this syntax come from?!

Rating: 3/5

Score: 2

Leaderboard completion time: 04m42s

### Day 01: Historian Hysteria

Not a difficult problem, as expected from day 1. For some reason I
just guessed that the items in the left list would be unique, but wise
from previous problems I actually checked this.

Rating: 3/5

Score: 2

Leaderboard completion time: 02m31s

### Puzzles by difficulty  (leaderboard completion times)

1. Day 06 - Guard Gallivant: 08m53s
1. Day 08 - Resonant Collinearity: 07m12s
1. Day 04 - Ceres Search: 05m41s
1. Day 02 - Red Nosed Reports: 04m42s
1. Day 07 - Bridge Repair: 03m47s
1. Day 05 - Print Queue: 03m43s
1. Day 03 - Mull It Over: 03m22s
1. Day 01 - Historian Hysteria: 02m31s

