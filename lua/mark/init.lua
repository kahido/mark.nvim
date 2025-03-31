local M = {}

local empty = function(string)
  return string == nil or string == ''
end

M.MarkCurrentWord = function()
  -- local markWholeWordOnly = false
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
end

M.setup = function()
  print("kahido mark.nvim plugin")
  M.MarkCurrentWord()
end

return M
