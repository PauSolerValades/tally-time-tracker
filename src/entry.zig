const std = @import("std");
const sqlite = @import("sqlite");

pub fn start_entry(db: *sqlite.Db, description: []const u8, project: ?u64) !void {
    _ = description;
    _ = project;
    _ = db;
    std.debug.print("Let's start the entry!\n", .{});
}

