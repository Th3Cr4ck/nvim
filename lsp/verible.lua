-- ~/.config/nvim/lsp/verible.lua

local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
  cmd = { 
    "verible-verilog-ls",
    "--rules_config=/home/isaac/.config/verible/rules.verible_lint"
  },

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
