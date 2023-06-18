//// ```
//// ┍━ test_cheap_interval_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 2642516, cpu: 1030016700] interval_starts_after_deadline
//// │ PASS [mem: 2637712, cpu: 1028526316] interval_starts_after_or_at_deadline
//// │ PASS [mem: 2617306, cpu: 1023415140] interval_starts_before_deadline
//// │ PASS [mem: 2612502, cpu: 1021924756] interval_starts_before_or_at_deadline
//// │ PASS [mem: 2605510, cpu: 1018377414] interval_ends_after_deadline
//// │ PASS [mem: 2600706, cpu: 1016887030] interval_ends_after_or_at_deadline
//// │ PASS [mem: 2630720, cpu: 1024978974] interval_ends_before_deadline
//// │ PASS [mem: 2625916, cpu: 1023488590] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// ```

use aiken/interval.{
  after, before, between, strictly_after, strictly_before, strictly_between,
}
use aiken/list
use time_util/cheap/interval as time

test interval_starts_after_deadline() {
  let deadline = between(5, 5)
  let starts_after_deadline_interval =
    time.starts_after(_, deadline)
  [
    after(4) |> starts_after_deadline_interval() |> not,
    after(5) |> starts_after_deadline_interval() |> not,
    after(6) |> starts_after_deadline_interval(),
    strictly_after(3) |> starts_after_deadline_interval() |> not,
    strictly_after(4) |> starts_after_deadline_interval() |> not,
    strictly_after(5) |> starts_after_deadline_interval(),
    before(4) |> starts_after_deadline_interval() |> not,
    before(5) |> starts_after_deadline_interval() |> not,
    before(6) |> starts_after_deadline_interval() |> not,
    strictly_before(5) |> starts_after_deadline_interval() |> not,
    strictly_before(6) |> starts_after_deadline_interval() |> not,
    strictly_before(7) |> starts_after_deadline_interval() |> not,
    between(1, 4) |> starts_after_deadline_interval() |> not,
    between(2, 5) |> starts_after_deadline_interval() |> not,
    between(3, 6) |> starts_after_deadline_interval() |> not,
    between(4, 7) |> starts_after_deadline_interval() |> not,
    between(5, 8) |> starts_after_deadline_interval() |> not,
    between(6, 9) |> starts_after_deadline_interval(),
    strictly_between(2, 5) |> starts_after_deadline_interval() |> not,
    strictly_between(3, 6) |> starts_after_deadline_interval() |> not,
    strictly_between(4, 7) |> starts_after_deadline_interval() |> not,
    strictly_between(5, 8) |> starts_after_deadline_interval(),
  ]
    |> list.and
}

test interval_starts_after_or_at_deadline() {
  let deadline = between(5, 5)
  let starts_after_or_at_deadline_interval =
    time.starts_after_or_at(_, deadline)
  [
    after(4) |> starts_after_or_at_deadline_interval() |> not,
    after(5) |> starts_after_or_at_deadline_interval(),
    after(6) |> starts_after_or_at_deadline_interval(),
    strictly_after(3) |> starts_after_or_at_deadline_interval() |> not,
    strictly_after(4) |> starts_after_or_at_deadline_interval(),
    strictly_after(5) |> starts_after_or_at_deadline_interval(),
    before(4) |> starts_after_or_at_deadline_interval() |> not,
    before(5) |> starts_after_or_at_deadline_interval() |> not,
    before(6) |> starts_after_or_at_deadline_interval() |> not,
    strictly_before(5) |> starts_after_or_at_deadline_interval() |> not,
    strictly_before(6) |> starts_after_or_at_deadline_interval() |> not,
    strictly_before(7) |> starts_after_or_at_deadline_interval() |> not,
    between(1, 4) |> starts_after_or_at_deadline_interval() |> not,
    between(2, 5) |> starts_after_or_at_deadline_interval() |> not,
    between(3, 6) |> starts_after_or_at_deadline_interval() |> not,
    between(4, 7) |> starts_after_or_at_deadline_interval() |> not,
    between(5, 8) |> starts_after_or_at_deadline_interval(),
    between(6, 9) |> starts_after_or_at_deadline_interval(),
    strictly_between(2, 5) |> starts_after_or_at_deadline_interval() |> not,
    strictly_between(3, 6) |> starts_after_or_at_deadline_interval() |> not,
    strictly_between(4, 7) |> starts_after_or_at_deadline_interval(),
    strictly_between(5, 8) |> starts_after_or_at_deadline_interval(),
  ]
    |> list.and
}

