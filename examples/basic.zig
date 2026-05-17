const std = @import("std");
const ziez = @import("ziez");
const tpl = @import("ziez_template");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var threaded = std.Io.Threaded.init_single_threaded;
    const io = threaded.io();

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

    try app.listen(io, "0.0.0.0:3000");
}
