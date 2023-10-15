//// ```
//// ┍━ test_cheap_interval_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 1830243, cpu: 682955348] interval_starts_after_deadline
//// │ PASS [mem: 1826639, cpu: 681740964] interval_starts_after_or_at_deadline
//// │ PASS [mem: 1808033, cpu: 677043788] interval_starts_before_deadline
//// │ PASS [mem: 1804429, cpu: 675829404] interval_starts_before_or_at_deadline
//// │ PASS [mem: 1796237, cpu: 672006062] interval_ends_after_deadline
//// │ PASS [mem: 1792633, cpu: 670791678] interval_ends_after_or_at_deadline
//// │ PASS [mem: 1818447, cpu: 677917622] interval_ends_before_deadline
//// │ PASS [mem: 1814843, cpu: 676703238] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// ```

use aiken/interval.{
  after, before, between, entirely_after, entirely_before, entirely_between,
}
use time_util/cheap/interval as time

test interval_starts_after_deadline() {
  let deadline = between(5, 5)
  let starts_after_deadline_interval =
    time.starts_after(_, deadline)
  and {
    after(4) |> starts_after_deadline_interval() |> not,
    after(5) |> starts_after_deadline_interval() |> not,
    after(6) |> starts_after_deadline_interval(),
    entirely_after(3) |> starts_after_deadline_interval() |> not,
    entirely_after(4) |> starts_after_deadline_interval() |> not,
    entirely_after(5) |> starts_after_deadline_interval(),
    before(4) |> starts_after_deadline_interval() |> not,
    before(5) |> starts_after_deadline_interval() |> not,
    before(6) |> starts_after_deadline_interval() |> not,
    entirely_before(5) |> starts_after_deadline_interval() |> not,
    entirely_before(6) |> starts_after_deadline_interval() |> not,
    entirely_before(7) |> starts_after_deadline_interval() |> not,
    between(1, 4) |> starts_after_deadline_interval() |> not,
    between(2, 5) |> starts_after_deadline_interval() |> not,
    between(3, 6) |> starts_after_deadline_interval() |> not,
    between(4, 7) |> starts_after_deadline_interval() |> not,
    between(5, 8) |> starts_after_deadline_interval() |> not,
    between(6, 9) |> starts_after_deadline_interval(),
    entirely_between(2, 5) |> starts_after_deadline_interval() |> not,
    entirely_between(3, 6) |> starts_after_deadline_interval() |> not,
    entirely_between(4, 7) |> starts_after_deadline_interval() |> not,
    entirely_between(5, 8) |> starts_after_deadline_interval(),
  }
}

test interval_starts_after_or_at_deadline() {
  let deadline = between(5, 5)
  let starts_after_or_at_deadline_interval =
    time.starts_after_or_at(_, deadline)
  and {
    after(4) |> starts_after_or_at_deadline_interval() |> not,
    after(5) |> starts_after_or_at_deadline_interval(),
    after(6) |> starts_after_or_at_deadline_interval(),
    entirely_after(3) |> starts_after_or_at_deadline_interval() |> not,
    entirely_after(4) |> starts_after_or_at_deadline_interval(),
    entirely_after(5) |> starts_after_or_at_deadline_interval(),
    before(4) |> starts_after_or_at_deadline_interval() |> not,
    before(5) |> starts_after_or_at_deadline_interval() |> not,
    before(6) |> starts_after_or_at_deadline_interval() |> not,
    entirely_before(5) |> starts_after_or_at_deadline_interval() |> not,
    entirely_before(6) |> starts_after_or_at_deadline_interval() |> not,
    entirely_before(7) |> starts_after_or_at_deadline_interval() |> not,
    between(1, 4) |> starts_after_or_at_deadline_interval() |> not,
    between(2, 5) |> starts_after_or_at_deadline_interval() |> not,
    between(3, 6) |> starts_after_or_at_deadline_interval() |> not,
    between(4, 7) |> starts_after_or_at_deadline_interval() |> not,
    between(5, 8) |> starts_after_or_at_deadline_interval(),
    between(6, 9) |> starts_after_or_at_deadline_interval(),
    entirely_between(2, 5) |> starts_after_or_at_deadline_interval() |> not,
    entirely_between(3, 6) |> starts_after_or_at_deadline_interval() |> not,
    entirely_between(4, 7) |> starts_after_or_at_deadline_interval(),
    entirely_between(5, 8) |> starts_after_or_at_deadline_interval(),
  }
}

