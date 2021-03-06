const expect = @import("std").testing.expect;

test "if statements" {
    shouldBeEqual(1, 1);
    firstEqlThird(2, 1, 2);
}
fn shouldBeEqual(a: i32, b: i32) void {
    if (a != b) {
        unreachable;
    } else {
        return;
    }
}
fn firstEqlThird(a: i32, b: i32, c: i32) void {
    if (a == b) {
        unreachable;
    } else if (b == c) {
        unreachable;
    } else if (a == c) {
        return;
    } else {
        unreachable;
    }
}

test "else if expression" {
    expect(elseIfExpressionF(1) == 1);
}
fn elseIfExpressionF(c: u8) u8 {
    if (c == 0) {
        return 0;
    } else if (c == 1) {
        return 1;
    } else {
        return u8(2);
    }
}

// #2297
var global_with_val: anyerror!u32 = 0;
var global_with_err: anyerror!u32 = error.SomeError;

test "unwrap mutable global var" {
    if (global_with_val) |v| {
        expect(v == 0);
    } else |e| {
        unreachable;
    }
    if (global_with_err) |_| {
        unreachable;
    } else |e| {
        expect(e == error.SomeError);
    }
}

test "labeled break inside comptime if inside runtime if" {
    var answer: i32 = 0;
    var c = true;
    if (c) {
        answer = if (true) blk: {
            break :blk i32(42);
        };
    }
    expect(answer == 42);
}

test "const result loc, runtime if cond, else unreachable" {
    const Num = enum {
        One,
        Two,
    };

    var t = true;
    const x = if (t) Num.Two else unreachable;
    if (x != .Two) @compileError("bad");
}

test "if prongs cast to expected type instead of peer type resolution" {
    const S = struct {
        fn doTheTest(f: bool) void {
            var x: i32 = 0;
            x = if (f) 1 else 2;
            expect(x == 2);
        }
    };
    S.doTheTest(false);
    comptime S.doTheTest(false);
}
