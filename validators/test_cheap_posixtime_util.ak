//// ```
//// ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem:  703457, cpu: 215395887] interval_starts_after_deadline
//// │ PASS [mem:  699853, cpu: 214492443] interval_starts_after_or_at_deadline
//// │ PASS [mem:  694447, cpu: 213195397] interval_starts_before_deadline
//// │ PASS [mem:  690843, cpu: 212291953] interval_starts_before_or_at_deadline
//// │ PASS [mem:  694447, cpu: 213195397] interval_ends_after_deadline
//// │ PASS [mem:  690843, cpu: 212291953] interval_ends_after_or_at_deadline
//// │ PASS [mem:  703457, cpu: 215395887] interval_ends_before_deadline
//// │ PASS [mem:  699853, cpu: 214492443] interval_ends_before_or_at_deadline
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
