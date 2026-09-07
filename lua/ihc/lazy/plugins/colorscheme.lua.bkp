-- local theme = "kanagawa"
-- local theme = "kanagawa-dragon"
-- local theme = "nightfox"
-- local theme = "dayfox"
local theme = "carbonfox"
-- local theme = "bluloco"

return {

  {
    "rebelot/kanagawa.nvim",
    lazy = not theme:match("^kanagawa"),
    priority = 1000,
    config = function()
      if theme:match("^kanagawa") then
        vim.cmd("colorscheme " .. theme)
      end
    end,
  },

  {
    "EdenEast/nightfox.nvim",
    lazy = not theme:match("fox"),
    priority = 1000,
    config = function()
      if theme:match("fox") then
        vim.cmd("colorscheme " .. theme)
      end
    end,
  },

  {
    "uloco/bluloco.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = theme ~= "bluloco",
    priority = 1000,
    config = function()
      if theme == "bluloco" then
        require("bluloco").setup({})
        vim.cmd("colorscheme bluloco")
      end
    end,
  },
}
