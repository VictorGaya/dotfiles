return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>o", "<cmd>AerialToggle float<CR>", desc = "Toggle symbol outline" },
  },
  opts = {
    layout = {
      default_direction = "float",
      max_width = { 0.3, 45 },
      min_width = 30,
    },
    sources = { "lsp", "treesitter" },
    group_type = true,
    float = {
      relative = "editor",
      border = "rounded",
      height = 0.8,
      width = 40,
      override = function(conf)
        conf.row = 2
        conf.col = vim.o.columns - 42
        return conf
      end,
    },
  },
}
