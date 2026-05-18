# ziez-template

Template engine with layouts and caching for [ziez](https://github.com/ziez-dev/ziez).

## Requirements

- Zig 0.16.0+

## Installation

In `build.zig.zon`:

```zig
.dependencies = .{
    .ziez = .{
        .url = "https://github.com/ziez-dev/ziez/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "ziez-0.0.1-zH20Gh1jAwADi2a_88hnfVHclInMW1YPLF_y7SS7CJ5Y",
    },
    .@"ziez-template" = .{
        .url = "https://github.com/ziez-dev/template/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "1220b1fe03d61a1cc83ee28e918e1a2e4f0e0d6d1e23844e0c0e28194a8bbbe9d2e8",
    },
},
```

In `build.zig`:

```zig
const template_dep = b.dependency("ziez-template", .{
    .target = target,
    .optimize = optimize,
});
exe_mod.addImport("ziez_template", template_dep.module("ziez-template"));
```

## Quick Start

```zig
const std = @import("std");
const ziez = @import("ziez");
const tpl = @import("ziez_template");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();


    var app = ziez.init(allocator);
    defer app.deinit();

    var engine = tpl.TemplateEngine.init(allocator, .{
        .views_dir = "./views",
        .default_layout = "default",
    });

    tpl.setup(&app, &engine);

    app.get("/", struct {
        fn h(req: *ziez.Request, res: *ziez.Response) !void {
            const html = try res.template_engine.?.renderAlloc(res.allocator, "index", .{
                .title = "Home",
                .message = "Hello from template engine!",
            });
            defer res.allocator.free(html);
            res.type_html().sendBody(html);
        }
    }.h);

    try app.listen( "0.0.0.0:3000");
}
```

## Configuration

**TemplateConfig:**

| Option | Type | Default | Description |
|---|---|---|---|
| `views_dir` | `[]const u8` | `"./views"` | Directory containing template files |
| `default_layout` | `?[]const u8` | `null` | Default layout template |
| `cache` | `bool` | `true` | Cache compiled templates |
| `extension` | `[]const u8` | `".html"` | Template file extension |

Templates use `{{variable}}` syntax for substitution.

## License

MIT
