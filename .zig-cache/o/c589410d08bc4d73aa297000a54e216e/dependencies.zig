pub const packages = struct {
    pub const @"N-V-__8AAH-mpwB7g3MnqYU-ooUBF1t99RP27dZ9addtMVXD" = struct {
        pub const build_root = "/home/pau/.cache/zig/p/N-V-__8AAH-mpwB7g3MnqYU-ooUBF1t99RP27dZ9addtMVXD";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"clap-0.10.0-oBajB7jkAQAZ4cKLlzkeV9mDu2yGZvtN2QuOyfAfjBij" = struct {
        pub const build_root = "/home/pau/.cache/zig/p/clap-0.10.0-oBajB7jkAQAZ4cKLlzkeV9mDu2yGZvtN2QuOyfAfjBij";
        pub const build_zig = @import("clap-0.10.0-oBajB7jkAQAZ4cKLlzkeV9mDu2yGZvtN2QuOyfAfjBij");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
    pub const @"sqlite-3.48.0-F2R_a9GLDgAXT-c49TfkFMt6yPOMQAYfp4ig8bRNdZs4" = struct {
        pub const build_root = "/home/pau/.cache/zig/p/sqlite-3.48.0-F2R_a9GLDgAXT-c49TfkFMt6yPOMQAYfp4ig8bRNdZs4";
        pub const build_zig = @import("sqlite-3.48.0-F2R_a9GLDgAXT-c49TfkFMt6yPOMQAYfp4ig8bRNdZs4");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "sqlite", "N-V-__8AAH-mpwB7g3MnqYU-ooUBF1t99RP27dZ9addtMVXD" },
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "sqlite", "sqlite-3.48.0-F2R_a9GLDgAXT-c49TfkFMt6yPOMQAYfp4ig8bRNdZs4" },
    .{ "clap", "clap-0.10.0-oBajB7jkAQAZ4cKLlzkeV9mDu2yGZvtN2QuOyfAfjBij" },
};
