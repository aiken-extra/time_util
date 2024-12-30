use aiken/interval.{
  after, before, between, entirely_after, entirely_before, entirely_between,
}
use time_util/time.{
  CS, DS, Day, Hour, MS, Minute, Second, Week, Zero, add_interval, sub_interval,
}

/// Testing for `add_interval` autimatically tests for `add_bound`, `add_finite`, and `add_time` too.
test testing_add_interval() {
  and {
    ( after(1) |> add_interval(Zero, Zero) ) == after(1 + 0),
    ( after(2) |> add_interval(3 |> MS, Zero) ) == after(2 + 3),
    ( after(3) |> add_interval(Zero, 4 |> MS) ) == after(3 + 0),
    ( after(4) |> add_interval(5 |> MS, 6 |> MS) ) == after(4 + 5),
    // testing entirely_after and CS:
    ( entirely_after(5) |> add_interval(Zero, Zero) ) == entirely_after(
      5 + 0 * 10,
    ),
    ( entirely_after(6) |> add_interval(7 |> CS, Zero) ) == entirely_after(
      6 + 7 * 10,
    ),
    ( entirely_after(7) |> add_interval(Zero, 8 |> CS) ) == entirely_after(
      7 + 0 * 10,
    ),
    ( entirely_after(8) |> add_interval(9 |> CS, 10 |> CS) ) == entirely_after(
      8 + 9 * 10,
    ),
    // testing before and DS:
    ( before(9) |> add_interval(Zero, Zero) ) == before(9 + 0 * 100),
    ( before(10) |> add_interval(11 |> DS, Zero) ) == before(10 + 0 * 100),
    ( before(11) |> add_interval(Zero, 12 |> DS) ) == before(11 + 12 * 100),
    ( before(12) |> add_interval(13 |> DS, 14 |> DS) ) == before(12 + 14 * 100),
    // testing entirely_before and Second:
    ( entirely_before(13) |> add_interval(Zero, Zero) ) == entirely_before(
      13 + 0 * 1_000,
    ),
    ( entirely_before(14) |> add_interval(15 |> Second, Zero) ) == entirely_before(
      14 + 0 * 1_000,
    ),
    ( entirely_before(15) |> add_interval(Zero, 16 |> Second) ) == entirely_before(
      15 + 16 * 1_000,
    ),
    ( entirely_before(16) |> add_interval(17 |> Second, 18 |> Second) ) == entirely_before(
      16 + 18 * 1_000,
    ),
    // testing between and Minute:
    ( between(17, 21) |> add_interval(Zero, Zero) ) == between(
      17 + 0 * 60 * 1_000,
      21 + 0 * 60 * 1_000,
    ),
    ( between(18, 22) |> add_interval(25 |> Minute, Zero) ) == between(
      18 + 25 * 60 * 1_000,
      22 + 0 * 60 * 1_000,
    ),
    ( between(19, 23) |> add_interval(Zero, 26 |> Minute) ) == between(
      19 + 0 * 60 * 1_000,
      23 + 26 * 60 * 1_000,
    ),
    ( between(20, 24) |> add_interval(27 |> Minute, 28 |> Minute) ) == between(
      20 + 27 * 60 * 1_000,
      24 + 28 * 60 * 1_000,
    ),
    // testing entirely_between and Hour:
    ( entirely_between(21, 25) |> add_interval(Zero, Zero) ) == entirely_between(
      21 + 0 * 60 * 60 * 1_000,
      25 + 0 * 60 * 60 * 1_000,
    ),
    ( entirely_between(22, 26) |> add_interval(29 |> Hour, Zero) ) == entirely_between(
      22 + 29 * 60 * 60 * 1_000,
      26 + 0 * 60 * 60 * 1_000,
    ),
    ( entirely_between(23, 27) |> add_interval(Zero, 30 |> Hour) ) == entirely_between(
      23 + 0 * 60 * 60 * 1_000,
      27 + 30 * 60 * 60 * 1_000,
    ),
    ( entirely_between(24, 28) |> add_interval(31 |> Hour, 32 |> Hour) ) == entirely_between(
      24 + 31 * 60 * 60 * 1_000,
      28 + 32 * 60 * 60 * 1_000,
    ),
    // testing Day and Week:
    ( after(25) |> add_interval(29 |> Day, 30 |> Week) ) == after(
      25 + 29 * 24 * 60 * 60 * 1_000,
    ),
    ( before(26) |> add_interval(31 |> Week, 32 |> Day) ) == before(
      26 + 32 * 24 * 60 * 60 * 1_000,
    ),
    ( entirely_after(27) |> add_interval(33 |> Week, 34 |> Day) ) == entirely_after(
      27 + 33 * 7 * 24 * 60 * 60 * 1_000,
    ),
    ( entirely_before(28) |> add_interval(35 |> Day, 36 |> Week) ) == entirely_before(
      28 + 36 * 7 * 24 * 60 * 60 * 1_000,
    ),
  }
}

