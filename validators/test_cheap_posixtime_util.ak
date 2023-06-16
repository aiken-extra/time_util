//// ```
//// ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 1209662, cpu:  463148119] interval_is_after_deadline
//// │ PASS [mem: 1204858, cpu:  461657735] interval_is_after_or_at_deadline
//// │ PASS [mem: 1209662, cpu:  463148119] interval_is_before_deadline
//// │ PASS [mem: 1204858, cpu:  461657735] interval_is_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed
//// ```

use aiken/interval.{
  after, before, between, strictly_after, strictly_before, strictly_between,
}
use aiken/list
use time_util/cheap/posixtime.{
  is_after, is_after_or_at, is_before, is_before_or_at,
}

test interval_is_after_deadline() {
  [
    after(4) |> is_after(5) |> not,
    after(5) |> is_after(5) |> not,
    after(6) |> is_after(5),
    strictly_after(3) |> is_after(5) |> not,
    strictly_after(4) |> is_after(5) |> not,
    strictly_after(5) |> is_after(5),
    before(4) |> is_after(5) |> not,
    before(5) |> is_after(5) |> not,
    before(6) |> is_after(5) |> not,
    strictly_before(5) |> is_after(5) |> not,
    strictly_before(6) |> is_after(5) |> not,
    strictly_before(7) |> is_after(5) |> not,
    between(1, 4) |> is_after(5) |> not,
    between(2, 5) |> is_after(5) |> not,
    between(3, 6) |> is_after(5) |> not,
    between(4, 7) |> is_after(5) |> not,
    between(5, 8) |> is_after(5) |> not,
    between(6, 9) |> is_after(5),
    strictly_between(2, 5) |> is_after(5) |> not,
    strictly_between(3, 6) |> is_after(5) |> not,
    strictly_between(4, 7) |> is_after(5) |> not,
    strictly_between(5, 8) |> is_after(5),
  ]
    |> list.and
}

test interval_is_after_or_at_deadline() {
  [
    after(4) |> is_after_or_at(5) |> not,
    after(5) |> is_after_or_at(5),
    after(6) |> is_after_or_at(5),
    strictly_after(3) |> is_after_or_at(5) |> not,
    strictly_after(4) |> is_after_or_at(5),
    strictly_after(5) |> is_after_or_at(5),
    before(4) |> is_after_or_at(5) |> not,
    before(5) |> is_after_or_at(5) |> not,
    before(6) |> is_after_or_at(5) |> not,
    strictly_before(5) |> is_after_or_at(5) |> not,
    strictly_before(6) |> is_after_or_at(5) |> not,
    strictly_before(7) |> is_after_or_at(5) |> not,
    between(1, 4) |> is_after_or_at(5) |> not,
    between(2, 5) |> is_after_or_at(5) |> not,
    between(3, 6) |> is_after_or_at(5) |> not,
    between(4, 7) |> is_after_or_at(5) |> not,
    between(5, 8) |> is_after_or_at(5),
    between(6, 9) |> is_after_or_at(5),
    strictly_between(2, 5) |> is_after_or_at(5) |> not,
    strictly_between(3, 6) |> is_after_or_at(5) |> not,
    strictly_between(4, 7) |> is_after_or_at(5),
    strictly_between(5, 8) |> is_after_or_at(5),
  ]
    |> list.and
}

test interval_is_before_deadline() {
  [
    after(4) |> is_before(5) |> not,
    after(5) |> is_before(5) |> not,
    after(6) |> is_before(5) |> not,
    strictly_after(3) |> is_before(5) |> not,
    strictly_after(4) |> is_before(5) |> not,
    strictly_after(5) |> is_before(5) |> not,
    before(4) |> is_before(5),
    before(5) |> is_before(5) |> not,
    before(6) |> is_before(5) |> not,
    strictly_before(5) |> is_before(5),
    strictly_before(6) |> is_before(5) |> not,
    strictly_before(7) |> is_before(5) |> not,
    between(1, 4) |> is_before(5),
    between(2, 5) |> is_before(5) |> not,
    between(3, 6) |> is_before(5) |> not,
    between(4, 7) |> is_before(5) |> not,
    between(5, 8) |> is_before(5) |> not,
    between(6, 9) |> is_before(5) |> not,
    strictly_between(2, 5) |> is_before(5),
    strictly_between(3, 6) |> is_before(5) |> not,
    strictly_between(4, 7) |> is_before(5) |> not,
    strictly_between(5, 8) |> is_before(5) |> not,
  ]
    |> list.and
}

test interval_is_before_or_at_deadline() {
  [
    after(4) |> is_before_or_at(5) |> not,
    after(5) |> is_before_or_at(5) |> not,
    after(6) |> is_before_or_at(5) |> not,
    strictly_after(3) |> is_before_or_at(5) |> not,
    strictly_after(4) |> is_before_or_at(5) |> not,
    strictly_after(5) |> is_before_or_at(5) |> not,
    before(4) |> is_before_or_at(5),
    before(5) |> is_before_or_at(5),
    before(6) |> is_before_or_at(5) |> not,
    strictly_before(5) |> is_before_or_at(5),
    strictly_before(6) |> is_before_or_at(5),
    strictly_before(7) |> is_before_or_at(5) |> not,
    between(1, 4) |> is_before_or_at(5),
    between(2, 5) |> is_before_or_at(5),
    between(3, 6) |> is_before_or_at(5) |> not,
    between(4, 7) |> is_before_or_at(5) |> not,
    between(5, 8) |> is_before_or_at(5) |> not,
    between(6, 9) |> is_before_or_at(5) |> not,
    strictly_between(2, 5) |> is_before_or_at(5),
    strictly_between(3, 6) |> is_before_or_at(5),
    strictly_between(4, 7) |> is_before_or_at(5) |> not,
    strictly_between(5, 8) |> is_before_or_at(5) |> not,
  ]
    |> list.and
}
