local _nvim_tree_node_cache = {}

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-web-devicons",
    event = "VeryLazy",

    config = function()
      -- TODO: memorize tab-wise state
      local api = require("nvim-tree.api")
      local nvim_tree = require("nvim-tree")

      local on_attach = function(bufnr)
        local opts = function(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end
        local change_root_to_node = function()
          local node = api.tree.get_node_under_cursor()
          api.tree.change_root_to_node()
          local line = _nvim_tree_node_cache[node.absolute_path]
          if line ~= nil then
            vim.api.nvim_win_set_cursor(0, { line, 0 })
          end
        end
        local change_root_to_parent = function()
          local line = vim.api.nvim_win_get_cursor(0)[1]
          api.tree.change_root_to_parent()
          local cursor = vim.api.nvim_win_get_cursor(0)
          cursor[1] = cursor[1] - line + 1
          vim.api.nvim_win_set_cursor(0, cursor)
          api.tree.collapse_all()
          _nvim_tree_node_cache[api.tree.get_node_under_cursor().absolute_path] = line
        end
        vim.keymap.set("n", "e", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<cr>", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "E", api.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "o", api.node.run.system, opts("Run System"))
        vim.keymap.set("n", "l", change_root_to_node, opts("move into node"))
        vim.keymap.set("n", "h", change_root_to_parent, opts("move to parent"))
        vim.keymap.set("n", "t", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
        vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
        vim.keymap.set("n", "Y", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
        vim.keymap.set("n", "<c-n>", api.fs.create, opts("Create"))
        vim.keymap.set("n", "<c-d>", api.fs.remove, opts("Delete"))
        vim.keymap.set("n", "<c-x>", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "<c-c>", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "<c-v>", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "<c-r>", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "q", api.tree.close, opts("Close"))
        vim.keymap.set("n", "<c-f>", api.tree.close, opts("Close"))
        vim.keymap.set("n", "<esc><esc>", api.tree.close, opts("Close"))
      end

      nvim_tree.setup({
        git = { enable = false },
        remove_keymaps = true,
        view = {
          float = { enable = true },
        },
        on_attach = on_attach,
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
