//// ```
//// ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//// │ PASS [mem: 1209662, cpu:  463148119] interval_starts_after_deadline
//// │ PASS [mem: 1204858, cpu:  461657735] interval_starts_after_or_at_deadline
//// │ PASS [mem: 1197652, cpu:  459582559] interval_starts_before_deadline
//// │ PASS [mem: 1192848, cpu:  458092175] interval_starts_before_or_at_deadline
//// │ PASS [mem: 1197652, cpu:  459582559] interval_ends_after_deadline
//// │ PASS [mem: 1192848, cpu:  458092175] interval_ends_after_or_at_deadline
//// │ PASS [mem: 1209662, cpu:  463148119] interval_ends_before_deadline
//// │ PASS [mem: 1204858, cpu:  461657735] interval_ends_before_or_at_deadline
//// ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 8 tests | 8 passed | 0 failed
//// ```

use aiken/interval.{
  after, before, between, strictly_after, strictly_before, strictly_between,
}
use aiken/list
use time_util/cheap/posixtime.{
  ends_after, ends_after_or_at, ends_before, ends_before_or_at, starts_after,
  starts_after_or_at, starts_before, starts_before_or_at,
}

test interval_starts_after_deadline() {
  [
    after(4) |> starts_after(5) |> not,
    after(5) |> starts_after(5) |> not,
    after(6) |> starts_after(5),
    strictly_after(3) |> starts_after(5) |> not,
    strictly_after(4) |> starts_after(5) |> not,
    strictly_after(5) |> starts_after(5),
    before(4) |> starts_after(5) |> not,
    before(5) |> starts_after(5) |> not,
    before(6) |> starts_after(5) |> not,
    strictly_before(5) |> starts_after(5) |> not,
    strictly_before(6) |> starts_after(5) |> not,
    strictly_before(7) |> starts_after(5) |> not,
    between(1, 4) |> starts_after(5) |> not,
    between(2, 5) |> starts_after(5) |> not,
    between(3, 6) |> starts_after(5) |> not,
    between(4, 7) |> starts_after(5) |> not,
    between(5, 8) |> starts_after(5) |> not,
    between(6, 9) |> starts_after(5),
    strictly_between(2, 5) |> starts_after(5) |> not,
    strictly_between(3, 6) |> starts_after(5) |> not,
    strictly_between(4, 7) |> starts_after(5) |> not,
    strictly_between(5, 8) |> starts_after(5),
  ]
    |> list.and
}

test interval_starts_after_or_at_deadline() {
  [
    after(4) |> starts_after_or_at(5) |> not,
    after(5) |> starts_after_or_at(5),
    after(6) |> starts_after_or_at(5),
    strictly_after(3) |> starts_after_or_at(5) |> not,
    strictly_after(4) |> starts_after_or_at(5),
    strictly_after(5) |> starts_after_or_at(5),
    before(4) |> starts_after_or_at(5) |> not,
    before(5) |> starts_after_or_at(5) |> not,
    before(6) |> starts_after_or_at(5) |> not,
    strictly_before(5) |> starts_after_or_at(5) |> not,
    strictly_before(6) |> starts_after_or_at(5) |> not,
    strictly_before(7) |> starts_after_or_at(5) |> not,
    between(1, 4) |> starts_after_or_at(5) |> not,
    between(2, 5) |> starts_after_or_at(5) |> not,
    between(3, 6) |> starts_after_or_at(5) |> not,
    between(4, 7) |> starts_after_or_at(5) |> not,
    between(5, 8) |> starts_after_or_at(5),
    between(6, 9) |> starts_after_or_at(5),
    strictly_between(2, 5) |> starts_after_or_at(5) |> not,
    strictly_between(3, 6) |> starts_after_or_at(5) |> not,
    strictly_between(4, 7) |> starts_after_or_at(5),
    strictly_between(5, 8) |> starts_after_or_at(5),
  ]
    |> list.and
}

