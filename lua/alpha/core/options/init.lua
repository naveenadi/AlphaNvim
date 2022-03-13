-- aliases
local opt = vim.opt -- global
local g = vim.g -- global for let options
local wo = vim.wo -- window local
local bo = vim.bo -- buffer local
local fn = vim.fn -- access vim functions
local cmd = vim.cmd -- vim commands

local opts = require("alpha.core.utils").load_config().options

local function load_nvim_opts(nvim_opts)
	for nvim_opt, set in pairs(nvim_opts) do
		opt[nvim_opt] = set
	end
end

cmd("colorscheme desert")
cmd("filetype plugin indent on")

-- disable nvim intro
opt.shortmess:append("sI")
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")
-- Defer loading shada until after startup_
opt.shadafile = "NONE"

-- if there is an error with the user config, fallback onto the default config
-- and print an error message
local nvim_opts_status, _ = pcall(load_nvim_opts, opts)
if not nvim_opts_status then
	opts = require("alpha.core.defaults").options
	load_nvim_opts(opts)
	print("Error: user config - `options` ")
end

vim.schedule(function()
	opt.shadafile = require("alpha.core.utils").load_config().options.shadafile
	vim.cmd([[ silent! rsh ]])
end)

-- disable some builtin vim plugins
local disabled_built_ins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	--
	"matchparen",
	"shada_plugin",
	"tutor_mode_plugin",
	"remote_plugins",
}

for _, plugin in pairs(disabled_built_ins) do
	g["loaded_" .. plugin] = 1
end
