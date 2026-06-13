return {
  settings = {
    python = {
      pythonPath = (function()
        local python_path = "python"
        if vim.fn.filereadable(".venv/bin/activate") == 1 then
          python_path = ".venv/bin/python"
        end
        local virtual_env = os.getenv("VIRTUAL_ENV")
        if virtual_env then
          python_path = string.format("%s/bin/python", virtual_env)
        end
        return python_path
      end)(),
      analysis = {
        typeCheckingMode = "basic",
        autoImportCompletions = true,
      },
    },
  },
}
