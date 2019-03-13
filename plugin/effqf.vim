let g:g_EffqfHis=[]
let g:g_EffqfHisIdx=-1

function! AddEffqfHis(sHis)
	if len(g:g_EffqfHis)>#10
		call remove(g:g_EffqfHis,0)
	endif
	call add(g:g_EffqfHis,a:sHis)
endfunction

function! FrontEffqfHis()
	if g:g_EffqfHisIdx>=#-1
		echo "front of his"
		return
	endif
	let g:g_EffqfHisIdx+=1
	let sHis=g:g_EffqfHis[g:g_EffqfHisIdx]
	call ShowEffqf(sHis,1)
	echo g:g_EffqfHisIdx
	echo len(g:g_EffqfHis)
endfunction

function! BackEffqfHis()
	if g:g_EffqfHisIdx<=#-len(g:g_EffqfHis)
		echo "back of his"
		return
	endif
	let g:g_EffqfHisIdx-=1
	let sHis=g:g_EffqfHis[g:g_EffqfHisIdx]
	call ShowEffqf(sHis,1)
	echo g:g_EffqfHisIdx
	echo len(g:g_EffqfHis)
endfunction

function! ShowEffqf(sEffqf,...)
    let iHis=get(a:000,0,0)
	let iWinNum=bufwinnr(g:g_SysEffqf)	
	if iWinNum==#-1
		echom "please open effqf"
		return
	endif
	execute(iWinNum . "wincmd w")
	setlocal modifiable
	let @0=a:sEffqf
	silent execute('normal ggdG"0p')
	if iHis==#0
		let g:g_EffqfHisIdx=-1
		call AddEffqfHis(@0)
	endif
	let @0=""
	setlocal nomodifiable
	silent execute("w!")
endfunction

function! SignEffqf(errs)
	call effqf#signs#refresh(a:errs)
endfunction

function! GotoEffqfLine()
	let iLine=line(".")
	let lstLine = getbufline(bufnr("sys.effqf"),1,"$")
	let idx=0
	for sLine in lstLine 
		let idx=idx+1
		let lstRet=matchlist(sLine,'|\(\d\+\)|')
		if get(lstRet,1)==#iLine
			let sExe=bufwinnr('sys.effqf') . "wincmd w|" . idx
			execute(sExe)
			break
		endif
	endfor
endfunction

nmap <c-left> :call GotoWindow("sys.effqf")<CR><up><cr>
nmap <c-right> :call GotoWindow("sys.effqf")<CR><down><cr>
