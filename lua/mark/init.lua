-- Plugin name:             mark.nvim
-- Description:             A Neovim plugin.
-- Author:                  Kahido
-- Website:                 https://github.com/kahido/mark.nvim

------- Global Variables

local cache_regexp_id = {}
local cache_id_regexp = {}

-- Default the highest match priority to -10, so that we do not override the 'hlsearch' of 0
local match_priority = -10

-- Base ID
local base_id = 1077

------- Local Functions

local defineHighlighting = function(aPalette, isDebug)
  for i = 1, #aPalette do
    local group = 'markWord' .. i
    local paletteFg = '#1d1f21'
    local paletteBg = aPalette[i].bg

    if isDebug then
      print('HIGHLIGHT fg = ' .. paletteFg .. ' bg = ' .. paletteBg)
    end

    vim.api.nvim_set_hl(0, group, { fg = paletteFg, bg = paletteBg })
  end
end

local empty = function(aString)
  return aString == nil or aString == ''
end

local getGroupNumber = function(aPalette)
  for i = 1, #aPalette do
    local mid = base_id + i
    if cache_id_regexp[mid] == nil then
      return i
    end
  end
  return 0
end

-- Plugin

local M = {
  DEBUG = false
}

M.setup = function(aOpts)
  local config = require('mark.config')

  config.set_options(aOpts)
  M.DEBUG = config.options.DEBUG

  if M.DEBUG then
    print("kahido mark.nvim plugin")
  end

  defineHighlighting(config.options.palette, M.DEBUG)
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

M.MarkClear = function()
  for mid,regexp in pairs(cache_id_regexp) do
    if M.DEBUG then
      print(': call matchdelete(' .. mid .. ')')
    end
    vim.fn.matchdelete(mid)
    cache_regexp_id[regexp] = nil
    cache_id_regexp[mid] = nil
  end
end

M.GetVisualSelection = function()
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
  local vstart = vim.fn.getpos("'<")
  local vend = vim.fn.getpos("'>")
  return table.concat(vim.fn.getregion(vstart, vend), "\n")
end

M.DoMark = function(aGroupNum, ...)
  local group = 'markWord' .. aGroupNum
  local mid = base_id + aGroupNum

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
      local id = vim.fn.matchadd(group, regexp, match_priority, mid)
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
      -- Escape special regex chars in word, then add word boundaries
      local escaped = vim.fn.escape(cword, [[\/.*^$?[]~]])
      regexp = "\\<" .. escaped .. "\\>"
      -- The star command only creates a \<whole word\> search pattern if the
      -- <cword> actually only consists of keyword characters.
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

M.MarkSelectedWord = function()
  local options = require('mark.config').options
  local groupNum = vim.v.count
  local regexp = M.GetVisualSelection()

  if empty(regexp) then
    return 0
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
