//// ```
//// ┍━ test_cheap_interval_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 2642516, cpu: 1030016700] interval_is_after_deadline
//// │ PASS [mem: 2637712, cpu: 1028526316] interval_is_after_or_at_deadline
//// │ PASS [mem: 2630720, cpu: 1024978974] interval_is_before_deadline
//// │ PASS [mem: 2625916, cpu: 1023488590] interval_is_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed
//// ```

use aiken/interval.{
  after, before, between, strictly_after, strictly_before, strictly_between,
}
use aiken/list
use time_util/cheap/interval as time

test interval_is_after_deadline() {
  let deadline = between(5, 5)
  let is_after_deadline_interval =
    time.is_after(_, deadline)
  [
    after(4) |> is_after_deadline_interval() |> not,
    after(5) |> is_after_deadline_interval() |> not,
    after(6) |> is_after_deadline_interval(),
    strictly_after(3) |> is_after_deadline_interval() |> not,
    strictly_after(4) |> is_after_deadline_interval() |> not,
    strictly_after(5) |> is_after_deadline_interval(),
    before(4) |> is_after_deadline_interval() |> not,
    before(5) |> is_after_deadline_interval() |> not,
    before(6) |> is_after_deadline_interval() |> not,
    strictly_before(5) |> is_after_deadline_interval() |> not,
    strictly_before(6) |> is_after_deadline_interval() |> not,
    strictly_before(7) |> is_after_deadline_interval() |> not,
    between(1, 4) |> is_after_deadline_interval() |> not,
    between(2, 5) |> is_after_deadline_interval() |> not,
    between(3, 6) |> is_after_deadline_interval() |> not,
    between(4, 7) |> is_after_deadline_interval() |> not,
    between(5, 8) |> is_after_deadline_interval() |> not,
    between(6, 9) |> is_after_deadline_interval(),
    strictly_between(2, 5) |> is_after_deadline_interval() |> not,
    strictly_between(3, 6) |> is_after_deadline_interval() |> not,
    strictly_between(4, 7) |> is_after_deadline_interval() |> not,
    strictly_between(5, 8) |> is_after_deadline_interval(),
  ]
    |> list.and
}

test interval_is_after_or_at_deadline() {
  let deadline = between(5, 5)
  let is_after_or_at_deadline_interval =
    time.is_after_or_at(_, deadline)
  [
    after(4) |> is_after_or_at_deadline_interval() |> not,
    after(5) |> is_after_or_at_deadline_interval(),
    after(6) |> is_after_or_at_deadline_interval(),
    strictly_after(3) |> is_after_or_at_deadline_interval() |> not,
    strictly_after(4) |> is_after_or_at_deadline_interval(),
    strictly_after(5) |> is_after_or_at_deadline_interval(),
    before(4) |> is_after_or_at_deadline_interval() |> not,
    before(5) |> is_after_or_at_deadline_interval() |> not,
    before(6) |> is_after_or_at_deadline_interval() |> not,
    strictly_before(5) |> is_after_or_at_deadline_interval() |> not,
    strictly_before(6) |> is_after_or_at_deadline_interval() |> not,
    strictly_before(7) |> is_after_or_at_deadline_interval() |> not,
    between(1, 4) |> is_after_or_at_deadline_interval() |> not,
    between(2, 5) |> is_after_or_at_deadline_interval() |> not,
    between(3, 6) |> is_after_or_at_deadline_interval() |> not,
    between(4, 7) |> is_after_or_at_deadline_interval() |> not,
    between(5, 8) |> is_after_or_at_deadline_interval(),
    between(6, 9) |> is_after_or_at_deadline_interval(),
    strictly_between(2, 5) |> is_after_or_at_deadline_interval() |> not,
    strictly_between(3, 6) |> is_after_or_at_deadline_interval() |> not,
    strictly_between(4, 7) |> is_after_or_at_deadline_interval(),
    strictly_between(5, 8) |> is_after_or_at_deadline_interval(),
  ]
    |> list.and
}

test interval_is_before_deadline() {
  let deadline = between(5, 5)
  let is_before_deadline_interval =
    time.is_before(_, deadline)
  [
    after(4) |> is_before_deadline_interval() |> not,
    after(5) |> is_before_deadline_interval() |> not,
    after(6) |> is_before_deadline_interval() |> not,
    strictly_after(3) |> is_before_deadline_interval() |> not,
    strictly_after(4) |> is_before_deadline_interval() |> not,
    strictly_after(5) |> is_before_deadline_interval() |> not,
    before(4) |> is_before_deadline_interval(),
    before(5) |> is_before_deadline_interval() |> not,
    before(6) |> is_before_deadline_interval() |> not,
    strictly_before(5) |> is_before_deadline_interval(),
    strictly_before(6) |> is_before_deadline_interval() |> not,
    strictly_before(7) |> is_before_deadline_interval() |> not,
    between(1, 4) |> is_before_deadline_interval(),
    between(2, 5) |> is_before_deadline_interval() |> not,
    between(3, 6) |> is_before_deadline_interval() |> not,
    between(4, 7) |> is_before_deadline_interval() |> not,
    between(5, 8) |> is_before_deadline_interval() |> not,
    between(6, 9) |> is_before_deadline_interval() |> not,
    strictly_between(2, 5) |> is_before_deadline_interval(),
    strictly_between(3, 6) |> is_before_deadline_interval() |> not,
    strictly_between(4, 7) |> is_before_deadline_interval() |> not,
    strictly_between(5, 8) |> is_before_deadline_interval() |> not,
  ]
    |> list.and
}

test interval_is_before_or_at_deadline() {
  let deadline = between(5, 5)
  let is_before_or_at_deadline_interval =
    time.is_before_or_at(_, deadline)
  [
    after(4) |> is_before_or_at_deadline_interval() |> not,
    after(5) |> is_before_or_at_deadline_interval() |> not,
    after(6) |> is_before_or_at_deadline_interval() |> not,
    strictly_after(3) |> is_before_or_at_deadline_interval() |> not,
    strictly_after(4) |> is_before_or_at_deadline_interval() |> not,
    strictly_after(5) |> is_before_or_at_deadline_interval() |> not,
    before(4) |> is_before_or_at_deadline_interval(),
    before(5) |> is_before_or_at_deadline_interval(),
    before(6) |> is_before_or_at_deadline_interval() |> not,
    strictly_before(5) |> is_before_or_at_deadline_interval(),
    strictly_before(6) |> is_before_or_at_deadline_interval(),
    strictly_before(7) |> is_before_or_at_deadline_interval() |> not,
    between(1, 4) |> is_before_or_at_deadline_interval(),
    between(2, 5) |> is_before_or_at_deadline_interval(),
    between(3, 6) |> is_before_or_at_deadline_interval() |> not,
    between(4, 7) |> is_before_or_at_deadline_interval() |> not,
    between(5, 8) |> is_before_or_at_deadline_interval() |> not,
    between(6, 9) |> is_before_or_at_deadline_interval() |> not,
    strictly_between(2, 5) |> is_before_or_at_deadline_interval(),
    strictly_between(3, 6) |> is_before_or_at_deadline_interval(),
    strictly_between(4, 7) |> is_before_or_at_deadline_interval() |> not,
    strictly_between(5, 8) |> is_before_or_at_deadline_interval() |> not,
  ]
    |> list.and
}
