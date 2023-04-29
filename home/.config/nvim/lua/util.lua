function Dump(object, max_depth, depth)
  max_depth = max_depth or 3
  depth = depth or 0
  if depth > max_depth then
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
      res = res .. string.rep("  ", depth + 1) .. "[" .. k .. "] = " .. Dump(v, max_depth, depth + 1) .. ",\n"
    end
    return res .. string.rep("  ", depth) .. "}"
  else
    return tostring(object)
  end
end

-- recursively merge two tables, overwriting `dst`'s fields with `src`'s fields
function MergeTables(dst, src)
  for k, v in pairs(src) do
    if type(v) == "table" and type(dst[k]) == "table" then
      MergeTables(dst[k], v)
    else
      dst[k] = v
    end
  end
  return dst
end

function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end
