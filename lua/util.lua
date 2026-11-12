-- scrape every heap off the board
function clear_palette()
  local names = {}
  for line in string.gmatch(palette(), "[^\n]+") do
    local n = string.match(line, "^%s*%d+%. (.-): ")
    if n then n = string.gsub(n, " %(.-%)$", ""); names[#names + 1] = n end
  end
  if #names > 0 then palette{scrape=names} end
  return #names
end