/// Testing for `sub_interval` autimatically tests for `sub_bound`, `sub_finite`, and `sub_time` too.
test testing_sub_interval() {
  and {
    ( after(2400000) |> sub_interval(3 |> Hour, 4 |> Hour) ) == after(
      2400000 - 3 * 60 * 60 * 1_000,
    ),
    ( after(2300000) |> sub_interval(2 |> Hour, Zero) ) == after(
      2300000 - 2 * 60 * 60 * 1_000,
    ),
    ( after(2200000) |> sub_interval(Zero, 1 |> Hour) ) == after(
      2200000 - 0 * 60 * 60 * 1_000,
    ),
    ( after(2100000) |> sub_interval(Zero, Zero) ) == after(
      2100000 - 0 * 60 * 60 * 1_000,
    ),
    // testing entirely_after and Minute:
    ( entirely_after(200000) |> sub_interval(3 |> Minute, 4 |> Minute) ) == entirely_after(
      200000 - 3 * 60 * 1_000,
    ),
    ( entirely_after(190000) |> sub_interval(2 |> Minute, Zero) ) == entirely_after(
      190000 - 2 * 60 * 1_000,
    ),
    ( entirely_after(180000) |> sub_interval(Zero, 1 |> Minute) ) == entirely_after(
      180000 - 0 * 60 * 1_000,
    ),
    ( entirely_after(170000) |> sub_interval(Zero, Zero) ) == entirely_after(
      170000 - 0 * 60 * 1_000,
    ),
    // testing before and Second:
    ( before(16000) |> sub_interval(3 |> Second, 4 |> Second) ) == before(
      16000 - 4 * 1_000,
    ),
    ( before(15000) |> sub_interval(2 |> Second, Zero) ) == before(
      15000 - 0 * 1_000,
    ),
    ( before(14000) |> sub_interval(Zero, 1 |> Second) ) == before(
      14000 - 1 * 1_000,
    ),
    ( before(13000) |> sub_interval(Zero, Zero) ) == before(13000 - 0 * 1_000),
    // testing entirely_before and DS:
    ( entirely_before(1200) |> sub_interval(3 |> DS, 4 |> DS) ) == entirely_before(
      1200 - 4 * 100,
    ),
    ( entirely_before(1100) |> sub_interval(2 |> DS, Zero) ) == entirely_before(
      1100 - 0 * 100,
    ),
    ( entirely_before(1000) |> sub_interval(Zero, 1 |> DS) ) == entirely_before(
      1000 - 1 * 100,
    ),
    ( entirely_before(900) |> sub_interval(Zero, Zero) ) == entirely_before(
      900 - 0 * 100,
    ),
    // testing between and CS:
    ( between(80, 250) |> sub_interval(3 |> CS, 4 |> CS) ) == between(
      80 - 3 * 10,
      250 - 4 * 10,
    ),
    ( between(70, 260) |> sub_interval(2 |> CS, Zero) ) == between(
      70 - 2 * 10,
      260 - 0 * 10,
    ),
    ( between(60, 270) |> sub_interval(Zero, 1 |> CS) ) == between(
      60 - 0 * 10,
      270 - 1 * 10,
    ),
    ( between(50, 280) |> sub_interval(Zero, Zero) ) == between(
      50 - 0 * 10,
      280 - 0 * 10,
    ),
    // testing entirely_between and MS:
    ( entirely_between(4, 29) |> sub_interval(3 |> MS, 4 |> MS) ) == entirely_between(
      4 - 3,
      29 - 4,
    ),
    ( entirely_between(3, 30) |> sub_interval(2 |> MS, Zero) ) == entirely_between(
      3 - 2,
      30 - 0,
    ),
    ( entirely_between(2, 31) |> sub_interval(Zero, 1 |> MS) ) == entirely_between(
      2 - 0,
      31 - 1,
    ),
    ( entirely_between(1, 32) |> sub_interval(Zero, Zero) ) == entirely_between(
      1 - 0,
      32 - 0,
    ),
    // testing Day and Week:
    ( after(33000000) |> sub_interval(4 |> Day, 5 |> Week) ) == after(
      33000000 - 4 * 24 * 60 * 60 * 1_000,
    ),
    ( before(34000000) |> sub_interval(3 |> Week, 4 |> Day) ) == before(
      34000000 - 4 * 24 * 60 * 60 * 1_000,
    ),
    ( entirely_after(350000000) |> sub_interval(2 |> Week, 3 |> Day) ) == entirely_after(
      350000000 - 2 * 7 * 24 * 60 * 60 * 1_000,
    ),
    ( entirely_before(360000000) |> sub_interval(1 |> Day, 2 |> Week) ) == entirely_before(
      360000000 - 2 * 7 * 24 * 60 * 60 * 1_000,
    ),
  }
}
