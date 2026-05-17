const std = @import("std");
const ziez = @import("ziez");
const template = @import("template.zig");

pub const TemplateEngine = template.TemplateEngine;
pub const TemplateConfig = template.TemplateConfig;

/// Returns a Middleware that injects the template engine into every response.
/// The caller owns the TemplateEngine lifetime; it is NOT freed at app.deinit().
pub fn middleware(engine: *TemplateEngine) ziez.Middleware {
    return template.asMiddleware(engine);
}

/// Convenience: registers template middleware on the app in one call.
pub fn setup(app: *ziez.App, engine: *TemplateEngine) void {
    app.use(middleware(engine));
}
