-- ~/.config/nvim/lsp/verible.lua

local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
  cmd = { "verible-verilog-ls" },

  filetypes = {
    "verilog",
    "systemverilog",
  },

  root_markers = {
    ".git",
    "verible.filelist",
    "compile_commands.json",
  },

  capabilities = capabilities,
}
