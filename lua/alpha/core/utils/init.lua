local execute = vim.api.nvim_command
local vim = vim
local opt = vim.opt -- global
local g = vim.g -- global for let options
local wo = vim.wo -- window local
local bo = vim.bo -- buffer local
local fn = vim.fn -- access vim functions
local cmd = vim.cmd -- vim commands
local api = vim.api -- access vim api

local M = {}

M.bg = function(group, col)
	cmd("hi " .. group .. " guibg=" .. col)
end

M.fg = function(group, col)
	cmd("hi " .. group .. " guifg=" .. col)
end

M.fg_bg = function(group, fgcol, bgcol)
	cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

M.load_config = function()
	local conf = require("alpha.core.defaults")
	local alpharcExists, change = pcall(require, "custom.alpharc")

	-- if alpharc exists , then merge its table into the default config's
	if alpharcExists then
		conf = vim.tbl_deep_extend("force", conf, change)
	end

	return conf
end

M.override_req = function(name, default_req)
	local override = require("alpha.core.utils").load(name).custom_plugins[name]
	local result = default_req

	if override ~= nil then
		result = override
	end

	if string.match(result, "^%(") then
		result = result:sub(2)
		result = result:gsub("%)%.", "').", 1)
		return "require ('" .. result
	end

	return "require('" .. result .. "')"
end

-- References
-- https://bit.ly/3HqvgRT
M.CountWordFunction = function()
	local hlsearch_status = vim.v.hlsearch
	local old_query = vim.fn.getreg("/") -- save search register
	local current_word = vim.fn.expand("<cword>")
	vim.fn.setreg("/", current_word)
	local wordcount = vim.fn.searchcount({ maxcount = 1000, timeout = 500 }).total
	vim.fn.setreg("/", old_query) -- restore search register
	print("Current word found: " .. wordcount .. " times")
	-- Below we are using the nvim-notify plugin to show up the count of words
	vim.cmd([[highlight CurrenWord ctermbg=LightGray ctermfg=Red guibg=LightGray guifg=Black]])
	vim.cmd([[exec 'match CurrenWord /\V\<' . expand('<cword>') . '\>/']])
	-- require("notify")("word '" .. current_word .. "' found " .. wordcount .. " times")
end

local transparency = 0
M.toggle_transparency = function()
	if transparency == 0 then
		vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
		local transparency = 1
	else
		vim.cmd("hi Normal guibg=#111111 ctermbg=black")
		local transparency = 0
	end
end

M.toggle_colors = function()
	local current_color = vim.g.colors_name
	if current_color == "tokyonight" then
		vim.cmd("colorscheme monokai")
		vim.cmd("colo")
	elseif current_color == "monokai" then
		vim.cmd("colorscheme dawnfox")
		vim.cmd("colo")
	elseif current_color == "dawnfox" then
		vim.cmd("colorscheme onedark")
		vim.cmd("colo")
	elseif current_color == "onedark" then
		vim.cmd("colorscheme iceberg")
		vim.cmd("colo")
	else
		--vim.g.tokyonight_transparent = true
		vim.cmd("colorscheme tokyonight")
		vim.cmd("colo")
	end
end

M.flash_cursorline = function()
	-- local cursorline_state = vim.opt.cursorline:get()
	vim.opt.cursorline = true
	vim.cmd([[hi CursorLine guifg=#FFFFFF guibg=#FF9509]])
	vim.fn.timer_start(200, function()
		vim.cmd([[hi CursorLine guifg=NONE guibg=NONE]])
		vim.opt.cursorline = false
	end)
end

M.ToggleQuickFix = function()
	if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
		vim.cmd([[cclose]])
	else
		vim.cmd([[copen]])
	end
end
vim.cmd([[command! -nargs=0 -bar ToggleQuickFix lua require('alpha.core.utils').ToggleQuickFix()]])
vim.cmd([[cnoreab TQ ToggleQuickFix]])
vim.cmd([[cnoreab tq ToggleQuickFix]])

-- dos2unix
M.dosToUnix = function()
	M.preserve("%s/\\%x0D$//e")
	vim.bo.fileformat = "unix"
	vim.bo.bomb = true
	vim.opt.encoding = "utf-8"
	vim.opt.fileencoding = "utf-8"
end
vim.cmd([[command! Dos2unix lua require('alpha.core.utils').dosToUnix()]])

M.squeeze_blank_lines = function()
	if vim.bo.binary == false and vim.opt.filetype:get() ~= "diff" then
		local old_query = vim.fn.getreg("/") -- save search register
		M.preserve("sil! 1,.s/^\\n\\{2,}/\\r/gn") -- set current search count number
		local result = vim.fn.searchcount({ maxcount = 1000, timeout = 500 }).current
		local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
		M.preserve("sil! keepp keepj %s/^\\n\\{2,}/\\r/ge")
		M.preserve("sil! keepp keepj %s/\\v($\\n\\s*)+%$/\\r/e")
		if result > 0 then
			vim.api.nvim_win_set_cursor({ 0 }, { (line - result), col })
		end
		vim.fn.setreg("/", old_query) -- restore search register
	end
end

M.ReloadConfig = function()
	local hls_status = vim.v.hlsearch
	for name, _ in pairs(package.loaded) do
		if name:match("^cnull") then
			package.loaded[name] = nil
		end
	end
	dofile(vim.env.MYVIMRC)
	if hls_status == 0 then
		vim.opt.hlsearch = false
	end
end

M.preserve = function(arguments)
	local arguments = string.format("keepjumps keeppatterns execute %q", arguments)
	-- local original_cursor = vim.fn.winsaveview()
	local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_command(arguments)
	local lastline = vim.fn.line("$")
	-- vim.fn.winrestview(original_cursor)
	if line > lastline then
		line = lastline
	end
	vim.api.nvim_win_set_cursor({ 0 }, { line, col })
end

--> :lua changeheader()
-- This function is called with the BufWritePre event (autocmd)
-- and when I want to save a file I use ":update" which
-- only writes a buffer if it was modified
M.changeheader = function()
	-- We only can run this function if the file is modifiable
	if not vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
		return
	end
	if vim.fn.line("$") >= 7 then
		os.setlocale("en_US.UTF-8") -- show Sun instead of dom (portuguese)
		time = os.date("%a, %d %b %Y %H:%M")
		M.preserve("sil! keepp keepj 1,7s/\\vlast (modified|change):\\zs.*/ " .. time .. "/ei")
	end
end

-- vim.api.nvim_set_keymap('n', '<Leader>vs', '<Cmd>lua ReloadConfig()<CR>', { silent = true, noremap = true })
-- vim.cmd('command! ReloadConfig lua ReloadConfig()')

return M
