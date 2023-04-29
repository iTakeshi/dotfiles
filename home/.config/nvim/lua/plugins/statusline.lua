return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-web-devicons",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "sonokai",
      },
    },
  },

  {
    "nanozuki/tabby.nvim",
    config = function()
      local theme = {
        fill = "TabLineFill",
        cur = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
      }
      require("tabby.tabline").set(function(line)
        return {
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.cur or theme.tab
            return {
              line.sep("", hl, theme.fill),
              tab.is_current() and "" or "",
              tab.number(),
              tab.name(),
              line.sep(" ", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
              line.sep(" ", theme.win, theme.fill),
              win.is_current() and "" or "",
              win.buf_name(),
              line.sep("", theme.win, theme.fill),
              hl = theme.win,
              margin = " ",
            }
          end),
        }
      end)
    end,
  },
}
