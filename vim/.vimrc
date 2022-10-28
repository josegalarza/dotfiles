" Save this on ~/.vimrc

" View
set number     " Show line numbers
syntax on      " Enable syntax highlight
set tabstop=4  " Set tab width to 4 columns.
set expandtab  " Use space characters instead of tabs.

" Search
set ignorecase  "Ignore capital letters during search.
set incsearch   "While searching though a file incrementally highlight matching characters as you type.

" Mode
set wildmenu               "enable auto completion menu after pressing TAB
set wildmode=list:longest  "Make wildmenu behave like similar to Bash completion.
