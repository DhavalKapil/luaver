#!/usr/bin/env bats

load init

@test "print_formatted test" {
	run __luaver_print_formatted "test_str"
	[ "${status}"  -eq 0 ]
	[ "${lines[0]}" = "test_str" ]
}
