local config = {}

-- default options
config.options = {

  -- Changing Colors --
  palette = {
    { bg = '#8ccbea' },
    { bg = '#a4e57e' },
    { bg = '#ffd872' },
    { bg = '#ff7272' },
    { bg = '#ffb3ff' },
    { bg = '#9999ff' },
    { bg = '#c5c8c6' }
  },

  -- Development
  DEBUG = false,
}

config.set_options = function(aOpts)
  config.options = vim.tbl_deep_extend("force", config.options, aOpts or {})
end

return config
