-- IMPORTANT NOTE : This is default config, so dont change anything here.
-- use custom/alpharc.lua instead

local M = {}

-- OPT
M.options = { -- general nvim/vim options, check :h optionname to know more about an option
	-- Indentation
	autoindent = true, -- take indent for new line from previous line
	expandtab = true, -- use spaces when <Tab> is inserted
	shiftround = true, -- round indent to multiple of shiftwidth
	shiftwidth = 2, -- number of spaces to use for (auto)indent step
	tabstop = 2, -- number of spaces that <Tab> in file uses

	-- Search
	ignorecase = true, -- ignore case in search patterns
	smartcase = true, -- no ignore case when pattern has uppercase

	-- Text Rendering
	-- scrolloff = 4, -- minimum nr. of lines above and below cursor
	-- sidescrolloff = 8, -- minimum number of columns to scroll horizontal
	-- wrap = false, -- long lines wrap and continue on the next line

	-- User interfaces
	ruler = false, -- show cursor line and column in the status line
	cursorline = true, -- highlight the screen line of the cursor
	number = true, -- print the line number in front of each line
	relativenumber = true, -- show relative line number in front of each line
	mouse = "a", -- enable the use of mouse clicks
	title = true, -- let Vim set the title of the window

	-- Miscellaneous
	hidden = true, -- don't unload buffer when it is YXXYabandon|ed

	clipboard = "unnamedplus", -- use the clipboard as the unnamed register
	cmdheight = 1, -- number of lines to use for the command-line
	smartindent = true, -- smart autoindenting for C programs
	fillchars = { eob = " " }, -- disable tilde on end of buffer
	listchars = { eol = "↲", tab = "▸ ", trail = "·" },
	numberwidth = 2, -- number of columns used for the line number
	signcolumn = "yes", -- when and how to display the sign column
	splitbelow = true, -- new window from split is below the current one
	splitright = true, -- new window is put right of the current one
	termguicolors = true, -- enable 24-bit RGB color
	timeoutlen = 400, -- time out time in milliseconds
	undofile = true, -- save undo information in a file
	updatetime = 250, -- after this many milliseconds flush swap file
	shadafile = vim.opt.shadafile,
	completeopt = { "menu", "menuone", "noinsert", "noselect" }, --  options for Insert mode completion
	joinspaces = false, -- two spaces after a period with a join command
	list = false, -- show <Tab> and <EOL>
	-- wildmode = { "list:longest" }, -- mode for 'wildchar' command-line expansion

	swapfile = true, -- don't use swapfile
	showmatch = true, -- highlight matching parentheses
	foldmethod = "marker", -- enable folding (default 'foldmarker')
	colorcolumn = "80", -- line length marker at 80 colums
	linebreak = true, --wrap on word boundary
	history = 100, -- remeber N lines in history
	lazyredraw = true, -- faster scrollong
	synmaxcol = 240, -- max column for syntax highlighting
}

-- UI
M.ui = {}

-- AUTOCMDS
M.autocmds = {
	reload_vimrc = {
		-- Reload vim config automatically
		-- {"BufWritePost",[[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]]};
		{ "BufWritePre", "$MYVIMRC", "lua require('alpha.core.utils').ReloadConfig()" },
	},
	-- change_header = {
	-- 	{ "BufWritePre", "*", "lua require('tools').changeheader()" },
	-- },
	packer = {
		{ "BufWritePost", "plugins.lua", "PackerCompile" },
	},
	terminal_job = {
		{ "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] },
		{ "TermOpen", "*", "startinsert" },
		{ "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" },
	},
	restore_cursor = {
		{ "BufRead", "*", [[call setpos(".", getpos("'\""))]] },
	},
	save_shada = {
		{ "VimLeave", "*", "wshada!" },
	},
	resize_windows_proportionally = {
		{ "VimResized", "*", ":wincmd =" },
	},
	toggle_search_highlighting = {
		{ "InsertEnter", "*", "setlocal nohlsearch" },
	},
	lua_highlight = {
		{ "TextYankPost", "*", [[silent! lua vim.highlight.on_yank() {higroup="IncSearch", timeout=400}]] },
	},
	ansi_esc_log = {
		{ "BufEnter", "*.log", ":AnsiEsc" },
	},
	flash_cursor_line = {
		{ "WinEnter", "*", [[lua require('alpha.core.utils').flash_cursorline()]] },
	},
}

-- UTILS
M.utils = {
	-- alpha options
	alpha = {
		copy_cut = true, -- copy cut text ( x key ), visual and normal mode
		copy_del = true, -- copy deleted text ( dd key ), visual and normal mode
		insert_nav = true, -- navigation in insertmode
		window_nav = true,
		terminal_numbers = false,

		-- updater
		update_url = "https://github.com/aditya612/AlphaNvim",
		update_branch = "main",
	},
}

return M
