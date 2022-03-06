-- IMPORTANT NOTE : This is default config, so dont change anything here.

local M = {}

M.options = {
  -- general nvim/vim options, check :h optionname to know more about an option
  nvim = {
    title = true, -- recommended to not change
    clipboard = "unnamedplus",
    cmdheight = 1,
    cursorline = true, -- recommended to not change

    -- Indentline
    expandtab = true,
    shiftwidth = 2,
    smartindent = true,

    -- disable tilde on end of buffer
    fillchars = {eob = " "},
    hidden = true,
    ignorecase = true,
    smartcase = true,
    mouse = "a",

    -- Numbers
    number = true,
    numberwidth = 2,
    relativenumber = true,
    ruler = false,

    signcolumn = "yes", -- recommended to not change
    splitbelow = true, -- recommended to not change
    splitright = true, -- recommended to not change
    tabstop = 8, -- recommended to not change
    termguicolors = true, -- recommended to not change
    timeoutlen = 400,
    undofile = true,

    -- interval for writing swap file to disk, also used by gitsigns
    updatetime = 250,

    shadafile = "NONE"
  },
  
  -- alpha options
  alpha {
    copy_cut = true, -- copy cut text ( x key ), visual and normal mode
    copy_del = true, -- copy deleted text ( dd key ), visual and normal mode
    insert_nav = true, -- navigation in insertmode
    window_nav = true,
    terminal_numbers = false,

    -- updater
    update_url = "https://github.com/aditya612/AlphaNvim",
    update_branch = "main",
  }
}

return M
