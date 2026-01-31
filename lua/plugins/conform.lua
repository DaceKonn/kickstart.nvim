-- formating plugin
return {
    'stevearc/conform.nvim',
    opts = {
        notify_on_error = false,
        -- Odinfmt gets its configuration from odinfmt.json. It defaults
        -- writing to stdout but needs to be told to read from stdin.
        formatters = {
            odinfmt = {
                -- Change where to find the command if it isn't in your path.
                command = "odinfmt",
                args = { "-stdin" },
                stdin = true,
            },
        },
        -- and instruct conform to use odinfmt.
        formatters_by_ft = {
            odin = { "odinfmt" },
        },
    },
}
