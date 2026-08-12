return {
  "nvim-mini/mini.files",
  version = false,
  keys = {
    {
      "<leader>e",
      function()
        local MiniFiles = require("mini.files")

        if MiniFiles.close() ~= nil then
          return
        end

        local cwd = vim.fn.getcwd()
        local file_path = vim.fn.expand("%:p")

        MiniFiles.open(cwd, false, {
          windows = { preview = false, max_number = 1 },
        })

        if file_path ~= "" then
          local file_dir = vim.fn.fnamemodify(file_path, ":h")
          if file_dir == cwd or vim.startswith(file_dir, cwd .. "/") then
            local rel = vim.fn.fnamemodify(file_dir, ":.")
            if rel ~= "." then
              local branch = { cwd }
              local ok = true
              for _, part in ipairs(vim.split(rel, "/")) do
                local next_path = branch[#branch] .. "/" .. part
                if vim.fn.isdirectory(next_path) == 0 then
                  ok = false
                  break
                end
                table.insert(branch, next_path)
              end
              if ok then
                MiniFiles.set_branch(branch, { depth_focus = #branch })
              end
            end
          end
        end
      end,
      desc = "Toggle mini.files explorer",
    },
  },
  config = function()
    require("mini.files").setup({})

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set("n", "<CR>", function()
          require("mini.files").go_in({ close_on_file = true })
          vim.cmd("nohlsearch")
        end, { buffer = buf_id, desc = "Go in (close on file)" })
        vim.keymap.set("n", "<Esc>", function()
          local state = require("mini.files").get_explorer_state()
          if not state then return end
          if state.depth_focus and state.depth_focus > 1 then
            require("mini.files").go_out()
          else
            require("mini.files").close()
          end
        end, { buffer = buf_id, desc = "Go out or close" })
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesWindowOpen",
      callback = function(args)
        local win_id = args.data.win_id
        if not (win_id and vim.api.nvim_win_is_valid(win_id)) then
          return
        end

        local width = math.floor(vim.o.columns * 0.55)
        local height = math.floor(vim.o.lines * 0.75)

        vim.api.nvim_win_set_config(win_id, {
          relative = "editor",
          width = width,
          height = height,
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          style = "minimal",
          border = "rounded",
        })
      end,
    })
  end,
}