test interval_starts_before_deadline() {
  let deadline = between(5, 5)
  let starts_before_deadline_interval =
    time.starts_before(_, deadline)
  [
    after(4) |> starts_before_deadline_interval(),
    after(5) |> starts_before_deadline_interval() |> not,
    after(6) |> starts_before_deadline_interval() |> not,
    strictly_after(3) |> starts_before_deadline_interval(),
    strictly_after(4) |> starts_before_deadline_interval() |> not,
    strictly_after(5) |> starts_before_deadline_interval() |> not,
    before(4) |> starts_before_deadline_interval(),
    before(5) |> starts_before_deadline_interval(),
    before(6) |> starts_before_deadline_interval(),
    strictly_before(5) |> starts_before_deadline_interval(),
    strictly_before(6) |> starts_before_deadline_interval(),
    strictly_before(7) |> starts_before_deadline_interval(),
    between(1, 4) |> starts_before_deadline_interval(),
    between(2, 5) |> starts_before_deadline_interval(),
    between(3, 6) |> starts_before_deadline_interval(),
    between(4, 7) |> starts_before_deadline_interval(),
    between(5, 8) |> starts_before_deadline_interval() |> not,
    between(6, 9) |> starts_before_deadline_interval() |> not,
    strictly_between(2, 5) |> starts_before_deadline_interval(),
    strictly_between(3, 6) |> starts_before_deadline_interval(),
    strictly_between(4, 7) |> starts_before_deadline_interval() |> not,
    strictly_between(5, 8) |> starts_before_deadline_interval() |> not,
  ]
    |> list.and
}

test interval_starts_before_or_at_deadline() {
  let deadline = between(5, 5)
  let starts_before_or_at_deadline_interval =
    time.starts_before_or_at(_, deadline)
  [
    after(4) |> starts_before_or_at_deadline_interval(),
    after(5) |> starts_before_or_at_deadline_interval(),
    after(6) |> starts_before_or_at_deadline_interval() |> not,
    strictly_after(3) |> starts_before_or_at_deadline_interval(),
    strictly_after(4) |> starts_before_or_at_deadline_interval(),
    strictly_after(5) |> starts_before_or_at_deadline_interval() |> not,
    before(4) |> starts_before_or_at_deadline_interval(),
    before(5) |> starts_before_or_at_deadline_interval(),
    before(6) |> starts_before_or_at_deadline_interval(),
    strictly_before(5) |> starts_before_or_at_deadline_interval(),
    strictly_before(6) |> starts_before_or_at_deadline_interval(),
    strictly_before(7) |> starts_before_or_at_deadline_interval(),
    between(1, 4) |> starts_before_or_at_deadline_interval(),
    between(2, 5) |> starts_before_or_at_deadline_interval(),
    between(3, 6) |> starts_before_or_at_deadline_interval(),
    between(4, 7) |> starts_before_or_at_deadline_interval(),
    between(5, 8) |> starts_before_or_at_deadline_interval(),
    between(6, 9) |> starts_before_or_at_deadline_interval() |> not,
    strictly_between(2, 5) |> starts_before_or_at_deadline_interval(),
    strictly_between(3, 6) |> starts_before_or_at_deadline_interval(),
    strictly_between(4, 7) |> starts_before_or_at_deadline_interval(),
    strictly_between(5, 8) |> starts_before_or_at_deadline_interval() |> not,
  ]
    |> list.and
}

test interval_ends_after_deadline() {
  let deadline = between(5, 5)
  let ends_after_deadline_interval =
    time.ends_after(_, deadline)
  [
    after(4) |> ends_after_deadline_interval(),
    after(5) |> ends_after_deadline_interval(),
    after(6) |> ends_after_deadline_interval(),
    strictly_after(3) |> ends_after_deadline_interval(),
    strictly_after(4) |> ends_after_deadline_interval(),
    strictly_after(5) |> ends_after_deadline_interval(),
    before(4) |> ends_after_deadline_interval() |> not,
    before(5) |> ends_after_deadline_interval() |> not,
    before(6) |> ends_after_deadline_interval(),
    strictly_before(5) |> ends_after_deadline_interval() |> not,
    strictly_before(6) |> ends_after_deadline_interval() |> not,
    strictly_before(7) |> ends_after_deadline_interval(),
    between(1, 4) |> ends_after_deadline_interval() |> not,
    between(2, 5) |> ends_after_deadline_interval() |> not,
    between(3, 6) |> ends_after_deadline_interval(),
    between(4, 7) |> ends_after_deadline_interval(),
    between(5, 8) |> ends_after_deadline_interval(),
    between(6, 9) |> ends_after_deadline_interval(),
    strictly_between(2, 5) |> ends_after_deadline_interval() |> not,
    strictly_between(3, 6) |> ends_after_deadline_interval() |> not,
    strictly_between(4, 7) |> ends_after_deadline_interval(),
    strictly_between(5, 8) |> ends_after_deadline_interval(),
  ]
    |> list.and
}

