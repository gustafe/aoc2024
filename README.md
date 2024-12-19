# Advent of Code 2024

I use Perl for all the solutions.

Most assume the input data is in a file called `input.txt` in the
same directory as the file.

### A note on scoring

I award myself one point per star, but only if I manage to solve it
myself without help.

## TODO

- Day 12 part 2
- Day 15 part 2
- Day 17 part 2

## Solution comments in reverse order

Running score: 33 / 38

### Day 19: Linen Layout

Part 1 was simple enough, I just used BFS as usual this year. For part 2 I copped out and found a nice solution for the recursion logic in the subreddit. Credit in source.

Score: 1

Leaderboard completion time: 03m16s

### Day 18: RAM Run

This is what's called a "breather episode". Basic Dijkstra's combined with adding blocks until no paths are found. Runs in around a minute. Can probably be optimized. 

Score: 2

Leaderboard completion time: 05m55s

### Day 17: Chronospatial Computer

Part 1 only for now.

Score: 1

Leaderboard completion time: 44m39s

### Day 16: Reindeer Maze

Thank you `Array::Heap::PriorityQueue::Numeric`!

Had to look for tips on how to keep track of all the paths in part 2. Credit in source. 

Rating: 3/5

Score: 2

Leaderboard completion time: 13m47s

### Day 15: Warehouse Woes

Part 1 done, part 2 in the backlog

Score: 1

Leaderboard completion time: 30m00s

### Day 14: Restroom Redoubt

A fun problem once you got around the incredibly vague requirement for part 2. 

Rating: 4/5

Score: 2

Leaderboard completion time: 15m48s

### Day 13: Claw Contraption

My first stab at linear algebra failed miserably, so I quickly cribbed
a search with priority queue from a previous year. This was way too
slow for part 2 so I revisited the algebra solution and figured out
how to only return integer solutions.

Score: 2

Leaderboard completion time: 11m04s

### Day 12: Garden Groups

Part 1 only for now.

I use flood-fill to fill out the different areas, and at the same time
I mark out if I find a border and in which direction it's facing. That
helped me find the perimiter, and is a good start for finding sides
(or rather corners), but I still need to figure out all the literal
edge cases.

Score: 1

Leaderboard completion time: 17m42s

### Day 11: Plutonian Pebbles

I awarded myself a "freebie" for part 2 today because the solution I
found in the subreddit (see comments for credit) was so elegant, and I
felt I deserved it. Score decreased accordingly.

Rating: 4/5

Score: **1**

Leaderboard completion time: 06m24s

### Day 10: Hoof It

This year's easiest part 2 for me, I just happened to record the data
needed. Judging from the subreddit, so did everyone else.

Rating: 3/5

Score: 2

Leaderboard completion time: 04m14s

### Day 9: Disk Fragmenter

I'm usually pretty careful when copying the puzzle input, but today
the buffer size on macOS Terminal failed me. It was only after
comparing my algo with some on the subreddit that I figured out I was
right all along.

Part 2 was straightforward but slow until I put in some auxilary
hashes to keep track of the gaps.

The two solutions share a common-ish data structure but quite
different algorithms. I'm usually not a huge fan of copy-paste between
the 2 parts but in this case I couldn't really be bothered with trying
to reconcile them style-wise.

Rating: 4/5, nice brain teaser and satisfying to solve. 

Score: 2

Leaderboard completion time: 14m05s

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

1. Day 17 - Chronospatial Computer: 44m39s
1. Day 15 - Warehouse Woes: 30m00s
1. Day 12 - Garden Groups: 17m42s
1. Day 14 - Restroom Redoubt: 15m48s
1. Day 09 - Disk Fragmenter: 14m05s
1. Day 16 - Reindeer Maze: 13m47s
1. Day 13 - Claw Contraption: 11m04s
1. Day 06 - Guard Gallivant: 08m53s
1. Day 08 - Resonant Collinearity: 07m12s
1. Day 11 - Plutonian Pebbles: 06m24s
1. Day 18 - RAM Run: 05m55s
1. Day 04 - Ceres Search: 05m41s
1. Day 02 - Red Nosed Reports: 04m42s
1. Day 10 - Hoof It: 04m14s
1. Day 07 - Bridge Repair: 03m47s
1. Day 05 - Print Queue: 03m43s
1. Day 03 - Mull It Over: 03m22s
1. Day 19 - Linen Layout: 03m16s
1. Day 01 - Historian Hysteria: 02m31s

