return {
  name = "git-blame.nvim",
  url = "git@github.com:Carter-Apas/gitblame-nvim.git",
  cmd = {
    "GitBlameToggle",
    "GitBlameEnable",
    "GitBlameDisable",
    "GitBlameOpenCommitURL",
    "GitBlameOpenFileURL",
    "GitBlameCopySHA",
    "GitBlameCopyCommitURL",
    "GitBlameCopyFileURL",
  },
  keys = {
    { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle git blame" },
  },
  opts = {
    enabled = false,
    message_template = " <summary> • <date> • <author> • <<sha>>",
    date_format = "%m-%d-%Y %H:%M:%S",
    virtual_text_column = 1,
  },
}
