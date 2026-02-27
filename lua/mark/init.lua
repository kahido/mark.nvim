local M = {}

local colors = {
  { bg = '#cc6666' },
  { bg = '#b5bd68' },
  { bg = '#f0c674' },
  { bg = '#81a2be' },
  { bg = '#b294bb' },
  { bg = '#8abeb7' },
  { bg = '#c5c8c6' }
}

local cache = {}

local DefineHighlighting = function(aPalette)
  -- local command = isOverride and 'highlight' or 'highlight def'

  for i = 1, #aPalette do
    local group = 'markWord' .. i
    local paletteBg = aPalette[i].bg
    -- local cmd = command .. ' ' .. group .. ' guibg=' .. bg
    -- print(':> ' .. cmd)
    -- vim.cmd(cmd)
    vim.api.nvim_set_hl(0, group, { bg = paletteBg })
  end
end

M.setup = function()
  print("kahido mark.nvim plugin")
  DefineHighlighting(colors)
end

local empty = function(aString)
  return aString == nil or aString == ''
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

M.DoMark = function(aGroupNum, ...)
  local group = 'markWord' .. aGroupNum
  local mid = 1077 + aGroupNum

  local isRegexp = select('#', ...)
  if isRegexp > 0 then
    local regexp = select(1, ...)

    -- TODO search for regexp in State Machine
    if cache[regexp] ~= nil then
      local id = cache[regexp]
      print(': call matchdelete(' .. id .. ')')
      vim.fn.matchdelete(id)
      cache[regexp] = nil
    else
      print(': call matchadd(' .. group .. ', ' .. regexp .. ')')
      local id = vim.fn.matchadd(group, regexp)
      print(': cache(' .. regexp .. ' = ' .. id .. ')')
      cache[regexp] = id
    end

  end
end

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

  if groupNum == 0 then
    groupNum = 1 -- FIXME: select first free number
  end

  print('regexp [' .. regexp .. '] groupNum [' .. groupNum .. ']')

  if empty(regexp) then
    return 0
  else
    return M.DoMark(groupNum, regexp)
  end
end

return M
