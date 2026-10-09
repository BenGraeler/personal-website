-- Render one bibliography per Div `#refs-<name>`, taking the entries from
-- the file given as `grouped-bibliographies: { <name>: file.bib }`.
-- All entries are listed (nocite @*), sorted by the given CSL style.

local stringify = pandoc.utils.stringify
local meta

local function bibliography_for(name)
  local files = meta["grouped-bibliographies"]
  if not files or not files[name] then return nil end
  local m = pandoc.Meta({
    bibliography = stringify(files[name]),
    csl = meta.csl and stringify(meta.csl) or nil,
    nocite = pandoc.MetaInlines({ pandoc.Cite({ pandoc.Str("@*") },
      { pandoc.Citation("*", "AuthorInText") }) }),
    ["link-bibliography"] = true,
  })
  local refs = pandoc.Div({}, pandoc.Attr("refs"))
  local res = pandoc.utils.citeproc(pandoc.Pandoc({ refs }, m))
  for _, blk in ipairs(res.blocks) do
    if blk.t == "Div" and blk.identifier == "refs" then return blk end
  end
end

return {
  { Meta = function(m) meta = m end },
  {
    Div = function(div)
      local name = div.identifier:match("^refs%-([%w_-]+)$")
      if not name then return nil end
      local refs = bibliography_for(name)
      if not refs then return nil end
      div.content = refs.content
      div.classes:insert("references")
      div.classes:insert("csl-bib-body")
      return div
    end,
  },
}
