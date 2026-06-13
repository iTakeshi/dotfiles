return {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = { enable = true },
      },
      checkOnSave = {
        allFeatures = true,
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"]     = { "async_trait" },
          ["napi-derive"]     = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
    },
  },
}
