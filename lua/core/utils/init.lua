local M = {}

M.load_config = function()
  local conf = require "core.defaults"
  local initrcExists,
    change = pcall(require, "custom.initrc")

  -- if initrc exists , then merge its table into the default config's

  if initrcExists then
    conf = vim.tbl_deep_extend("force", conf, change)
  end

  return conf
end

return M
