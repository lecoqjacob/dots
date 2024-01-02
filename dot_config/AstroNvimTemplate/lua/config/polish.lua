-- This file is automatically ran last in the setup process and is a good place to configure
-- augroups/autocommands and custom filetypes also this just pure lua so
-- anything that doesn't fit in the normal config locations above can go here

vim.filetype.add({
  extension = {
    mdx = "markdown.mdx",
    qmd = "markdown",
  },
  filename = {
    [".eslintrc.json"] = "jsonc",
  },
  pattern = {
    ["tsconfig*.json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
  },
})
