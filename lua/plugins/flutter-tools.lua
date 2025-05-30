return {
	{
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = function()
			require("flutter-tools").setup({
				lsp = {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				},
			})
		end,
	},
}
