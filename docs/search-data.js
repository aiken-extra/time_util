window.Aiken.initSearch([{"doc":"time_util/cheap/interval","title":"end_of","content":"end_of(interval: Interval&lt;PosixTime&gt;) -&gt; IntervalBound&lt;PosixTime&gt;\n Returns the **max-bound** of `interval`\n ```\n end_of(after(5)).bound_type == PositiveInfinity\n end_of(before(5)).bound_type == Finite(5)\n end_of(between(5, 10)).bound_type == Finite(10)\n \n // also works with flipped `between` arguments\n end_of(between(10, 5)).bound_type == Finite(10)\n // as of Aiken v1.0.8-alpha\n ```","url":"time_util/cheap/interval.html#end_of"},{"doc":"time_util/cheap/interval","title":"is_after","content":"is_after(\n  some_interval: Interval&lt;PosixTime&gt;,\n  other_interval: Interval&lt;PosixTime&gt;,\n) -&gt; Bool\n Tells whether an interval is **after** another interval.\n ```\n let an_interval = between(0, 5)\n \n after(6) |&gt; is_after(an_interval) == True\n between(6, 9) |&gt; is_after(an_interval) == True\n strictly_after(5) |&gt; is_after(an_interval) == True\n strictly_between(5, 8) |&gt; is_after(an_interval) == True\n \n // negative cases:\n after(4) |&gt; is_after(an_interval) == False\n strictly_after(3) |&gt; is_after(an_interval) == False\n before(4) |&gt; is_after(an_interval) == False\n before(5) |&gt; is_after(an_interval) == False\n before(6) |&gt; is_after(an_interval) == False\n strictly_before(5) |&gt; is_after(an_interval) == False\n strictly_before(6) |&gt; is_after(an_interval) == False\n strictly_before(7) |&gt; is_after(an_interval) == False\n between(1, 4) |&gt; is_after(an_interval) == False\n between(2, 5) |&gt; is_after(an_interval) == False\n between(3, 6) |&gt; is_after(an_interval) == False\n between(4, 7) |&gt; is_after(an_interval) == False\n strictly_between(2, 5) |&gt; is_after(an_interval) == False\n strictly_between(3, 6) |&gt; is_after(an_interval) == False\n \n // interval starts AT deadline:\n after(5) |&gt; is_after(an_interval) == False\n between(5, 8) |&gt; is_after(an_interval) == False\n strictly_after(4) |&gt; is_after(an_interval) == False\n strictly_between(4, 7) |&gt; is_after(an_interval) == False\n ```","url":"time_util/cheap/interval.html#is_after"},{"doc":"time_util/cheap/interval","title":"is_after_or_at","content":"is_after_or_at(\n  some_interval: Interval&lt;PosixTime&gt;,\n  other_interval: Interval&lt;PosixTime&gt;,\n) -&gt; Bool\n Tells whether `some_interval` is **after-or-at** the specified `PosixTime`\n ```\n after(6) |&gt; is_after_or_at(5) == True\n strictly_after(5) |&gt; is_after_or_at(5) == True\n between(6, 9) |&gt; is_after_or_at(5) == True\n strictly_between(5, 8) |&gt; is_after_or_at(5) == True\n \n // interval starts AT deadline:\n after(5) |&gt; is_after_or_at(5) == True\n strictly_after(4) |&gt; is_after_or_at(5) == True\n between(5, 8) |&gt; is_after_or_at(5) == True\n strictly_between(4, 7) |&gt; is_after_or_at(5) == True\n \n // negative cases:\n after(4) |&gt; is_after_or_at(5) == False\n strictly_after(3) |&gt; is_after_or_at(5) == False\n before(4) |&gt; is_after_or_at(5) == False\n before(5) |&gt; is_after_or_at(5) == False\n before(6) |&gt; is_after_or_at(5) == False\n strictly_before(5) |&gt; is_after_or_at(5) == False\n strictly_before(6) |&gt; is_after_or_at(5) == False\n strictly_before(7) |&gt; is_after_or_at(5) == False\n between(1, 4) |&gt; is_after_or_at(5) == False\n between(2, 5) |&gt; is_after_or_at(5) == False\n between(3, 6) |&gt; is_after_or_at(5) == False\n between(4, 7) |&gt; is_after_or_at(5) == False\n strictly_between(2, 5) |&gt; is_after_or_at(5) == False\n strictly_between(3, 6) |&gt; is_after_or_at(5) == False\n ```","url":"time_util/cheap/interval.html#is_after_or_at"},{"doc":"time_util/cheap/interval","title":"is_before","content":"is_before(\n  some_interval: Interval&lt;PosixTime&gt;,\n  other_interval: Interval&lt;PosixTime&gt;,\n) -&gt; Bool\n Tells whether `some_interval` is **before** the specified `PosixTime`\n ```\n before(4) |&gt; is_before(5) == True\n strictly_before(5) |&gt; is_before(5) == True\n between(1, 4) |&gt; is_before(5) == True\n strictly_between(2, 5) |&gt; is_before(5) == True\n \n // negative cases:\n after(4) |&gt; is_before(5) == False\n after(5) |&gt; is_before(5) == False\n after(6) |&gt; is_before(5) == False\n strictly_after(3) |&gt; is_before(5) == False\n strictly_after(4) |&gt; is_before(5) == False\n strictly_after(5) |&gt; is_before(5) == False\n before(6) |&gt; is_before(5) == False\n strictly_before(7) |&gt; is_before(5) == False\n between(3, 6) |&gt; is_before(5) == False\n between(4, 7) |&gt; is_before(5) == False\n between(5, 8) |&gt; is_before(5) == False\n between(6, 9) |&gt; is_before(5) == False\n strictly_between(4, 7) |&gt; is_before(5) == False\n strictly_between(5, 8) |&gt; is_before(5) == False\n \n // interval ends AT deadline:\n before(5) |&gt; is_before(5) == False\n strictly_before(6) |&gt; is_before(5) == False\n between(2, 5) |&gt; is_before(5) == False\n strictly_between(3, 6) |&gt; is_before(5) == False\n ```","url":"time_util/cheap/interval.html#is_before"},{"doc":"time_util/cheap/interval","title":"is_before_or_at","content":"is_before_or_at(\n  some_interval: Interval&lt;PosixTime&gt;,\n  other_interval: Interval&lt;PosixTime&gt;,\n) -&gt; Bool\n Tells whether `some_interval` is **before-or-at** the specified `PosixTime`\n ```\n before(4) |&gt; is_before_or_at(5) == True\n strictly_before(5) |&gt; is_before_or_at(5) == True\n between(1, 4) |&gt; is_before_or_at(5) == True\n strictly_between(2, 5) |&gt; is_before_or_at(5) == True\n \n // interval ends AT deadline:\n before(5) |&gt; is_before_or_at(5) == True\n strictly_before(6) |&gt; is_before_or_at(5) == True\n between(2, 5) |&gt; is_before_or_at(5) == True\n strictly_between(3, 6) |&gt; is_before_or_at(5) == True\n \n // negative cases:\n after(4) |&gt; is_before_or_at(5) == False\n after(5) |&gt; is_before_or_at(5) == False\n after(6) |&gt; is_before_or_at(5) == False\n strictly_after(3) |&gt; is_before_or_at(5) == False\n strictly_after(4) |&gt; is_before_or_at(5) == False\n strictly_after(5) |&gt; is_before_or_at(5) == False\n before(6) |&gt; is_before_or_at(5) == False\n strictly_before(7) |&gt; is_before_or_at(5) == False\n between(3, 6) |&gt; is_before_or_at(5) == False\n between(4, 7) |&gt; is_before_or_at(5) == False\n between(5, 8) |&gt; is_before_or_at(5) == False\n between(6, 9) |&gt; is_before_or_at(5) == False\n strictly_between(4, 7) |&gt; is_before_or_at(5) == False\n strictly_between(5, 8) |&gt; is_before_or_at(5) == False\n ```","url":"time_util/cheap/interval.html#is_before_or_at"},{"doc":"time_util/cheap/interval","title":"start_of","content":"start_of(interval: Interval&lt;PosixTime&gt;) -&gt; IntervalBound&lt;PosixTime&gt;\n Returns the **min-bound** of `interval`\n ```\n start_of(after(5)).bound_type == Finite(5)\n start_of(before(5)).bound_type == NegativeInfinity\n start_of(between(5, 10)).bound_type == Finite(5)\n \n // also works with flipped `between` arguments\n start_of(between(10, 5)).bound_type == Finite(5)\n // as of Aiken v1.0.8-alpha\n ```","url":"time_util/cheap/interval.html#start_of"},{"doc":"time_util/cheap/interval","title":"time_util/cheap/interval","content":" A slightly cheaper version of `time_util/interval` in terms of memory and CPU usage.\n\n ```\n time_util/cheap/interval:\n ┍━ test_cheap_interval_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 2642516, cpu: 1030016700] interval_is_after_deadline\n │ PASS [mem: 2637712, cpu: 1028526316] interval_is_after_or_at_deadline\n │ PASS [mem: 2630720, cpu: 1024978974] interval_is_before_deadline\n │ PASS [mem: 2625916, cpu: 1023488590] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n \n time_util/interval:\n ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 2803844, cpu: 1095244947] interval_is_after_deadline\n │ PASS [mem: 2799040, cpu: 1093754563] interval_is_after_or_at_deadline\n │ PASS [mem: 2792048, cpu: 1090207221] interval_is_before_deadline\n │ PASS [mem: 2787244, cpu: 1088716837] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n ```","url":"time_util/cheap/interval.html"},{"doc":"test_cheap_posixtime_util","title":"test_cheap_posixtime_util","content":" ```\n ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 1209662, cpu:  463148119] interval_is_after_deadline\n │ PASS [mem: 1204858, cpu:  461657735] interval_is_after_or_at_deadline\n │ PASS [mem: 1209662, cpu:  463148119] interval_is_before_deadline\n │ PASS [mem: 1204858, cpu:  461657735] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n ```","url":"test_cheap_posixtime_util.html"},{"doc":"time_util/posixtime","title":"end_of","content":"end_of(interval: Interval&lt;PosixTime&gt;) -&gt; IntervalBound&lt;PosixTime&gt;\n Returns the **max-bound** of `interval`\n ```\n end_of(after(5)).bound_type == PositiveInfinity\n end_of(before(5)).bound_type == Finite(5)\n end_of(between(5, 10)).bound_type == Finite(10)\n \n // also works with flipped `between` arguments\n end_of(between(10, 5)).bound_type == Finite(10)\n // as of Aiken v1.0.8-alpha\n ```","url":"time_util/posixtime.html#end_of"},{"doc":"time_util/posixtime","title":"is_after","content":"is_after(some_interval: Interval&lt;PosixTime&gt;, deadline: PosixTime) -&gt; Bool\n Tells whether `some_interval` is **after** the specified `PosixTime`\n ```\n after(6) |&gt; is_after(5) == True\n between(6, 9) |&gt; is_after(5) == True\n strictly_after(5) |&gt; is_after(5) == True\n strictly_between(5, 8) |&gt; is_after(5) == True\n \n // negative cases:\n after(4) |&gt; is_after(5) == False\n strictly_after(3) |&gt; is_after(5) == False\n before(4) |&gt; is_after(5) == False\n before(5) |&gt; is_after(5) == False\n before(6) |&gt; is_after(5) == False\n strictly_before(5) |&gt; is_after(5) == False\n strictly_before(6) |&gt; is_after(5) == False\n strictly_before(7) |&gt; is_after(5) == False\n between(1, 4) |&gt; is_after(5) == False\n between(2, 5) |&gt; is_after(5) == False\n between(3, 6) |&gt; is_after(5) == False\n between(4, 7) |&gt; is_after(5) == False\n strictly_between(2, 5) |&gt; is_after(5) == False\n strictly_between(3, 6) |&gt; is_after(5) == False\n \n // interval starts AT deadline:\n after(5) |&gt; is_after(5) == False\n between(5, 8) |&gt; is_after(5) == False\n strictly_after(4) |&gt; is_after(5) == False\n strictly_between(4, 7) |&gt; is_after(5) == False\n ```","url":"time_util/posixtime.html#is_after"},{"doc":"time_util/posixtime","title":"is_after_or_at","content":"is_after_or_at(some_interval: Interval&lt;PosixTime&gt;, deadline: PosixTime) -&gt; Bool\n Tells whether `some_interval` is **after-or-at** the specified `PosixTime`\n ```\n after(6) |&gt; is_after_or_at(5) == True\n strictly_after(5) |&gt; is_after_or_at(5) == True\n between(6, 9) |&gt; is_after_or_at(5) == True\n strictly_between(5, 8) |&gt; is_after_or_at(5) == True\n \n // interval starts AT deadline:\n after(5) |&gt; is_after_or_at(5) == True\n strictly_after(4) |&gt; is_after_or_at(5) == True\n between(5, 8) |&gt; is_after_or_at(5) == True\n strictly_between(4, 7) |&gt; is_after_or_at(5) == True\n \n // negative cases:\n after(4) |&gt; is_after_or_at(5) == False\n strictly_after(3) |&gt; is_after_or_at(5) == False\n before(4) |&gt; is_after_or_at(5) == False\n before(5) |&gt; is_after_or_at(5) == False\n before(6) |&gt; is_after_or_at(5) == False\n strictly_before(5) |&gt; is_after_or_at(5) == False\n strictly_before(6) |&gt; is_after_or_at(5) == False\n strictly_before(7) |&gt; is_after_or_at(5) == False\n between(1, 4) |&gt; is_after_or_at(5) == False\n between(2, 5) |&gt; is_after_or_at(5) == False\n between(3, 6) |&gt; is_after_or_at(5) == False\n between(4, 7) |&gt; is_after_or_at(5) == False\n strictly_between(2, 5) |&gt; is_after_or_at(5) == False\n strictly_between(3, 6) |&gt; is_after_or_at(5) == False\n ```","url":"time_util/posixtime.html#is_after_or_at"},{"doc":"time_util/posixtime","title":"is_before","content":"is_before(some_interval: Interval&lt;PosixTime&gt;, deadline: PosixTime) -&gt; Bool\n Tells whether `some_interval` is **before** the specified `PosixTime`\n ```\n before(4) |&gt; is_before(5) == True\n strictly_before(5) |&gt; is_before(5) == True\n between(1, 4) |&gt; is_before(5) == True\n strictly_between(2, 5) |&gt; is_before(5) == True\n \n // negative cases:\n after(4) |&gt; is_before(5) == False\n after(5) |&gt; is_before(5) == False\n after(6) |&gt; is_before(5) == False\n strictly_after(3) |&gt; is_before(5) == False\n strictly_after(4) |&gt; is_before(5) == False\n strictly_after(5) |&gt; is_before(5) == False\n before(6) |&gt; is_before(5) == False\n strictly_before(7) |&gt; is_before(5) == False\n between(3, 6) |&gt; is_before(5) == False\n between(4, 7) |&gt; is_before(5) == False\n between(5, 8) |&gt; is_before(5) == False\n between(6, 9) |&gt; is_before(5) == False\n strictly_between(4, 7) |&gt; is_before(5) == False\n strictly_between(5, 8) |&gt; is_before(5) == False\n \n // interval ends AT deadline:\n before(5) |&gt; is_before(5) == False\n strictly_before(6) |&gt; is_before(5) == False\n between(2, 5) |&gt; is_before(5) == False\n strictly_between(3, 6) |&gt; is_before(5) == False\n ```","url":"time_util/posixtime.html#is_before"},{"doc":"time_util/posixtime","title":"is_before_or_at","content":"is_before_or_at(some_interval: Interval&lt;PosixTime&gt;, deadline: PosixTime) -&gt; Bool\n Tells whether `some_interval` is **before-or-at** the specified `PosixTime`\n ```\n before(4) |&gt; is_before_or_at(5) == True\n strictly_before(5) |&gt; is_before_or_at(5) == True\n between(1, 4) |&gt; is_before_or_at(5) == True\n strictly_between(2, 5) |&gt; is_before_or_at(5) == True\n \n // interval ends AT deadline:\n before(5) |&gt; is_before_or_at(5) == True\n strictly_before(6) |&gt; is_before_or_at(5) == True\n between(2, 5) |&gt; is_before_or_at(5) == True\n strictly_between(3, 6) |&gt; is_before_or_at(5) == True\n \n // negative cases:\n after(4) |&gt; is_before_or_at(5) == False\n after(5) |&gt; is_before_or_at(5) == False\n after(6) |&gt; is_before_or_at(5) == False\n strictly_after(3) |&gt; is_before_or_at(5) == False\n strictly_after(4) |&gt; is_before_or_at(5) == False\n strictly_after(5) |&gt; is_before_or_at(5) == False\n before(6) |&gt; is_before_or_at(5) == False\n strictly_before(7) |&gt; is_before_or_at(5) == False\n between(3, 6) |&gt; is_before_or_at(5) == False\n between(4, 7) |&gt; is_before_or_at(5) == False\n between(5, 8) |&gt; is_before_or_at(5) == False\n between(6, 9) |&gt; is_before_or_at(5) == False\n strictly_between(4, 7) |&gt; is_before_or_at(5) == False\n strictly_between(5, 8) |&gt; is_before_or_at(5) == False\n ```","url":"time_util/posixtime.html#is_before_or_at"},{"doc":"time_util/posixtime","title":"start_of","content":"start_of(interval: Interval&lt;PosixTime&gt;) -&gt; IntervalBound&lt;PosixTime&gt;\n Returns the **min-bound** of `interval`\n ```\n start_of(after(5)).bound_type == Finite(5)\n start_of(before(5)).bound_type == NegativeInfinity\n start_of(between(5, 10)).bound_type == Finite(5)\n \n // also works with flipped `between` arguments\n start_of(between(10, 5)).bound_type == Finite(5)\n // as of Aiken v1.0.8-alpha\n ```","url":"time_util/posixtime.html#start_of"},{"doc":"time_util/posixtime","title":"time_util/posixtime","content":" A utility module to help comparing some intervals to specified deadlines.\n The code reuses `time_util/interval` module, so there&#39;s only one generic\n internal function to handle all logic variations at the cost of memory and\n CPU usage.\n\n Use `time_util/cheap/posixtime` instead for cheaper memory and CPU usage.\n\n ```\n time_util/posixtime:\n ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 2803844, cpu: 1095244947] interval_is_after_deadline\n │ PASS [mem: 2799040, cpu: 1093754563] interval_is_after_or_at_deadline\n │ PASS [mem: 2792048, cpu: 1090207221] interval_is_before_deadline\n │ PASS [mem: 2787244, cpu: 1088716837] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n \n time_util/cheap/posixtime:\n ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 1209662, cpu:  463148119] interval_is_after_deadline\n │ PASS [mem: 1204858, cpu:  461657735] interval_is_after_or_at_deadline\n │ PASS [mem: 1209662, cpu:  463148119] interval_is_before_deadline\n │ PASS [mem: 1204858, cpu:  461657735] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n ```","url":"time_util/posixtime.html"},{"doc":"time_util/interval","title":"end_of","content":"end_of(interval: Interval&lt;PosixTime&gt;) -&gt; IntervalBound&lt;PosixTime&gt;\n Returns the **max-bound** of `interval`\n ```\n end_of(after(5)).bound_type == PositiveInfinity\n end_of(before(5)).bound_type == Finite(5)\n end_of(between(5, 10)).bound_type == Finite(10)\n \n // also works with flipped `between` arguments\n end_of(between(10, 5)).bound_type == Finite(10)\n // as of Aiken v1.0.8-alpha\n ```","url":"time_util/interval.html#end_of"},{"doc":"time_util/interval","title":"is_after","content":"is_after(\n  some_interval: Interval&lt;PosixTime&gt;,\n  other_interval: Interval&lt;PosixTime&gt;,\n) -&gt; Bool\n Tells whether an interval is **after** another interval.\n ```\n let an_interval = between(0, 5)\n \n after(6) |&gt; is_after(an_interval) == True\n between(6, 9) |&gt; is_after(an_interval) == True\n strictly_after(5) |&gt; is_after(an_interval) == True\n strictly_between(5, 8) |&gt; is_after(an_interval) == True\n \n // negative cases:\n after(4) |&gt; is_after(an_interval) == False\n strictly_after(3) |&gt; is_after(an_interval) == False\n before(4) |&gt; is_after(an_interval) == False\n before(5) |&gt; is_after(an_interval) == False\n before(6) |&gt; is_after(an_interval) == False\n strictly_before(5) |&gt; is_after(an_interval) == False\n strictly_before(6) |&gt; is_after(an_interval) == False\n strictly_before(7) |&gt; is_after(an_interval) == False\n between(1, 4) |&gt; is_after(an_interval) == False\n between(2, 5) |&gt; is_after(an_interval) == False\n between(3, 6) |&gt; is_after(an_interval) == False\n between(4, 7) |&gt; is_after(an_interval) == False\n strictly_between(2, 5) |&gt; is_after(an_interval) == False\n strictly_between(3, 6) |&gt; is_after(an_interval) == False\n \n // interval starts AT deadline:\n after(5) |&gt; is_after(an_interval) == False\n between(5, 8) |&gt; is_after(an_interval) == False\n strictly_after(4) |&gt; is_after(an_interval) == False\n strictly_between(4, 7) |&gt; is_after(an_interval) == False\n ```","url":"time_util/interval.html#is_after"},{"doc":"time_util/interval","title":"is_after_or_at","content":"is_after_or_at(\n  some_interval: Interval&lt;PosixTime&gt;,\n  other_interval: Interval&lt;PosixTime&gt;,\n) -&gt; Bool\n Tells whether an interval is **after-or-at** another interval.\n ```\n let an_interval = between(0, 5)\n \n after(6) |&gt; is_after_or_at(an_interval) == True\n strictly_after(5) |&gt; is_after_or_at(an_interval) == True\n between(6, 9) |&gt; is_after_or_at(an_interval) == True\n strictly_between(5, 8) |&gt; is_after_or_at(an_interval) == True\n \n // interval starts AT deadline:\n after(5) |&gt; is_after_or_at(an_interval) == True\n strictly_after(4) |&gt; is_after_or_at(an_interval) == True\n between(5, 8) |&gt; is_after_or_at(an_interval) == True\n strictly_between(4, 7) |&gt; is_after_or_at(an_interval) == True\n \n // negative cases:\n after(4) |&gt; is_after_or_at(an_interval) == False\n strictly_after(3) |&gt; is_after_or_at(an_interval) == False\n before(4) |&gt; is_after_or_at(an_interval) == False\n before(5) |&gt; is_after_or_at(an_interval) == False\n before(6) |&gt; is_after_or_at(an_interval) == False\n strictly_before(5) |&gt; is_after_or_at(an_interval) == False\n strictly_before(6) |&gt; is_after_or_at(an_interval) == False\n strictly_before(7) |&gt; is_after_or_at(an_interval) == False\n between(1, 4) |&gt; is_after_or_at(an_interval) == False\n between(2, 5) |&gt; is_after_or_at(an_interval) == False\n between(3, 6) |&gt; is_after_or_at(an_interval) == False\n between(4, 7) |&gt; is_after_or_at(an_interval) == False\n strictly_between(2, 5) |&gt; is_after_or_at(an_interval) == False\n strictly_between(3, 6) |&gt; is_after_or_at(an_interval) == False\n ```","url":"time_util/interval.html#is_after_or_at"},{"doc":"time_util/interval","title":"is_before","content":"is_before(\n  some_interval: Interval&lt;PosixTime&gt;,\n  other_interval: Interval&lt;PosixTime&gt;,\n) -&gt; Bool\n Tells whether an interval is **before** another interval.\n ```\n let an_interval = between(5, 10)\n \n before(4) |&gt; is_before(an_interval) == True\n strictly_before(5) |&gt; is_before(an_interval) == True\n between(1, 4) |&gt; is_before(an_interval) == True\n strictly_between(2, 5) |&gt; is_before(an_interval) == True\n \n // negative cases:\n after(4) |&gt; is_before(an_interval) == False\n after(5) |&gt; is_before(an_interval) == False\n after(6) |&gt; is_before(an_interval) == False\n strictly_after(3) |&gt; is_before(an_interval) == False\n strictly_after(4) |&gt; is_before(an_interval) == False\n strictly_after(5) |&gt; is_before(an_interval) == False\n before(6) |&gt; is_before(an_interval) == False\n strictly_before(7) |&gt; is_before(an_interval) == False\n between(3, 6) |&gt; is_before(an_interval) == False\n between(4, 7) |&gt; is_before(an_interval) == False\n between(5, 8) |&gt; is_before(an_interval) == False\n between(6, 9) |&gt; is_before(an_interval) == False\n strictly_between(4, 7) |&gt; is_before(an_interval) == False\n strictly_between(5, 8) |&gt; is_before(an_interval) == False\n \n // interval ends AT deadline:\n before(5) |&gt; is_before(an_interval) == False\n strictly_before(6) |&gt; is_before(an_interval) == False\n between(2, 5) |&gt; is_before(an_interval) == False\n strictly_between(3, 6) |&gt; is_before(an_interval) == False\n ```","url":"time_util/interval.html#is_before"},{"doc":"time_util/interval","title":"is_before_or_at","content":"is_before_or_at(\n  some_interval: Interval&lt;PosixTime&gt;,\n  other_interval: Interval&lt;PosixTime&gt;,\n) -&gt; Bool\n Tells whether an interval is **before-or-at** another interval.\n ```\n let an_interval = between(5, 10)\n \n before(4) |&gt; is_before_or_at(an_interval) == True\n strictly_before(5) |&gt; is_before_or_at(an_interval) == True\n between(1, 4) |&gt; is_before_or_at(an_interval) == True\n strictly_between(2, 5) |&gt; is_before_or_at(an_interval) == True\n \n // interval ends AT deadline:\n before(5) |&gt; is_before_or_at(an_interval) == True\n strictly_before(6) |&gt; is_before_or_at(an_interval) == True\n between(2, 5) |&gt; is_before_or_at(an_interval) == True\n strictly_between(3, 6) |&gt; is_before_or_at(an_interval) == True\n \n // negative cases:\n after(4) |&gt; is_before_or_at(an_interval) == False\n after(5) |&gt; is_before_or_at(an_interval) == False\n after(6) |&gt; is_before_or_at(an_interval) == False\n strictly_after(3) |&gt; is_before_or_at(an_interval) == False\n strictly_after(4) |&gt; is_before_or_at(an_interval) == False\n strictly_after(5) |&gt; is_before_or_at(an_interval) == False\n before(6) |&gt; is_before_or_at(an_interval) == False\n strictly_before(7) |&gt; is_before_or_at(an_interval) == False\n between(3, 6) |&gt; is_before_or_at(an_interval) == False\n between(4, 7) |&gt; is_before_or_at(an_interval) == False\n between(5, 8) |&gt; is_before_or_at(an_interval) == False\n between(6, 9) |&gt; is_before_or_at(an_interval) == False\n strictly_between(4, 7) |&gt; is_before_or_at(an_interval) == False\n strictly_between(5, 8) |&gt; is_before_or_at(an_interval) == False\n ```","url":"time_util/interval.html#is_before_or_at"},{"doc":"time_util/interval","title":"start_of","content":"start_of(interval: Interval&lt;PosixTime&gt;) -&gt; IntervalBound&lt;PosixTime&gt;\n Returns the **min-bound** of `interval`\n ```\n start_of(after(5)).bound_type == Finite(5)\n start_of(before(5)).bound_type == NegativeInfinity\n start_of(between(5, 10)).bound_type == Finite(5)\n \n // also works with flipped `between` arguments\n start_of(between(10, 5)).bound_type == Finite(5)\n // as of Aiken v1.0.8-alpha\n ```","url":"time_util/interval.html#start_of"},{"doc":"time_util/interval","title":"time_util/interval","content":" A utility module to help comparing the precedence between intervals.\n Internally there&#39;s only one generic function to handle all logic\n variations at the cost of memory and CPU usage.\n\n Use `time_util/cheap/interval` instead for a slightly cheaper memory\n and CPU usage.\n\n ```\n time_util/interval:\n ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 2803844, cpu: 1095244947] interval_is_after_deadline\n │ PASS [mem: 2799040, cpu: 1093754563] interval_is_after_or_at_deadline\n │ PASS [mem: 2792048, cpu: 1090207221] interval_is_before_deadline\n │ PASS [mem: 2787244, cpu: 1088716837] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n \n time_util/cheap/interval:\n ┍━ test_cheap_interval_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 2642516, cpu: 1030016700] interval_is_after_deadline\n │ PASS [mem: 2637712, cpu: 1028526316] interval_is_after_or_at_deadline\n │ PASS [mem: 2630720, cpu: 1024978974] interval_is_before_deadline\n │ PASS [mem: 2625916, cpu: 1023488590] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n ```","url":"time_util/interval.html"},{"doc":"test_time_util","title":"test_time_util","content":" ```\n ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 2803844, cpu: 1095244947] interval_is_after_deadline\n │ PASS [mem: 2799040, cpu: 1093754563] interval_is_after_or_at_deadline\n │ PASS [mem: 2792048, cpu: 1090207221] interval_is_before_deadline\n │ PASS [mem: 2787244, cpu: 1088716837] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n ```","url":"test_time_util.html"},{"doc":"time_util/cheap/posixtime","title":"end_of","content":"end_of(interval: Interval&lt;PosixTime&gt;) -&gt; IntervalBound&lt;PosixTime&gt;\n Returns the **max-bound** of `interval`\n ```\n end_of(after(5)).bound_type == PositiveInfinity\n end_of(before(5)).bound_type == Finite(5)\n end_of(between(5, 10)).bound_type == Finite(10)\n \n // also works with flipped `between` arguments\n end_of(between(10, 5)).bound_type == Finite(10)\n // as of Aiken v1.0.8-alpha\n ```","url":"time_util/cheap/posixtime.html#end_of"},{"doc":"time_util/cheap/posixtime","title":"is_after","content":"is_after(some_interval: Interval&lt;PosixTime&gt;, deadline: PosixTime) -&gt; Bool\n Tells whether `some_interval` is **after** the specified `PosixTime`\n ```\n after(6) |&gt; is_after(5) == True\n between(6, 9) |&gt; is_after(5) == True\n strictly_after(5) |&gt; is_after(5) == True\n strictly_between(5, 8) |&gt; is_after(5) == True\n \n // negative cases:\n after(4) |&gt; is_after(5) == False\n strictly_after(3) |&gt; is_after(5) == False\n before(4) |&gt; is_after(5) == False\n before(5) |&gt; is_after(5) == False\n before(6) |&gt; is_after(5) == False\n strictly_before(5) |&gt; is_after(5) == False\n strictly_before(6) |&gt; is_after(5) == False\n strictly_before(7) |&gt; is_after(5) == False\n between(1, 4) |&gt; is_after(5) == False\n between(2, 5) |&gt; is_after(5) == False\n between(3, 6) |&gt; is_after(5) == False\n between(4, 7) |&gt; is_after(5) == False\n strictly_between(2, 5) |&gt; is_after(5) == False\n strictly_between(3, 6) |&gt; is_after(5) == False\n \n // interval starts AT deadline:\n after(5) |&gt; is_after(5) == False\n between(5, 8) |&gt; is_after(5) == False\n strictly_after(4) |&gt; is_after(5) == False\n strictly_between(4, 7) |&gt; is_after(5) == False\n ```","url":"time_util/cheap/posixtime.html#is_after"},{"doc":"time_util/cheap/posixtime","title":"is_after_or_at","content":"is_after_or_at(some_interval: Interval&lt;PosixTime&gt;, deadline: PosixTime) -&gt; Bool\n Tells whether `some_interval` is **after-or-at** the specified `PosixTime`\n ```\n after(6) |&gt; is_after_or_at(5) == True\n strictly_after(5) |&gt; is_after_or_at(5) == True\n between(6, 9) |&gt; is_after_or_at(5) == True\n strictly_between(5, 8) |&gt; is_after_or_at(5) == True\n \n // interval starts AT deadline:\n after(5) |&gt; is_after_or_at(5) == True\n strictly_after(4) |&gt; is_after_or_at(5) == True\n between(5, 8) |&gt; is_after_or_at(5) == True\n strictly_between(4, 7) |&gt; is_after_or_at(5) == True\n \n // negative cases:\n after(4) |&gt; is_after_or_at(5) == False\n strictly_after(3) |&gt; is_after_or_at(5) == False\n before(4) |&gt; is_after_or_at(5) == False\n before(5) |&gt; is_after_or_at(5) == False\n before(6) |&gt; is_after_or_at(5) == False\n strictly_before(5) |&gt; is_after_or_at(5) == False\n strictly_before(6) |&gt; is_after_or_at(5) == False\n strictly_before(7) |&gt; is_after_or_at(5) == False\n between(1, 4) |&gt; is_after_or_at(5) == False\n between(2, 5) |&gt; is_after_or_at(5) == False\n between(3, 6) |&gt; is_after_or_at(5) == False\n between(4, 7) |&gt; is_after_or_at(5) == False\n strictly_between(2, 5) |&gt; is_after_or_at(5) == False\n strictly_between(3, 6) |&gt; is_after_or_at(5) == False\n ```","url":"time_util/cheap/posixtime.html#is_after_or_at"},{"doc":"time_util/cheap/posixtime","title":"is_before","content":"is_before(some_interval: Interval&lt;PosixTime&gt;, deadline: PosixTime) -&gt; Bool\n Tells whether `some_interval` is **before** the specified `PosixTime`\n ```\n before(4) |&gt; is_before(5) == True\n strictly_before(5) |&gt; is_before(5) == True\n between(1, 4) |&gt; is_before(5) == True\n strictly_between(2, 5) |&gt; is_before(5) == True\n \n // negative cases:\n after(4) |&gt; is_before(5) == False\n after(5) |&gt; is_before(5) == False\n after(6) |&gt; is_before(5) == False\n strictly_after(3) |&gt; is_before(5) == False\n strictly_after(4) |&gt; is_before(5) == False\n strictly_after(5) |&gt; is_before(5) == False\n before(6) |&gt; is_before(5) == False\n strictly_before(7) |&gt; is_before(5) == False\n between(3, 6) |&gt; is_before(5) == False\n between(4, 7) |&gt; is_before(5) == False\n between(5, 8) |&gt; is_before(5) == False\n between(6, 9) |&gt; is_before(5) == False\n strictly_between(4, 7) |&gt; is_before(5) == False\n strictly_between(5, 8) |&gt; is_before(5) == False\n \n // interval ends AT deadline:\n before(5) |&gt; is_before(5) == False\n strictly_before(6) |&gt; is_before(5) == False\n between(2, 5) |&gt; is_before(5) == False\n strictly_between(3, 6) |&gt; is_before(5) == False\n ```","url":"time_util/cheap/posixtime.html#is_before"},{"doc":"time_util/cheap/posixtime","title":"is_before_or_at","content":"is_before_or_at(some_interval: Interval&lt;PosixTime&gt;, deadline: PosixTime) -&gt; Bool\n Tells whether `some_interval` is **before-or-at** the specified `PosixTime`\n ```\n before(4) |&gt; is_before_or_at(5) == True\n strictly_before(5) |&gt; is_before_or_at(5) == True\n between(1, 4) |&gt; is_before_or_at(5) == True\n strictly_between(2, 5) |&gt; is_before_or_at(5) == True\n \n // interval ends AT deadline:\n before(5) |&gt; is_before_or_at(5) == True\n strictly_before(6) |&gt; is_before_or_at(5) == True\n between(2, 5) |&gt; is_before_or_at(5) == True\n strictly_between(3, 6) |&gt; is_before_or_at(5) == True\n \n // negative cases:\n after(4) |&gt; is_before_or_at(5) == False\n after(5) |&gt; is_before_or_at(5) == False\n after(6) |&gt; is_before_or_at(5) == False\n strictly_after(3) |&gt; is_before_or_at(5) == False\n strictly_after(4) |&gt; is_before_or_at(5) == False\n strictly_after(5) |&gt; is_before_or_at(5) == False\n before(6) |&gt; is_before_or_at(5) == False\n strictly_before(7) |&gt; is_before_or_at(5) == False\n between(3, 6) |&gt; is_before_or_at(5) == False\n between(4, 7) |&gt; is_before_or_at(5) == False\n between(5, 8) |&gt; is_before_or_at(5) == False\n between(6, 9) |&gt; is_before_or_at(5) == False\n strictly_between(4, 7) |&gt; is_before_or_at(5) == False\n strictly_between(5, 8) |&gt; is_before_or_at(5) == False\n ```","url":"time_util/cheap/posixtime.html#is_before_or_at"},{"doc":"time_util/cheap/posixtime","title":"start_of","content":"start_of(interval: Interval&lt;PosixTime&gt;) -&gt; IntervalBound&lt;PosixTime&gt;\n Returns the **min-bound** of `interval`\n ```\n start_of(after(5)).bound_type == Finite(5)\n start_of(before(5)).bound_type == NegativeInfinity\n start_of(between(5, 10)).bound_type == Finite(5)\n \n // also works with flipped `between` arguments\n start_of(between(10, 5)).bound_type == Finite(5)\n // as of Aiken v1.0.8-alpha\n ```","url":"time_util/cheap/posixtime.html#start_of"},{"doc":"time_util/cheap/posixtime","title":"time_util/cheap/posixtime","content":" A cheaper version of `time_util/posixtime` in terms of memory and CPU usage.\n\n ```\n time_util/cheap/posixtime:\n ┍━ test_cheap_posixtime_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 1209662, cpu:  463148119] interval_is_after_deadline\n │ PASS [mem: 1204858, cpu:  461657735] interval_is_after_or_at_deadline\n │ PASS [mem: 1209662, cpu:  463148119] interval_is_before_deadline\n │ PASS [mem: 1204858, cpu:  461657735] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n \n time_util/posixtime:\n ┍━ test_time_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 2803844, cpu: 1095244947] interval_is_after_deadline\n │ PASS [mem: 2799040, cpu: 1093754563] interval_is_after_or_at_deadline\n │ PASS [mem: 2792048, cpu: 1090207221] interval_is_before_deadline\n │ PASS [mem: 2787244, cpu: 1088716837] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n ```","url":"time_util/cheap/posixtime.html"},{"doc":"test_cheap_interval_util","title":"test_cheap_interval_util","content":" ```\n ┍━ test_cheap_interval_util ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n │ PASS [mem: 2642516, cpu: 1030016700] interval_is_after_deadline\n │ PASS [mem: 2637712, cpu: 1028526316] interval_is_after_or_at_deadline\n │ PASS [mem: 2630720, cpu: 1024978974] interval_is_before_deadline\n │ PASS [mem: 2625916, cpu: 1023488590] interval_is_before_or_at_deadline\n ┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4 tests | 4 passed | 0 failed\n ```","url":"test_cheap_interval_util.html"}]);