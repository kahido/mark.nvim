local M = {}

local colors = {
  { bg = '#5e81ac' },
  { bg = '#afd787' }
}

local DefineHighlighting = function(palette, isOverride)
  local command = isOverride and 'highlight' or 'highlight def'
  -- local highlightingNum = select('#', palette)

  -- print('DefineHighlighting num [' .. highlightingNum .. ']')

  -- for i = 1, highlightingNum do
  --   local group = 'markWord' .. i
  --   local bg = palette[i].bg
  --   local cmd = command .. ' ' .. group .. ' guibg=' .. bg
  --   print('call ' .. cmd)
  --   vim.cmd(cmd)
  -- end

  for i = 1, #palette do
    local group = 'markWord' .. i
    local bg = palette[i].bg
    local cmd = command .. ' ' .. group .. ' guibg=' .. bg
    print('call ' .. cmd)
    vim.cmd(cmd)
  end

end

M.setup = function()
  print("kahido mark.nvim plugin")
  DefineHighlighting(colors, true)
end

local empty = function(string)
  return string == nil or string == ''
end

-- local SetMark = function(index, regexp, ...)
--   SetPattern(index, regexp)
--   EnableAndMarkScope(index, regexp)
-- end

-- Return [success, markGroupNum]. success is true when the mark has been set or
-- cleared. markGroupNum is the mark group number where the mark was set. It is 0
-- if the group was cleared.
-- M.DoMark = function(argGroupNum, ...)
--
--   local groupNum = argGroupNum
--   -- if groupNum > M.markNum then
--   --   -- TODO
--   -- end
--
--   local count = select('#', ...)
--   local regexp = count and select(1, ...) or ''
--   if empty(regexp) then
--     if groupNum == 0 then
--       if count then
--         -- TODO prevent disable all marks; possible typo
--       end
--
--       -- Disable all marks.
--     else
--       -- Clear the mark represented by the passed highlightgroup number.
--     end
--   end
--
--   if groupNum == 0 then
--     local i = 0 -- FreeGroupIndex()
--     if i ~= -1 then
--       -- Choose an unused highlight group. The last search is kept untouched.
--     else
--       -- Choose a highlight group by cycle. A last search there is reset.
--     end
--   else
--     local i = groupNum - 1
--     -- Use and extend the passed highlight group. A last search is updated
--     -- and thereby kept alive.
--   end
-- end

M.MarkCurrentWord = function()
  local groupNum = vim.v.count
  local regexp = ''

  if empty(regexp) then
    local cword = vim.fn.expand("<cword>")
    if not empty(cword) then
      regexp = cword -- escape any special character from 'cword'
      -- The star command only creates a \<whole word\> search pattern if the
      -- <cword> actually only consists of keyword characters.
      -- TODO[] match cword with regular expresion
    end
  end

  print('regexp [' .. regexp .. '] groupNum [' .. groupNum .. ']')

  if empty(regexp) then
    return 0
  else
    return 0 --M.DoMark(groupNum)
  end
end


return M