test interval_ends_after_or_at_deadline() {
  let deadline = between(5, 5)
  let ends_after_or_at_deadline_interval =
    time.ends_after_or_at(_, deadline)
  [
    after(4) |> ends_after_or_at_deadline_interval(),
    after(5) |> ends_after_or_at_deadline_interval(),
    after(6) |> ends_after_or_at_deadline_interval(),
    strictly_after(3) |> ends_after_or_at_deadline_interval(),
    strictly_after(4) |> ends_after_or_at_deadline_interval(),
    strictly_after(5) |> ends_after_or_at_deadline_interval(),
    before(4) |> ends_after_or_at_deadline_interval() |> not,
    before(5) |> ends_after_or_at_deadline_interval(),
    before(6) |> ends_after_or_at_deadline_interval(),
    strictly_before(5) |> ends_after_or_at_deadline_interval() |> not,
    strictly_before(6) |> ends_after_or_at_deadline_interval(),
    strictly_before(7) |> ends_after_or_at_deadline_interval(),
    between(1, 4) |> ends_after_or_at_deadline_interval() |> not,
    between(2, 5) |> ends_after_or_at_deadline_interval(),
    between(3, 6) |> ends_after_or_at_deadline_interval(),
    between(4, 7) |> ends_after_or_at_deadline_interval(),
    between(5, 8) |> ends_after_or_at_deadline_interval(),
    between(6, 9) |> ends_after_or_at_deadline_interval(),
    strictly_between(2, 5) |> ends_after_or_at_deadline_interval() |> not,
    strictly_between(3, 6) |> ends_after_or_at_deadline_interval(),
    strictly_between(4, 7) |> ends_after_or_at_deadline_interval(),
    strictly_between(5, 8) |> ends_after_or_at_deadline_interval(),
  ]
    |> list.and
}

test interval_ends_before_deadline() {
  let deadline = between(5, 5)
  let ends_before_deadline_interval =
    time.ends_before(_, deadline)
  [
    after(4) |> ends_before_deadline_interval() |> not,
    after(5) |> ends_before_deadline_interval() |> not,
    after(6) |> ends_before_deadline_interval() |> not,
    strictly_after(3) |> ends_before_deadline_interval() |> not,
    strictly_after(4) |> ends_before_deadline_interval() |> not,
    strictly_after(5) |> ends_before_deadline_interval() |> not,
    before(4) |> ends_before_deadline_interval(),
    before(5) |> ends_before_deadline_interval() |> not,
    before(6) |> ends_before_deadline_interval() |> not,
    strictly_before(5) |> ends_before_deadline_interval(),
    strictly_before(6) |> ends_before_deadline_interval() |> not,
    strictly_before(7) |> ends_before_deadline_interval() |> not,
    between(1, 4) |> ends_before_deadline_interval(),
    between(2, 5) |> ends_before_deadline_interval() |> not,
    between(3, 6) |> ends_before_deadline_interval() |> not,
    between(4, 7) |> ends_before_deadline_interval() |> not,
    between(5, 8) |> ends_before_deadline_interval() |> not,
    between(6, 9) |> ends_before_deadline_interval() |> not,
    strictly_between(2, 5) |> ends_before_deadline_interval(),
    strictly_between(3, 6) |> ends_before_deadline_interval() |> not,
    strictly_between(4, 7) |> ends_before_deadline_interval() |> not,
    strictly_between(5, 8) |> ends_before_deadline_interval() |> not,
  ]
    |> list.and
}

test interval_ends_before_or_at_deadline() {
  let deadline = between(5, 5)
  let ends_before_or_at_deadline_interval =
    time.ends_before_or_at(_, deadline)
  [
    after(4) |> ends_before_or_at_deadline_interval() |> not,
    after(5) |> ends_before_or_at_deadline_interval() |> not,
    after(6) |> ends_before_or_at_deadline_interval() |> not,
    strictly_after(3) |> ends_before_or_at_deadline_interval() |> not,
    strictly_after(4) |> ends_before_or_at_deadline_interval() |> not,
    strictly_after(5) |> ends_before_or_at_deadline_interval() |> not,
    before(4) |> ends_before_or_at_deadline_interval(),
    before(5) |> ends_before_or_at_deadline_interval(),
    before(6) |> ends_before_or_at_deadline_interval() |> not,
    strictly_before(5) |> ends_before_or_at_deadline_interval(),
    strictly_before(6) |> ends_before_or_at_deadline_interval(),
    strictly_before(7) |> ends_before_or_at_deadline_interval() |> not,
    between(1, 4) |> ends_before_or_at_deadline_interval(),
    between(2, 5) |> ends_before_or_at_deadline_interval(),
    between(3, 6) |> ends_before_or_at_deadline_interval() |> not,
    between(4, 7) |> ends_before_or_at_deadline_interval() |> not,
    between(5, 8) |> ends_before_or_at_deadline_interval() |> not,
    between(6, 9) |> ends_before_or_at_deadline_interval() |> not,
    strictly_between(2, 5) |> ends_before_or_at_deadline_interval(),
    strictly_between(3, 6) |> ends_before_or_at_deadline_interval(),
    strictly_between(4, 7) |> ends_before_or_at_deadline_interval() |> not,
    strictly_between(5, 8) |> ends_before_or_at_deadline_interval() |> not,
  ]
    |> list.and
}
