local M = {
  markNum = 0
}

local empty = function(string)
  return string == nil or string == ''
end

-- Return [success, markGroupNum]. success is true when the mark has been set or
-- cleared. markGroupNum is the mark group number where the mark was set. It is 0
-- if the group was cleared.
M.DoMark = function(argGroupNum, ...)
  -- TODO

  if M.markNum <= 0 then
    -- TODO
  end

  local groupNum = argGroupNum
  if groupNum > M.markNum then
    -- TODO
  end

  local count = select('#', ...)
  local regexp = count and select(1, ...) or ''
  if empty(regexp) then
    if groupNum == 0 then
      if count then
        -- TODO prevent disable all marks; possible typo
      end

      -- Disable all marks.
    else
      -- Clear the mark represented by the passed highlightgroup number.
    end
  end

  if groupNum == 0 then
    local i = 0 -- FreeGroupIndex()
    if i ~= -1 then
      -- Choose an unused highlight group. The last search is kept untouched.
    else
      -- Choose a highlight group by cycle. A last search there is reset.
    end
  else
    local i = groupNum - 1
    -- Use and extend the passed highlight group. A last search is updated
    -- and thereby kept alive.
  end
end

M.SetMark = function(argGroupNum, ...)

end

M.MarkCurrentWord = function()
  -- local markWholeWordOnly = false
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

  print('found regexp [' .. regexp .. ']')

  if empty(regexp) then
    return 0
  else
    return M.DoMark(groupNum)
  end
end

M.setup = function()
  print("kahido mark.nvim plugin")
end

return M
