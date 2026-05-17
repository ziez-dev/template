const std = @import("std");
const tpl = @import("ziez_template");

test "TemplateEngine.renderString - basic interpolation"
{
    const allocator = std.testing.allocator;
    var engine = tpl.TemplateEngine.init(allocator, .{ .cache = false });
    defer engine.deinit();

    const result = try engine.renderString(allocator, "Hello {{name}}!", .{ .name = "World" });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Hello World!", result);
}

test "TemplateEngine.renderString - multiple fields"
{
    const allocator = std.testing.allocator;
    var engine = tpl.TemplateEngine.init(allocator, .{ .cache = false });
    defer engine.deinit();

    const result = try engine.renderString(allocator, "{{greeting}} {{name}}, you are {{age}}", .{
        .greeting = "Hi",
        .name = "Alice",
        .age = @as(u32, 30),
    });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Hi Alice, you are 30", result);
}

test "TemplateEngine.renderString - bool value"
{
    const allocator = std.testing.allocator;
    var engine = tpl.TemplateEngine.init(allocator, .{ .cache = false });
    defer engine.deinit();

    const result = try engine.renderString(allocator, "active: {{active}}", .{ .active = true });
    defer allocator.free(result);
    try std.testing.expectEqualStrings("active: true", result);
}

test "TemplateEngine.renderString - missing field preserved"
{
    const allocator = std.testing.allocator;
    var engine = tpl.TemplateEngine.init(allocator, .{ .cache = false });
    defer engine.deinit();

    const result = try engine.renderString(allocator, "Hello {{unknown}}!", .{});
    defer allocator.free(result);
    try std.testing.expectEqualStrings("Hello {{unknown}}!", result);
}

test "TemplateEngine.renderString - body placeholder preserved"
{
    const allocator = std.testing.allocator;
    var engine = tpl.TemplateEngine.init(allocator, .{ .cache = false });
    defer engine.deinit();

    const result = try engine.renderString(allocator, "<div>{{body}}</div>", .{});
    defer allocator.free(result);
    try std.testing.expectEqualStrings("<div>{{body}}</div>", result);
}

test "TemplateEngine.renderString - no placeholders"
{
    const allocator = std.testing.allocator;
    var engine = tpl.TemplateEngine.init(allocator, .{ .cache = false });
    defer engine.deinit();

    const result = try engine.renderString(allocator, "plain text", .{});
    defer allocator.free(result);
    try std.testing.expectEqualStrings("plain text", result);
}

test "TemplateConfig defaults"
{
    const config = tpl.TemplateConfig{};
    try std.testing.expectEqualStrings("./views", config.views_dir);
    try std.testing.expect(config.default_layout == null);
    try std.testing.expect(config.cache == true);
    try std.testing.expectEqualStrings(".html", config.extension);
}

test "TemplateEngine init/deinit"
{
    const allocator = std.testing.allocator;
    var engine = tpl.TemplateEngine.init(allocator, .{});
    engine.deinit();
}
