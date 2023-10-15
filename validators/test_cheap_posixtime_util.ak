//// ```
//// ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem:  831057, cpu: 305559109] interval_starts_after_deadline
//// │ PASS [mem:  827453, cpu: 304344725] interval_starts_after_or_at_deadline
//// │ PASS [mem:  822047, cpu: 302683549] interval_starts_before_deadline
//// │ PASS [mem:  818443, cpu: 301469165] interval_starts_before_or_at_deadline
//// │ PASS [mem:  822047, cpu: 302683549] interval_ends_after_deadline
//// │ PASS [mem:  818443, cpu: 301469165] interval_ends_after_or_at_deadline
//// │ PASS [mem:  831057, cpu: 305559109] interval_ends_before_deadline
//// │ PASS [mem:  827453, cpu: 304344725] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// ```

use aiken/interval.{
  after, before, between, entirely_after, entirely_before, entirely_between,
}
use time_util/cheap/posixtime.{
  ends_after, ends_after_or_at, ends_before, ends_before_or_at, starts_after,
  starts_after_or_at, starts_before, starts_before_or_at,
}

test interval_starts_after_deadline() {
  and {
    after(4) |> starts_after(5) |> not,
    after(5) |> starts_after(5) |> not,
    after(6) |> starts_after(5),
    entirely_after(3) |> starts_after(5) |> not,
    entirely_after(4) |> starts_after(5) |> not,
    entirely_after(5) |> starts_after(5),
    before(4) |> starts_after(5) |> not,
    before(5) |> starts_after(5) |> not,
    before(6) |> starts_after(5) |> not,
    entirely_before(5) |> starts_after(5) |> not,
    entirely_before(6) |> starts_after(5) |> not,
    entirely_before(7) |> starts_after(5) |> not,
    between(1, 4) |> starts_after(5) |> not,
    between(2, 5) |> starts_after(5) |> not,
    between(3, 6) |> starts_after(5) |> not,
    between(4, 7) |> starts_after(5) |> not,
    between(5, 8) |> starts_after(5) |> not,
    between(6, 9) |> starts_after(5),
    entirely_between(2, 5) |> starts_after(5) |> not,
    entirely_between(3, 6) |> starts_after(5) |> not,
    entirely_between(4, 7) |> starts_after(5) |> not,
    entirely_between(5, 8) |> starts_after(5),
  }
}

test interval_starts_after_or_at_deadline() {
  and {
    after(4) |> starts_after_or_at(5) |> not,
    after(5) |> starts_after_or_at(5),
    after(6) |> starts_after_or_at(5),
    entirely_after(3) |> starts_after_or_at(5) |> not,
    entirely_after(4) |> starts_after_or_at(5),
    entirely_after(5) |> starts_after_or_at(5),
    before(4) |> starts_after_or_at(5) |> not,
    before(5) |> starts_after_or_at(5) |> not,
    before(6) |> starts_after_or_at(5) |> not,
    entirely_before(5) |> starts_after_or_at(5) |> not,
    entirely_before(6) |> starts_after_or_at(5) |> not,
    entirely_before(7) |> starts_after_or_at(5) |> not,
    between(1, 4) |> starts_after_or_at(5) |> not,
    between(2, 5) |> starts_after_or_at(5) |> not,
    between(3, 6) |> starts_after_or_at(5) |> not,
    between(4, 7) |> starts_after_or_at(5) |> not,
    between(5, 8) |> starts_after_or_at(5),
    between(6, 9) |> starts_after_or_at(5),
    entirely_between(2, 5) |> starts_after_or_at(5) |> not,
    entirely_between(3, 6) |> starts_after_or_at(5) |> not,
    entirely_between(4, 7) |> starts_after_or_at(5),
    entirely_between(5, 8) |> starts_after_or_at(5),
  }
}

test interval_starts_before_deadline() {
  and {
    after(4) |> starts_before(5),
    after(5) |> starts_before(5) |> not,
    after(6) |> starts_before(5) |> not,
    entirely_after(3) |> starts_before(5),
    entirely_after(4) |> starts_before(5) |> not,
    entirely_after(5) |> starts_before(5) |> not,
    before(4) |> starts_before(5),
    before(5) |> starts_before(5),
    before(6) |> starts_before(5),
    entirely_before(5) |> starts_before(5),
    entirely_before(6) |> starts_before(5),
    entirely_before(7) |> starts_before(5),
    between(1, 4) |> starts_before(5),
    between(2, 5) |> starts_before(5),
    between(3, 6) |> starts_before(5),
    between(4, 7) |> starts_before(5),
    between(5, 8) |> starts_before(5) |> not,
    between(6, 9) |> starts_before(5) |> not,
    entirely_between(2, 5) |> starts_before(5),
    entirely_between(3, 6) |> starts_before(5),
    entirely_between(4, 7) |> starts_before(5) |> not,
    entirely_between(5, 8) |> starts_before(5) |> not,
  }
}

test interval_starts_before_or_at_deadline() {
  and {
    after(4) |> starts_before_or_at(5),
    after(5) |> starts_before_or_at(5),
    after(6) |> starts_before_or_at(5) |> not,
    entirely_after(3) |> starts_before_or_at(5),
    entirely_after(4) |> starts_before_or_at(5),
    entirely_after(5) |> starts_before_or_at(5) |> not,
    before(4) |> starts_before_or_at(5),
    before(5) |> starts_before_or_at(5),
    before(6) |> starts_before_or_at(5),
    entirely_before(5) |> starts_before_or_at(5),
    entirely_before(6) |> starts_before_or_at(5),
    entirely_before(7) |> starts_before_or_at(5),
    between(1, 4) |> starts_before_or_at(5),
    between(2, 5) |> starts_before_or_at(5),
    between(3, 6) |> starts_before_or_at(5),
    between(4, 7) |> starts_before_or_at(5),
    between(5, 8) |> starts_before_or_at(5),
    between(6, 9) |> starts_before_or_at(5) |> not,
    entirely_between(2, 5) |> starts_before_or_at(5),
    entirely_between(3, 6) |> starts_before_or_at(5),
    entirely_between(4, 7) |> starts_before_or_at(5),
    entirely_between(5, 8) |> starts_before_or_at(5) |> not,
  }
}

