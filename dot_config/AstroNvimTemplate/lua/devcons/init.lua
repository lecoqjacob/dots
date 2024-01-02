-- https://github.com/microsoft/vscode/blob/main/src/vs/base/common/codicons.ts
-- go to the above and then enter <c-v>u<unicode> and the symbold should appear
-- or go here and upload the font file: https://mathew-kurian.github.io/CharacterMap/
-- find more here: https://www.nerdfonts.com/cheat-sheet

---@enum (key) Devcons
local icons = {
  --! General
  ArrowClosed = "",
  ArrowLeft = "",
  ArrowOpen = "",
  ArrowRight = "",
  Bookmarks = "",
  BufferClose = "󰅖",
  Calendar = "",
  Check = "",
  Clock = "",
  Circle = " ",
  Dots = "󰇘",
  Ellipsis = "…",
  Environment = "",
  Event = "",
  Gear = "",
  Heart = " ",
  Keyboard = "",
  MacroRecording = "",
  Note = "",
  NeoVim = "",
  Paste = "󰅌",
  Power = "",
  Refresh = "",
  Search = "",
  Selected = "❯",
  Session = "󱂬",
  Sort = "󰒺",
  SourceCode = "",
  Sparkle = "",
  Spellcheck = "󰓆",
  Tab = "󰓩",
  TabClose = "󰅙",
  Telescope = "",
  Terminal = "",
  Tree = "",
  Window = "",
  WordFile = "󰈭",

  --! Debug
  DapBreakpoint = "",
  DapBreakpointCondition = "",
  DapBreakpointRejected = "",
  DapLogPoint = ".>",
  DapStopped = "󰁕",
  Debugger = "",

  --! Diagnostic
  Diagnostic = "󰒡",
  DiagnosticError = "",
  DiagnosticHint = "󰌵",
  DiagnosticInformation = "󰋼",
  DiagnosticQuestion = "",
  DiagnosticWarning = "",

  --! Files
  DefaultFile = "󰈙",
  File = "",
  FileEmpty = "",
  FileImport = "",
  FileModified = "",
  FileNew = "",
  FileReadOnly = "",
  FileSymLink = "",
  Files = "",

  --! Folders
  FoldClosed = "",
  FoldOpened = "",
  FoldSeparator = " ",
  Folder = "",
  FolderClosed = "",
  FolderEmpty = "",
  FolderOpen = "",
  FolderSymlink = "",
  FolderSymlinkOpen = "",
  OpenFolder = "",
  OpenFolderEmpty = "",

  --! GIT
  Git = "󰊢",
  GitAdd = "",
  GitBranch = "",
  GitChange = "",
  GitConflict = "",
  GitDelete = "",
  GitIgnored = "◌",
  GitRemoved = "",
  GitRemovedAlt = "",
  GitRenamed = "",
  GitSign = "▎",
  GitStaged = "",
  GitUnmerged = "",
  GitUnstaged = "✗",
  GitUntracked = "★",

  --! Language
  ActiveLSP = "",
  ActiveTS = "",
  LSPLoading1 = "",
  LSPLoading2 = "󰀚",
  LSPLoading3 = "",

  --! Lazy
  Lazy = "󰒲",
  LazyInit = "",
  LazyRequire = "󰢱",
  LazyStart = "",
  LazyUnloaded = "",

  --! Packages
  Package = "󰏖",
  PackageLoaded = "",
  PackagePending = "",
  PackageUninstalled = "󰚌",
}

--- Get an icon from the AstroNvim internal icons if it is available and return it
---@param kind Devcons The kind of icon in astroui.icons to retrieve
---@param padding? integer Padding to add to the end of the icon
---@param wrap_icon? boolean Whether or not to disable fallback to text icon
---@param fallback? boolean Fallback to text icon if icon is not found
---@return string icon
icons.get = function(kind, padding, wrap_icon, fallback)
  wrap_icon = wrap_icon or false
  local icon = require("astroui").get_icon(kind, padding or 1, fallback)
  if icon ~= "" and wrap_icon then return (" "):rep(padding or 0) .. icon end
  return icon
end

--- Get an icon from the AstroNvim internal icons if it is available and return it
---@param kind Devcons The kind of icon in astroui.icons to retrieve
---@param padding? integer Padding to add to the end of the icon
---@return string icon
icons.get_wrapped = function(kind, padding) return icons.get(kind, padding, true) end

return icons
