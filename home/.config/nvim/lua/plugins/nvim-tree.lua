return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      -- TODO: memorize tab-wise state
      local api = require("nvim-tree.api")
      local nvim_tree = require("nvim-tree")
      nvim_tree.setup({
        git = { enable = false },
        remove_keymaps = true,
        view = {
          float = { enable = true },
          mappings = {
            list = {
              { key = { "e", "<cr>" }, action = "edit" }, -- TODO: `drop` behavior
              { key = "E", action = "vsplit" }, -- TODO: disable window picker
              { key = "o", action = "system_open" },
              { key = "l", action = "move into node", action_cb = api.tree.change_root_to_node },
              {
                key = "h",
                action = "move to parent",
                action_cb = function()
                  local line = vim.api.nvim_win_get_cursor(0)[1]
                  api.tree.change_root_to_parent()
                  api.tree.collapse_all()
                  local cursor = vim.api.nvim_win_get_cursor(0)
                  cursor[1] = cursor[1] - line + 1
                  vim.api.nvim_win_set_cursor(0, cursor)
                end,
              },
              { key = "t", action = "edit" },
              { key = "H", action = "toggle_dotfiles" },
              { key = "y", action = "copy_name" },
              { key = "Y", action = "copy_absolute_path" },
              { key = "<c-n>", action = "create" },
              { key = "<c-d>", action = "remove" },
              { key = "<c-x>", action = "cut" },
              { key = "<c-c>", action = "copy" },
              { key = "<c-v>", action = "paste" },
              { key = "<c-r>", action = "rename" },
              { key = "q", action = "close" },
              { key = "<c-f>", action = "close" },
              { key = "<esc><esc>", action = "close" },
            },
          },
        },
        renderer = {
          add_trailing = true,
          highlight_opened_files = "icon",
          highlight_modified = "name",
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
      })
      local open_nvim_tree = function()
        local width = vim.fn.min({ vim.o.columns - 30, 120 })
        local height = vim.fn.min({ vim.o.lines - 8, 50 })
        local open_win_config = {
          width = width,
          height = height,
          row = (vim.o.lines - height) / 2 - 2,
          col = (vim.o.columns - width) / 2,
        }
        MergeTables(nvim_tree.get_config().view.float.open_win_config, open_win_config)
        vim.cmd("NvimTreeOpen")
      end
      Map("n", "<c-f>", open_nvim_tree)
    end,
  },
}
