function Dump(object, depth)
  depth = depth or 0
  if depth > 5 then
    return "<<<overflow>>>"
  end
  if type(object) == "table" then
    local res = "{\n"
    for k, v in pairs(object) do
      if type(k) == "table" then
        k = "<<<table>>>"
      elseif type(k) ~= "number" then
        k = "'" .. k .. "'"
      end
      res = res .. string.rep("  ", depth + 1) .. "[" .. k .. "] = " .. Dump(v, depth + 1) .. ",\n"
    end
    return res .. string.rep("  ", depth) .. "}"
  else
    return tostring(object)
  end
end

function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end
