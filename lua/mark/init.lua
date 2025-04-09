local M = {}

local empty = function(string)
  return string == nil or string == ''
end

M.DoMark = function(groupNum)
  -- TODO
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