test interval_starts_before_deadline() {
  let deadline = between(5, 5)
  let starts_before_deadline_interval =
    time.starts_before(_, deadline)
  and {
    after(4) |> starts_before_deadline_interval(),
    after(5) |> starts_before_deadline_interval() |> not,
    after(6) |> starts_before_deadline_interval() |> not,
    entirely_after(3) |> starts_before_deadline_interval(),
    entirely_after(4) |> starts_before_deadline_interval() |> not,
    entirely_after(5) |> starts_before_deadline_interval() |> not,
    before(4) |> starts_before_deadline_interval(),
    before(5) |> starts_before_deadline_interval(),
    before(6) |> starts_before_deadline_interval(),
    entirely_before(5) |> starts_before_deadline_interval(),
    entirely_before(6) |> starts_before_deadline_interval(),
    entirely_before(7) |> starts_before_deadline_interval(),
    between(1, 4) |> starts_before_deadline_interval(),
    between(2, 5) |> starts_before_deadline_interval(),
    between(3, 6) |> starts_before_deadline_interval(),
    between(4, 7) |> starts_before_deadline_interval(),
    between(5, 8) |> starts_before_deadline_interval() |> not,
    between(6, 9) |> starts_before_deadline_interval() |> not,
    entirely_between(2, 5) |> starts_before_deadline_interval(),
    entirely_between(3, 6) |> starts_before_deadline_interval(),
    entirely_between(4, 7) |> starts_before_deadline_interval() |> not,
    entirely_between(5, 8) |> starts_before_deadline_interval() |> not,
  }
}

test interval_starts_before_or_at_deadline() {
  let deadline = between(5, 5)
  let starts_before_or_at_deadline_interval =
    time.starts_before_or_at(_, deadline)
  and {
    after(4) |> starts_before_or_at_deadline_interval(),
    after(5) |> starts_before_or_at_deadline_interval(),
    after(6) |> starts_before_or_at_deadline_interval() |> not,
    entirely_after(3) |> starts_before_or_at_deadline_interval(),
    entirely_after(4) |> starts_before_or_at_deadline_interval(),
    entirely_after(5) |> starts_before_or_at_deadline_interval() |> not,
    before(4) |> starts_before_or_at_deadline_interval(),
    before(5) |> starts_before_or_at_deadline_interval(),
    before(6) |> starts_before_or_at_deadline_interval(),
    entirely_before(5) |> starts_before_or_at_deadline_interval(),
    entirely_before(6) |> starts_before_or_at_deadline_interval(),
    entirely_before(7) |> starts_before_or_at_deadline_interval(),
    between(1, 4) |> starts_before_or_at_deadline_interval(),
    between(2, 5) |> starts_before_or_at_deadline_interval(),
    between(3, 6) |> starts_before_or_at_deadline_interval(),
    between(4, 7) |> starts_before_or_at_deadline_interval(),
    between(5, 8) |> starts_before_or_at_deadline_interval(),
    between(6, 9) |> starts_before_or_at_deadline_interval() |> not,
    entirely_between(2, 5) |> starts_before_or_at_deadline_interval(),
    entirely_between(3, 6) |> starts_before_or_at_deadline_interval(),
    entirely_between(4, 7) |> starts_before_or_at_deadline_interval(),
    entirely_between(5, 8) |> starts_before_or_at_deadline_interval() |> not,
  }
}

test interval_ends_after_deadline() {
  let deadline = between(5, 5)
  let ends_after_deadline_interval =
    time.ends_after(_, deadline)
  and {
    after(4) |> ends_after_deadline_interval(),
    after(5) |> ends_after_deadline_interval(),
    after(6) |> ends_after_deadline_interval(),
    entirely_after(3) |> ends_after_deadline_interval(),
    entirely_after(4) |> ends_after_deadline_interval(),
    entirely_after(5) |> ends_after_deadline_interval(),
    before(4) |> ends_after_deadline_interval() |> not,
    before(5) |> ends_after_deadline_interval() |> not,
    before(6) |> ends_after_deadline_interval(),
    entirely_before(5) |> ends_after_deadline_interval() |> not,
    entirely_before(6) |> ends_after_deadline_interval() |> not,
    entirely_before(7) |> ends_after_deadline_interval(),
    between(1, 4) |> ends_after_deadline_interval() |> not,
    between(2, 5) |> ends_after_deadline_interval() |> not,
    between(3, 6) |> ends_after_deadline_interval(),
    between(4, 7) |> ends_after_deadline_interval(),
    between(5, 8) |> ends_after_deadline_interval(),
    between(6, 9) |> ends_after_deadline_interval(),
    entirely_between(2, 5) |> ends_after_deadline_interval() |> not,
    entirely_between(3, 6) |> ends_after_deadline_interval() |> not,
    entirely_between(4, 7) |> ends_after_deadline_interval(),
    entirely_between(5, 8) |> ends_after_deadline_interval(),
  }
}

