-- Bold "Gräler, B." in all bibliography entries.
local function highlight(inlines)
  local out = pandoc.List()
  local i = 1
  while i <= #inlines do
    local a, b, c = inlines[i], inlines[i + 1], inlines[i + 2]
    if a.t == "Str" and a.text == "Gräler," and b and b.t == "Space"
        and c and c.t == "Str" and c.text:match("^B%.") then
      local initial, rest = c.text:match("^(B%.)(.*)$")
      out:insert(pandoc.Strong({ pandoc.Str("Gräler,"), pandoc.Space(), pandoc.Str(initial) }))
      if rest ~= "" then out:insert(pandoc.Str(rest)) end
      i = i + 3
    else
      out:insert(a)
      i = i + 1
    end
  end
  return out
end

-- Show bare (non-DOI) URLs as a short "link" label.
local function shorten(link)
  local text = pandoc.utils.stringify(link.content)
  if text == link.target and not link.target:match("^https://doi%.org/") then
    link.content = { pandoc.Str("link") }
    return link
  end
end

function Div(div)
  if div.classes:includes("csl-entry") then
    return div:walk({ Inlines = highlight, Link = shorten })
  end
end
