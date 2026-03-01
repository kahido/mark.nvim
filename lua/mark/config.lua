local config = {}

-- default options
config.options = {

  -- Changing Colors --
  palette = {
    { bg = '#cc6666' },
    { bg = '#b5bd68' },
    { bg = '#f0c674' },
    { bg = '#81a2be' },
    { bg = '#b294bb' },
    { bg = '#8abeb7' },
    { bg = '#c5c8c6' }
  },

  -- Development
  DEBUG = false,
}

function config.set_options(opts)
  config.options = vim.tbl_deep_extend("force", config.options, opts or {})
end

return config
