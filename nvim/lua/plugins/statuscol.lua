local M = {}

M.Setup = function()
  local builtin = require("statuscol.builtin")
  require("statuscol").setup({
    relculright = true,
    segments = {
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      {
        sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
        click = "v:lua.ScSa"
      },
      { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
      { text = { " " },              click = "v:lua.ScLa", },
      { text = { "%s" },             click = "v:lua.ScSa" },
    }
  })

end

return M
