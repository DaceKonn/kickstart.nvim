-- Declare the path where lazy will clone plugin code
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check to see if lazy itself has been cloned, if not clone it into the lazy.nvim directory
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

-- Add the path to the lazy plugin repositories to the vim runtime path
vim.opt.rtp:prepend(lazypath)

-- Declare a few options for lazy
local opts = {
	change_detection = {
		-- Don't notify us every time a change is made to the configuration
		notify = false,
	},
	checker = {
		-- Automatically check for package updates
		enabled = true,
		-- Don't spam us with notification every time there is an update available
		notify = false,
	},
	ui = {
	  -- If you are using a Nerd Font: set icons to an empty table which will use the
	  -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
	  icons = vim.g.have_nerd_font and {} or {
		cmd = '⌘',
		config = '🛠',
		event = '📅',
		ft = '📂',
		init = '⚙',
		keys = '🗝',
		plugin = '🔌',
		runtime = '💻',
		require = '🌙',
		source = '📄',
		start = '🚀',
		task = '📌',
		lazy = '💤 ',
	  },
	},
}

-- Load the options from the config/options.lua file
require("config.options")
-- Load the keymaps from the config/keymaps.lua file
require("config.keymaps")
-- Load the auto commands from the config/autocmds.lua file
require("config.autocmds")
require("config.neovide")
-- Setup lazy, this should always be last
-- Tell lazy that all plugin specs are found in the plugins directory
-- Pass it the options we specified above
require("lazy").setup("plugins", opts)