test interval_starts_before_deadline() {
  [
    after(4) |> starts_before(5),
    after(5) |> starts_before(5) |> not,
    after(6) |> starts_before(5) |> not,
    strictly_after(3) |> starts_before(5),
    strictly_after(4) |> starts_before(5) |> not,
    strictly_after(5) |> starts_before(5) |> not,
    before(4) |> starts_before(5),
    before(5) |> starts_before(5),
    before(6) |> starts_before(5),
    strictly_before(5) |> starts_before(5),
    strictly_before(6) |> starts_before(5),
    strictly_before(7) |> starts_before(5),
    between(1, 4) |> starts_before(5),
    between(2, 5) |> starts_before(5),
    between(3, 6) |> starts_before(5),
    between(4, 7) |> starts_before(5),
    between(5, 8) |> starts_before(5) |> not,
    between(6, 9) |> starts_before(5) |> not,
    strictly_between(2, 5) |> starts_before(5),
    strictly_between(3, 6) |> starts_before(5),
    strictly_between(4, 7) |> starts_before(5) |> not,
    strictly_between(5, 8) |> starts_before(5) |> not,
  ]
    |> list.and
}

test interval_starts_before_or_at_deadline() {
  [
    after(4) |> starts_before_or_at(5),
    after(5) |> starts_before_or_at(5),
    after(6) |> starts_before_or_at(5) |> not,
    strictly_after(3) |> starts_before_or_at(5),
    strictly_after(4) |> starts_before_or_at(5),
    strictly_after(5) |> starts_before_or_at(5) |> not,
    before(4) |> starts_before_or_at(5),
    before(5) |> starts_before_or_at(5),
    before(6) |> starts_before_or_at(5),
    strictly_before(5) |> starts_before_or_at(5),
    strictly_before(6) |> starts_before_or_at(5),
    strictly_before(7) |> starts_before_or_at(5),
    between(1, 4) |> starts_before_or_at(5),
    between(2, 5) |> starts_before_or_at(5),
    between(3, 6) |> starts_before_or_at(5),
    between(4, 7) |> starts_before_or_at(5),
    between(5, 8) |> starts_before_or_at(5),
    between(6, 9) |> starts_before_or_at(5) |> not,
    strictly_between(2, 5) |> starts_before_or_at(5),
    strictly_between(3, 6) |> starts_before_or_at(5),
    strictly_between(4, 7) |> starts_before_or_at(5),
    strictly_between(5, 8) |> starts_before_or_at(5) |> not,
  ]
    |> list.and
}

test interval_ends_after_deadline() {
  [
    after(4) |> ends_after(5),
    after(5) |> ends_after(5),
    after(6) |> ends_after(5),
    strictly_after(3) |> ends_after(5),
    strictly_after(4) |> ends_after(5),
    strictly_after(5) |> ends_after(5),
    before(4) |> ends_after(5) |> not,
    before(5) |> ends_after(5) |> not,
    before(6) |> ends_after(5),
    strictly_before(5) |> ends_after(5) |> not,
    strictly_before(6) |> ends_after(5) |> not,
    strictly_before(7) |> ends_after(5),
    between(1, 4) |> ends_after(5) |> not,
    between(2, 5) |> ends_after(5) |> not,
    between(3, 6) |> ends_after(5),
    between(4, 7) |> ends_after(5),
    between(5, 8) |> ends_after(5),
    between(6, 9) |> ends_after(5),
    strictly_between(2, 5) |> ends_after(5) |> not,
    strictly_between(3, 6) |> ends_after(5) |> not,
    strictly_between(4, 7) |> ends_after(5),
    strictly_between(5, 8) |> ends_after(5),
  ]
    |> list.and
}

