-- Plugin name:             mark.nvim
-- Description:             A Neovim plugin.
-- Author:                  Kahido
-- Website:                 https://github.com/kahido/mark.nvim

local M = {
  DEBUG = false
}

-- Global Variables

local cache_regexp_id = {}
local cache_id_regexp = {}

-- Local Functions

local defineHighlighting = function(aPalette)
  for i = 1, #aPalette do
    local group = 'markWord' .. i
    local paletteBg = aPalette[i].bg
    print('Set palette = ' .. paletteBg)
    vim.api.nvim_set_hl(0, group, { fg = '#1d1f21', bg = paletteBg })
  end
end

local empty = function(aString)
  return aString == nil or aString == ''
end

local getGroupNumber = function(aPalette)
  for i = 1, #aPalette do
    local mid = 1077 + i
    if cache_id_regexp[mid] == nil then
      return i
    end
  end
  return 0
end

-- Plugin

M.setup = function(aOpt)
  local config = require('mark.config')
  config.set_options(aOpt)

  M.DEBUG = aOpt.DEBUG

  print('Set variable DEBUG = ' .. tostring(M.DEBUG))

  if M.DEBUG then
    print("kahido mark.nvim plugin")
  end

  defineHighlighting(config.options.palette)
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

    if cache_regexp_id[regexp] ~= nil then
      local id = cache_regexp_id[regexp]
      if M.DEBUG then
        print(': call matchdelete(' .. id .. ')')
      end
      vim.fn.matchdelete(id)
      if M.DEBUG then
        print(': cache_regexp_id(' .. regexp .. ' = ' .. id .. ')')
      end
      cache_regexp_id[regexp] = nil
      cache_id_regexp[id] = nil
    else
      if cache_id_regexp[mid] ~= nil then
        if M.DEBUG then
          print(': call matchdelete(' .. mid .. ')')
        end
        vim.fn.matchdelete(mid)
      end
      if M.DEBUG then
        print(': call matchadd(' .. group .. ', ' .. regexp .. ')')
      end
      local id = vim.fn.matchadd(group, regexp, 10, mid)
      if M.DEBUG then
        print(': cache_regexp_id(' .. regexp .. ' = ' .. id .. ')')
      end
      cache_regexp_id[regexp] = id
      cache_id_regexp[id] = regexp
    end
  end
end

M.MarkCurrentWord = function()
  local options = require('mark.config').options
  local groupNum = vim.v.count
  local regexp = '' -- TODO: get regexp from command

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
    groupNum = getGroupNumber(options.palette)
  end

  if M.DEBUG then
    print('regexp [' .. regexp .. '] groupNum [' .. groupNum .. ']')
  end

  if groupNum == 0 then
    return 0
  else
    return M.DoMark(groupNum, regexp)
  end
end

return M