test interval_ends_after_deadline() {
  and {
    after(4) |> ends_after(5),
    after(5) |> ends_after(5),
    after(6) |> ends_after(5),
    entirely_after(3) |> ends_after(5),
    entirely_after(4) |> ends_after(5),
    entirely_after(5) |> ends_after(5),
    before(4) |> ends_after(5) |> not,
    before(5) |> ends_after(5) |> not,
    before(6) |> ends_after(5),
    entirely_before(5) |> ends_after(5) |> not,
    entirely_before(6) |> ends_after(5) |> not,
    entirely_before(7) |> ends_after(5),
    between(1, 4) |> ends_after(5) |> not,
    between(2, 5) |> ends_after(5) |> not,
    between(3, 6) |> ends_after(5),
    between(4, 7) |> ends_after(5),
    between(5, 8) |> ends_after(5),
    between(6, 9) |> ends_after(5),
    entirely_between(2, 5) |> ends_after(5) |> not,
    entirely_between(3, 6) |> ends_after(5) |> not,
    entirely_between(4, 7) |> ends_after(5),
    entirely_between(5, 8) |> ends_after(5),
  }
}

test interval_ends_after_or_at_deadline() {
  and {
    after(4) |> ends_after_or_at(5),
    after(5) |> ends_after_or_at(5),
    after(6) |> ends_after_or_at(5),
    entirely_after(3) |> ends_after_or_at(5),
    entirely_after(4) |> ends_after_or_at(5),
    entirely_after(5) |> ends_after_or_at(5),
    before(4) |> ends_after_or_at(5) |> not,
    before(5) |> ends_after_or_at(5),
    before(6) |> ends_after_or_at(5),
    entirely_before(5) |> ends_after_or_at(5) |> not,
    entirely_before(6) |> ends_after_or_at(5),
    entirely_before(7) |> ends_after_or_at(5),
    between(1, 4) |> ends_after_or_at(5) |> not,
    between(2, 5) |> ends_after_or_at(5),
    between(3, 6) |> ends_after_or_at(5),
    between(4, 7) |> ends_after_or_at(5),
    between(5, 8) |> ends_after_or_at(5),
    between(6, 9) |> ends_after_or_at(5),
    entirely_between(2, 5) |> ends_after_or_at(5) |> not,
    entirely_between(3, 6) |> ends_after_or_at(5),
    entirely_between(4, 7) |> ends_after_or_at(5),
    entirely_between(5, 8) |> ends_after_or_at(5),
  }
}

test interval_ends_before_deadline() {
  and {
    after(4) |> ends_before(5) |> not,
    after(5) |> ends_before(5) |> not,
    after(6) |> ends_before(5) |> not,
    entirely_after(3) |> ends_before(5) |> not,
    entirely_after(4) |> ends_before(5) |> not,
    entirely_after(5) |> ends_before(5) |> not,
    before(4) |> ends_before(5),
    before(5) |> ends_before(5) |> not,
    before(6) |> ends_before(5) |> not,
    entirely_before(5) |> ends_before(5),
    entirely_before(6) |> ends_before(5) |> not,
    entirely_before(7) |> ends_before(5) |> not,
    between(1, 4) |> ends_before(5),
    between(2, 5) |> ends_before(5) |> not,
    between(3, 6) |> ends_before(5) |> not,
    between(4, 7) |> ends_before(5) |> not,
    between(5, 8) |> ends_before(5) |> not,
    between(6, 9) |> ends_before(5) |> not,
    entirely_between(2, 5) |> ends_before(5),
    entirely_between(3, 6) |> ends_before(5) |> not,
    entirely_between(4, 7) |> ends_before(5) |> not,
    entirely_between(5, 8) |> ends_before(5) |> not,
  }
}

test interval_ends_before_or_at_deadline() {
  and {
    after(4) |> ends_before_or_at(5) |> not,
    after(5) |> ends_before_or_at(5) |> not,
    after(6) |> ends_before_or_at(5) |> not,
    entirely_after(3) |> ends_before_or_at(5) |> not,
    entirely_after(4) |> ends_before_or_at(5) |> not,
    entirely_after(5) |> ends_before_or_at(5) |> not,
    before(4) |> ends_before_or_at(5),
    before(5) |> ends_before_or_at(5),
    before(6) |> ends_before_or_at(5) |> not,
    entirely_before(5) |> ends_before_or_at(5),
    entirely_before(6) |> ends_before_or_at(5),
    entirely_before(7) |> ends_before_or_at(5) |> not,
    between(1, 4) |> ends_before_or_at(5),
    between(2, 5) |> ends_before_or_at(5),
    between(3, 6) |> ends_before_or_at(5) |> not,
    between(4, 7) |> ends_before_or_at(5) |> not,
    between(5, 8) |> ends_before_or_at(5) |> not,
    between(6, 9) |> ends_before_or_at(5) |> not,
    entirely_between(2, 5) |> ends_before_or_at(5),
    entirely_between(3, 6) |> ends_before_or_at(5),
    entirely_between(4, 7) |> ends_before_or_at(5) |> not,
    entirely_between(5, 8) |> ends_before_or_at(5) |> not,
  }
}