test interval_ends_after_or_at_deadline() {
  [
    after(4) |> ends_after_or_at(5),
    after(5) |> ends_after_or_at(5),
    after(6) |> ends_after_or_at(5),
    strictly_after(3) |> ends_after_or_at(5),
    strictly_after(4) |> ends_after_or_at(5),
    strictly_after(5) |> ends_after_or_at(5),
    before(4) |> ends_after_or_at(5) |> not,
    before(5) |> ends_after_or_at(5),
    before(6) |> ends_after_or_at(5),
    strictly_before(5) |> ends_after_or_at(5) |> not,
    strictly_before(6) |> ends_after_or_at(5),
    strictly_before(7) |> ends_after_or_at(5),
    between(1, 4) |> ends_after_or_at(5) |> not,
    between(2, 5) |> ends_after_or_at(5),
    between(3, 6) |> ends_after_or_at(5),
    between(4, 7) |> ends_after_or_at(5),
    between(5, 8) |> ends_after_or_at(5),
    between(6, 9) |> ends_after_or_at(5),
    strictly_between(2, 5) |> ends_after_or_at(5) |> not,
    strictly_between(3, 6) |> ends_after_or_at(5),
    strictly_between(4, 7) |> ends_after_or_at(5),
    strictly_between(5, 8) |> ends_after_or_at(5),
  ]
    |> list.and
}

test interval_ends_before_deadline() {
  [
    after(4) |> ends_before(5) |> not,
    after(5) |> ends_before(5) |> not,
    after(6) |> ends_before(5) |> not,
    strictly_after(3) |> ends_before(5) |> not,
    strictly_after(4) |> ends_before(5) |> not,
    strictly_after(5) |> ends_before(5) |> not,
    before(4) |> ends_before(5),
    before(5) |> ends_before(5) |> not,
    before(6) |> ends_before(5) |> not,
    strictly_before(5) |> ends_before(5),
    strictly_before(6) |> ends_before(5) |> not,
    strictly_before(7) |> ends_before(5) |> not,
    between(1, 4) |> ends_before(5),
    between(2, 5) |> ends_before(5) |> not,
    between(3, 6) |> ends_before(5) |> not,
    between(4, 7) |> ends_before(5) |> not,
    between(5, 8) |> ends_before(5) |> not,
    between(6, 9) |> ends_before(5) |> not,
    strictly_between(2, 5) |> ends_before(5),
    strictly_between(3, 6) |> ends_before(5) |> not,
    strictly_between(4, 7) |> ends_before(5) |> not,
    strictly_between(5, 8) |> ends_before(5) |> not,
  ]
    |> list.and
}

test interval_ends_before_or_at_deadline() {
  [
    after(4) |> ends_before_or_at(5) |> not,
    after(5) |> ends_before_or_at(5) |> not,
    after(6) |> ends_before_or_at(5) |> not,
    strictly_after(3) |> ends_before_or_at(5) |> not,
    strictly_after(4) |> ends_before_or_at(5) |> not,
    strictly_after(5) |> ends_before_or_at(5) |> not,
    before(4) |> ends_before_or_at(5),
    before(5) |> ends_before_or_at(5),
    before(6) |> ends_before_or_at(5) |> not,
    strictly_before(5) |> ends_before_or_at(5),
    strictly_before(6) |> ends_before_or_at(5),
    strictly_before(7) |> ends_before_or_at(5) |> not,
    between(1, 4) |> ends_before_or_at(5),
    between(2, 5) |> ends_before_or_at(5),
    between(3, 6) |> ends_before_or_at(5) |> not,
    between(4, 7) |> ends_before_or_at(5) |> not,
    between(5, 8) |> ends_before_or_at(5) |> not,
    between(6, 9) |> ends_before_or_at(5) |> not,
    strictly_between(2, 5) |> ends_before_or_at(5),
    strictly_between(3, 6) |> ends_before_or_at(5),
    strictly_between(4, 7) |> ends_before_or_at(5) |> not,
    strictly_between(5, 8) |> ends_before_or_at(5) |> not,
  ]
    |> list.and
}