test interval_ends_after_or_at_deadline() {
  let deadline = between(5, 5)
  let ends_after_or_at_deadline_interval =
    time.ends_after_or_at(_, deadline)
  and {
    after(4) |> ends_after_or_at_deadline_interval(),
    after(5) |> ends_after_or_at_deadline_interval(),
    after(6) |> ends_after_or_at_deadline_interval(),
    entirely_after(3) |> ends_after_or_at_deadline_interval(),
    entirely_after(4) |> ends_after_or_at_deadline_interval(),
    entirely_after(5) |> ends_after_or_at_deadline_interval(),
    before(4) |> ends_after_or_at_deadline_interval() |> not,
    before(5) |> ends_after_or_at_deadline_interval(),
    before(6) |> ends_after_or_at_deadline_interval(),
    entirely_before(5) |> ends_after_or_at_deadline_interval() |> not,
    entirely_before(6) |> ends_after_or_at_deadline_interval(),
    entirely_before(7) |> ends_after_or_at_deadline_interval(),
    between(1, 4) |> ends_after_or_at_deadline_interval() |> not,
    between(2, 5) |> ends_after_or_at_deadline_interval(),
    between(3, 6) |> ends_after_or_at_deadline_interval(),
    between(4, 7) |> ends_after_or_at_deadline_interval(),
    between(5, 8) |> ends_after_or_at_deadline_interval(),
    between(6, 9) |> ends_after_or_at_deadline_interval(),
    entirely_between(2, 5) |> ends_after_or_at_deadline_interval() |> not,
    entirely_between(3, 6) |> ends_after_or_at_deadline_interval(),
    entirely_between(4, 7) |> ends_after_or_at_deadline_interval(),
    entirely_between(5, 8) |> ends_after_or_at_deadline_interval(),
  }
}

test interval_ends_before_deadline() {
  let deadline = between(5, 5)
  let ends_before_deadline_interval =
    time.ends_before(_, deadline)
  and {
    after(4) |> ends_before_deadline_interval() |> not,
    after(5) |> ends_before_deadline_interval() |> not,
    after(6) |> ends_before_deadline_interval() |> not,
    entirely_after(3) |> ends_before_deadline_interval() |> not,
    entirely_after(4) |> ends_before_deadline_interval() |> not,
    entirely_after(5) |> ends_before_deadline_interval() |> not,
    before(4) |> ends_before_deadline_interval(),
    before(5) |> ends_before_deadline_interval() |> not,
    before(6) |> ends_before_deadline_interval() |> not,
    entirely_before(5) |> ends_before_deadline_interval(),
    entirely_before(6) |> ends_before_deadline_interval() |> not,
    entirely_before(7) |> ends_before_deadline_interval() |> not,
    between(1, 4) |> ends_before_deadline_interval(),
    between(2, 5) |> ends_before_deadline_interval() |> not,
    between(3, 6) |> ends_before_deadline_interval() |> not,
    between(4, 7) |> ends_before_deadline_interval() |> not,
    between(5, 8) |> ends_before_deadline_interval() |> not,
    between(6, 9) |> ends_before_deadline_interval() |> not,
    entirely_between(2, 5) |> ends_before_deadline_interval(),
    entirely_between(3, 6) |> ends_before_deadline_interval() |> not,
    entirely_between(4, 7) |> ends_before_deadline_interval() |> not,
    entirely_between(5, 8) |> ends_before_deadline_interval() |> not,
  }
}

test interval_ends_before_or_at_deadline() {
  let deadline = between(5, 5)
  let ends_before_or_at_deadline_interval =
    time.ends_before_or_at(_, deadline)
  and {
    after(4) |> ends_before_or_at_deadline_interval() |> not,
    after(5) |> ends_before_or_at_deadline_interval() |> not,
    after(6) |> ends_before_or_at_deadline_interval() |> not,
    entirely_after(3) |> ends_before_or_at_deadline_interval() |> not,
    entirely_after(4) |> ends_before_or_at_deadline_interval() |> not,
    entirely_after(5) |> ends_before_or_at_deadline_interval() |> not,
    before(4) |> ends_before_or_at_deadline_interval(),
    before(5) |> ends_before_or_at_deadline_interval(),
    before(6) |> ends_before_or_at_deadline_interval() |> not,
    entirely_before(5) |> ends_before_or_at_deadline_interval(),
    entirely_before(6) |> ends_before_or_at_deadline_interval(),
    entirely_before(7) |> ends_before_or_at_deadline_interval() |> not,
    between(1, 4) |> ends_before_or_at_deadline_interval(),
    between(2, 5) |> ends_before_or_at_deadline_interval(),
    between(3, 6) |> ends_before_or_at_deadline_interval() |> not,
    between(4, 7) |> ends_before_or_at_deadline_interval() |> not,
    between(5, 8) |> ends_before_or_at_deadline_interval() |> not,
    between(6, 9) |> ends_before_or_at_deadline_interval() |> not,
    entirely_between(2, 5) |> ends_before_or_at_deadline_interval(),
    entirely_between(3, 6) |> ends_before_or_at_deadline_interval(),
    entirely_between(4, 7) |> ends_before_or_at_deadline_interval() |> not,
    entirely_between(5, 8) |> ends_before_or_at_deadline_interval() |> not,
  }
}
