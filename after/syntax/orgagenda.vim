" Conceal the agenda category column (the leading "<category>:" plus its padding,
" e.g. "meeting:  "), so items line up at the indent without the category word.
" org renders it with no highlight of its own; the ^\s\+ anchor + \zs match only
" the leading column, never a mid-line time like 10:30. conceallevel/concealcursor
" are set in after/ftplugin/orgagenda.lua. To DIM instead of hide, drop `conceal`
" here and recolor :hi OrgAgendaCategory.
syntax match OrgAgendaCategory /^\s\+\zs\S\+:\s*/
highlight default link OrgAgendaCategory Comment
