const std = @import("std");
const sqlite = @import("sqlite");
const clap = @import("clap");

const entry_func = @import("entry.zig");

const SubCommands = enum {
    entry,
    project,
    help
};

const EntrySubCommands = enum {
    start,
    status,
    stop,
    log,
    list,
    edit,
    delete,
};

const main_params = clap.parseParamsComptime(
    \\-h, --help  Display this help and exit.
    \\<command>
    \\
);

const entry_params = clap.parseParamsComptime(
    \\-h, --help  Display this help and exit.
    \\<command>
    \\
);

const main_parsers = .{
    .command = clap.parsers.enumeration(SubCommands),
};

const entry_parsers = .{
    .command = clap.parsers.enumeration(EntrySubCommands),
};

// To pass around arguments returned by clap, `clap.Result` and `clap.ResultEx` can be used to
// get the return type of `clap.parse` and `clap.parseEx`.
const MainArgs = clap.ResultEx(clap.Help, &main_params, main_parsers);

pub fn main() !void {
    var gpa_state = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = gpa_state.allocator();
    defer _ = gpa_state.deinit();

    var db = try sqlite.Db.init(.{
        .mode = sqlite.Db.Mode{ .File = "./tracker.db" },
        .open_flags = .{
            .write = true,
            .create = true,
        },
        .threading_mode = .MultiThread,
    });
    var iter = try std.process.ArgIterator.initWithAllocator(gpa);
    defer iter.deinit();

    _ = iter.next();

    var diag = clap.Diagnostic{};
    var res = clap.parseEx(clap.Help, &main_params, main_parsers, &iter, .{
        .diagnostic = &diag,
        .allocator = gpa,
        .terminating_positional = 0,
    }) catch |err| {
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    if (res.args.help != 0)
        std.debug.print("--help\n", .{});

    const command = res.positionals[0] orelse return error.MissingCommand;
    switch (command) {
        .help => std.debug.print("--help\n", .{}),
        .entry => try entryMain(gpa, &iter, &db),
        .project => try projectMain(gpa, &iter),
    }
}

fn entryMain(gpa: std.mem.Allocator, iter: *std.process.ArgIterator, db: *sqlite.Db) !void {
    // Here we pass the partially parsed argument iterator.
    var diag = clap.Diagnostic{};
    var res = clap.parseEx(clap.Help, &entry_params, entry_parsers, iter, .{
        .diagnostic = &diag,
        .allocator = gpa,
        .terminating_positional = 0,
    }) catch |err| {
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();
    
    const command = res.positionals[0] orelse return error.MissingCommand;
    switch (command) {
        .start => try entryStartMain(gpa, iter, db),
        .stop => try entryStopMain(gpa, iter),
        .status => std.debug.print("DETECTO STATUS", .{}),
        .log => std.debug.print("DETECTO log", .{}),
        .list => std.debug.print("DETECTO list", .{}),
        .delete => std.debug.print("DETECTO delete", .{}),
        .edit => std.debug.print("DETECTO edit", .{}),
    }
}

fn entryStartMain(gpa: std.mem.Allocator, iter: *std.process.ArgIterator, db: *sqlite.Db) !void {
    // The parameters for the subcommand.
    const params = comptime clap.parseParamsComptime(
        \\-h, --help            Display this help and exit.
        \\-p, --project <u64>   Project ID to add the entry under
        \\<str>                 Task description 
        \\
    );
    // Here we pass the partially parsed argument iterator.
    var diag = clap.Diagnostic{};
    var res = clap.parseEx(clap.Help, &params, clap.parsers.default, iter, .{
        .diagnostic = &diag,
        .allocator = gpa,
    }) catch |err| {
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();
   
    if (res.positionals[0]) |description| {
        const project_id = res.args.project;

        std.debug.print("Starting entry: {s} for project {?d}\n", .{
            description,
            project_id,
        });

        try entry_func.start_entry(db, description, project_id);    
    
    } else {
        std.debug.print("Descritpion is not provided\n", .{});
        return; 
    } 
}

fn entryStopMain(gpa: std.mem.Allocator, iter: *std.process.ArgIterator) !void {
    std.debug.print("hola és l'stop això\n", .{});
    _ = gpa;
    _ = iter;
}


fn projectMain(gpa: std.mem.Allocator, iter: *std.process.ArgIterator) !void {
    std.debug.print("Hi ha un project al davant!\n", .{});
    _ = gpa;
    _ = iter;

}
