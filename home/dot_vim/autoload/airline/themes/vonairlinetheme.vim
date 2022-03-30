" My custome theme
" Based on 'understated' with lighter background color for inactive panes

let g:airline#themes#vonairlinetheme#palette = {}

let s:N1 = ['#FFFFFF', '#5F87FF', 15, 69]  " Outside blocks in normal mode (mode and file position)
let s:N2 = ['#AFAF87', '#5F5F5F', 144, 59] " Next blocks inside (branch and file format)
let s:N3 = ['#AFAF87', '#5F5F5F', 144, 59] " The middle block

let g:airline#themes#vonairlinetheme#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#vonairlinetheme#palette.normal_modified = {'airline_c': ['#ffffff', '#5f005f', 144, 59, 'bold'] ,}

let s:I1 = ['#FFFFFF', '#87AF5F', 15, 107] " Outside blocks in normal mode (mode and file position)
let s:I2 = ['#AFAF87', '#5F5F5F', 144, 59] " Next blocks inside (branch and file format)
let s:I3 = ['#AFAF87', '#5F5F5F', 144, 59] " The middle block
let g:airline#themes#vonairlinetheme#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#vonairlinetheme#palette.insert_modified = {'airline_c': ['#AFAF87', '#5F5F5F', 144, 59, 'bold'] ,}
let g:airline#themes#vonairlinetheme#palette.insert_paste = {'airline_c': ['#AFAF87', '#5F5F5F', 144, 59, ''] ,}

let g:airline#themes#vonairlinetheme#palette.replace = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#vonairlinetheme#palette.replace.airline_a = ['#FFFFFF', '#870000', 15, 88, '']
let g:airline#themes#vonairlinetheme#palette.replace_modified = {'airline_c': ['#AFAF87', '#5F5F5F', 144, 59, 'bold'] ,}

let s:V1 = ['#FFFFFF', '#AF5F00', 15, 130]
let s:V2 = ['#AFAF87', '#5F5F5F', 144, 59]
let s:V3 = ['#AFAF87', '#5F5F5F', 144, 59]
let g:airline#themes#vonairlinetheme#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#vonairlinetheme#palette.visual_modified = {'airline_c': [ '#AFAF87', '#5f005f', 144, 59, 'bold'] ,}

let s:V1 = ['#080808', '#FFAF00', 232, 214]
let s:IA1 = ['#AFAF87', '#5F5F5F', 144, 59]
let s:IA2 = ['#AFAF87', '#5F5F5F', 144, 59]
let s:IA3 = ['#AFAF87', '#5F5F5F', 144, 59]
let g:airline#themes#vonairlinetheme#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#vonairlinetheme#palette.inactive_modified = {'airline_c': ['#ffffff', '#5f005f', 144, 59, 'bold'] ,}

let g:airline#themes#vonairlinetheme#palette.accents = {'red': ['#FF0000', '', 88, '']}

if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#vonairlinetheme#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ ['#FFFFFF', '#1C1C1C', 15, 234, '' ],
      \ ['#FFFFFF', '#262626', 15, 235, '' ],
      \ ['#FFFFFF', '#303030', 15, 236, 'bold'])

