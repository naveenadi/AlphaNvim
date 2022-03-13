local utils = require("alpha.core.utils")

local vim = vim

-- map helper functions
function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- map the leader key
map("n", "<Space>", "", {})
vim.g.mapleader = " " -- 'vim.g' sets global variables
-- Neovim

-- Clear search highlighting with <leader> and c
map("n", "<leader>c", ":nohl<CR>")

-- Map Esc to kk
map("i", "kk", "<Esc>")

-- Don't use arrow keys
-- map("", "<up>", "<nop>")
-- map("", "<down>", "<nop>")
-- map("", "<left>", "<nop>")
-- map("", "<right>", "<nop>")

-- Fast saving with <leader> and s
map("n", "<leader>s", ":w<CR>")
map("i", "<leader>s", "<C-c>:w<CR>")

-- Move around splits using Ctrl + {h,j,k,l}
-- map("n", "<C-h>", "<C-w>h")
-- map("n", "<C-j>", "<C-w>j")
-- map("n", "<C-k>", "<C-w>k")
-- map("n", "<C-l>", "<C-w>l")

-- Close all windows and exit from Neovim with <leader> and q
map("n", "<leader>q", ":qa!<CR>")

-- Tab to switch buffers in Normal mode
map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprevious<CR>")

map("", "<leader>c", '"+y') -- Copy to clipboard in normal, visual, select and operator modes
map("i", "<C-u>", "<C-g>u<C-u>") -- Make <C-u> undo-friendly
map("i", "<C-w>", "<C-g>u<C-w>") -- Make <C-w> undo-friendly

map("n", "<C-l>", "<cmd>noh<CR>") -- Clear highlights
map("n", "<leader>o", "m`o<Esc>``") -- Insert a newline in normal mode

map("n", "<c-s-t>", "<cmd>lua require('alpha.core.utils').toggle_transparency()<br>") -- toggle transparency
