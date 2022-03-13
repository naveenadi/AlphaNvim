local cmd = vim.cmd
local api = vim.api
local exec = vim.api.nvim_exec -- Execute Vimscript

local definations = require("alpha.core.utils").load_config().autocmds

local function create_nvim_augroups(nvim_definitions)
	for group_name, definition in pairs(nvim_definitions) do
		api.nvim_command("augroup " .. group_name)
		api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			api.nvim_command(command)
		end
		api.nvim_command("augroup END")
	end
end

local function create_augroups(autocmds, name)
	cmd("augroup " .. name)
	cmd("autocmd!")
	for _, autocmd in ipairs(autocmds) do
		cmd("autocmd " .. table.concat(autocmd, " "))
	end
	cmd("augroup End")
end

-- if there is an error with the user config, fallback onto the default config
-- and print an error message
local nvim_augroups_status, _ = pcall(create_nvim_augroups, definations)
if not nvim_augroups_status then
	definations = require("alpha.core.defaults").autocmds
	create_nvim_augroups(definations)
	print("Error: user config - `autocmds`")
end

-- Remove whitespace on save
cmd([[au BufWritePre * :%s/\s\+$//e]])

-- Highlight on yank
exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=800}
  augroup end
]],
	false
)

-- Don't auto commenting new lines
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]])

-- Remove line lenght marker for selected filetypes
cmd([[autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0]])

-- 2 spaces for selected filetypes
cmd([[
  autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]])

-- Open a terminal pane on the right using :Term
cmd([[command Term :botright vsplit term://$SHELL]])

-- Terminal visual tweaks:
--- enter insert mode when switching to terminal
--- close terminal buffer on process exit
cmd([[
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
    autocmd TermOpen * startinsert
    autocmd BufLeave term://* stopinsert
]])
