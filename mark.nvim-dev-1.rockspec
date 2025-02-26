package = "mark.nvim"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/kahido/mark.nvim.git"
}
description = {
   detailed = "Neovim plugin template; includes automatic documentation generation from README, integration tests with Busted, and linting with Stylua",
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      ["mark.init"] = "lua/mark/init.lua"
   },
   copy_directories = {
      "doc"
   }
}
