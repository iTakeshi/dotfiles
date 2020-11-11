local tym = require("tym")

tym.set_config({
    autohide          = true,
    font              = "FantasqueSansMono Nerd Font 13",
    scrollback_length = 10000,
    silent            = true,
    uri_schemes       = "http https file mailto git git+https",
})

tym.set_keymaps({
  ["<Ctrl><Shift>Up"] = function()
      tym.set("scale", tym.get("scale") + 20)
  end,
  ["<Ctrl><Shift>Down"] = function()
      tym.set("scale", tym.get("scale") - 20)
  end,
})
