return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-web-devicons",
    event = "VeryLazy",

    config = function()
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

        local move_cursor_down = function()
          local nvim_tree_cache = vim.t.nvim_tree_cache
          local node = api.tree.get_node_under_cursor()
          local line = vim.api.nvim_win_get_cursor(0)[1]
          nvim_tree_cache.lines[node.parent.absolute_path] = line < vim.api.nvim_buf_line_count(0) and line + 1 or line
          vim.api.nvim_win_set_cursor(0, { nvim_tree_cache.lines[node.parent.absolute_path], 0 })
          vim.t.nvim_tree_cache = nvim_tree_cache
        end

        local move_cursor_up = function()
          local nvim_tree_cache = vim.t.nvim_tree_cache
          local node = api.tree.get_node_under_cursor()
          local line = vim.api.nvim_win_get_cursor(0)[1]
          nvim_tree_cache.lines[node.parent.absolute_path] = line > 2 and line - 1 or line
          vim.api.nvim_win_set_cursor(0, { nvim_tree_cache.lines[node.parent.absolute_path], 0 })
          vim.t.nvim_tree_cache = nvim_tree_cache
        end

        local move_cursor_top = function()
          local nvim_tree_cache = vim.t.nvim_tree_cache
          local node = api.tree.get_node_under_cursor()
          nvim_tree_cache.lines[node.parent.absolute_path] = 2
          vim.api.nvim_win_set_cursor(0, { nvim_tree_cache.lines[node.parent.absolute_path], 0 })
          vim.t.nvim_tree_cache = nvim_tree_cache
        end

        local move_cursor_bottom = function()
          local nvim_tree_cache = vim.t.nvim_tree_cache
          local node = api.tree.get_node_under_cursor()
          nvim_tree_cache.lines[node.parent.absolute_path] = vim.api.nvim_buf_line_count(0)
          vim.api.nvim_win_set_cursor(0, { nvim_tree_cache.lines[node.parent.absolute_path], 0 })
          vim.t.nvim_tree_cache = nvim_tree_cache
        end

        local change_root_to_node = function()
          if vim.api.nvim_buf_line_count(0) == 1 then
            return
          end
          local nvim_tree_cache = vim.t.nvim_tree_cache
          local node = api.tree.get_node_under_cursor()
          if node.type ~= "directory" then
            return
          end
          api.tree.change_root_to_node()
          if vim.api.nvim_buf_line_count(0) > 1 then
            if nvim_tree_cache.lines[node.absolute_path] == nil then
              vim.api.nvim_win_set_cursor(0, { 2, 0 })
            else
              vim.api.nvim_win_set_cursor(0, { nvim_tree_cache.lines[node.absolute_path], 0 })
            end
          end
          nvim_tree_cache.last_dir = node.absolute_path
          vim.t.nvim_tree_cache = nvim_tree_cache
        end

        local change_root_to_parent = function()
          local nvim_tree_cache = vim.t.nvim_tree_cache
          api.tree.change_root_to_parent()
          api.tree.find_file({
            buf = nvim_tree_cache.last_dir,
            focus = true,
          })
          api.tree.collapse_all()
          local node = api.tree.get_node_under_cursor()
          nvim_tree_cache.last_dir = node.parent.absolute_path
          local line = vim.api.nvim_win_get_cursor(0)[1]
          nvim_tree_cache.lines[nvim_tree_cache.last_dir] = line
          vim.t.nvim_tree_cache = nvim_tree_cache
        end

        Map("n", "j", move_cursor_down, opts("Down"))
        Map("n", "k", move_cursor_up, opts("Up"))
        Map("n", "gg", move_cursor_top, opts("Top"))
        Map("n", "G", move_cursor_bottom, opts("Bottom"))
        Map("n", "l", change_root_to_node, opts("move into node"))
        Map("n", "h", change_root_to_parent, opts("move to parent"))

        Map("n", "e", api.node.open.edit, opts("Open"))
        Map("n", "<cr>", api.node.open.edit, opts("Open"))
        Map("n", "E", api.node.open.vertical, opts("Open: Vertical Split"))
        Map("n", "o", api.node.run.system, opts("Run System"))

        Map("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
        Map("n", "y", api.fs.copy.filename, opts("Copy Name"))
        Map("n", "Y", api.fs.copy.absolute_path, opts("Copy Absolute Path"))

        Map("n", "<c-n>", api.fs.create, opts("Create"))
        Map("n", "<c-d>", api.fs.remove, opts("Delete"))
        Map("n", "<c-x>", api.fs.cut, opts("Cut"))
        Map("n", "<c-c>", api.fs.copy.node, opts("Copy"))
        Map("n", "<c-v>", api.fs.paste, opts("Paste"))
        Map("n", "<c-r>", api.fs.rename, opts("Rename"))

        Map("n", "q", api.tree.close, opts("Close"))
        Map("n", "<c-f>", api.tree.close, opts("Close"))
        Map("n", "<esc><esc>", api.tree.close, opts("Close"))
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
          root_folder_label = ":~:s?$?",
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
          row = (vim.o.lines - height) / 2,
          col = (vim.o.columns - width) / 2,
        }
        MergeTables(nvim_tree.get_config().view.float.open_win_config, open_win_config)
        vim.cmd("NvimTreeOpen")
        local nvim_tree_cache = vim.t.nvim_tree_cache
        if nvim_tree_cache == nil then
          nvim_tree_cache = {
            last_dir = vim.fn.getcwd(),
            lines = {},
          }
        end
        api.tree.change_root(nvim_tree_cache.last_dir)
        if nvim_tree_cache.lines[nvim_tree_cache.last_dir] == nil then
          nvim_tree_cache.lines[nvim_tree_cache.last_dir] = 2
        end
        vim.api.nvim_win_set_cursor(0, { nvim_tree_cache.lines[nvim_tree_cache.last_dir], 0 })
        vim.t.nvim_tree_cache = nvim_tree_cache
      end
      Map("n", "<c-f>", open_nvim_tree)
    end,
  },
}
