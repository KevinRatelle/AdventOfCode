const Builder = @import("std").Build;

pub fn build(builder: *Builder) void
{
	const target = builder.standardTargetOptions(.{});
	const optimize = builder.standardOptimizeOption(.{});

	const exe = builder.addExecutable(.{
		.name = "Zig",
		.root_source_file = .{ .path = "src/main.zig" },
		.target = target,
		.optimize = optimize,
	});

	builder.installArtifact(exe);
}