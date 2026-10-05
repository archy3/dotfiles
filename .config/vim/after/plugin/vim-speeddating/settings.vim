if !exists('g:loaded_speeddating') || !g:loaded_speeddating
  finish
endif

" Cycle through Monday, Tuesday, Wednesday, ..., Sunday:
SpeedDatingFormat %A

" Cycle through January, February, March, ..., December:
SpeedDatingFormat %B
