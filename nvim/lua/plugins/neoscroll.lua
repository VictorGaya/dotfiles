return {
  "karb94/neoscroll.nvim",
  config = function()
    require("neoscroll").setup({
      easing_function = "sine",
      duration_multiplier = 0.8,
      hide_cursor = true,
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" },
      stop_eof = true,
    })

    local ns = require("neoscroll")
    vim.keymap.set("n", "J", function() ns.scroll(5, { move_cursor = true, duration = 100 }) end, { desc = "Move down 5 lines animated" })
    vim.keymap.set("n", "K", function() ns.scroll(-5, { move_cursor = true, duration = 100 }) end, { desc = "Move up 5 lines animated" })
  end,
}
