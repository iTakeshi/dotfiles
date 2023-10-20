local tym = require("tym")

tym.set_config({
    autohide          = true,
    font              = "FantasqueSansM Nerd Font 13",
    scrollback_length = 10000,
    silent            = true,
    uri_schemes       = "http https file mailto git",
})

tym.set_keymaps({
  ["<Ctrl><Shift>Up"] = function()
      tym.set("scale", math.floor(tym.get("scale") * 1.1))
  end,
  ["<Ctrl><Shift>Down"] = function()
      tym.set("scale", math.floor(tym.get("scale") / 1.1))
  end,
})
