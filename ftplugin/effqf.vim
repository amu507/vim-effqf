function! GetModifiableW()
	let lstTmp=[winbufnr(g:g_LastWinr)]
	let lstTmp=extend(lstTmp,tabpagebuflist()) 
	for iNum in lstTmp
		let iModified = BufModifiable(iNum)
		if iModified==#1 && bufwinnr(iNum)!=#-1
			if iNum==#lstTmp[0]
				return g:g_LastWinr
			endif
			return bufwinnr(iNum)
		endif
	endfor
	return -1 
endfunction

function! OnHitEnter(sExt)
	let sLine=getline(".")   
	let lstTmp=split(sLine,"|")
	if len(lstTmp)<#2
		echom "<2"
		return
	endif
	let sPath=lstTmp[0]
	let sLine=lstTmp[1]
	if !filereadable(sPath)
		echom sPath . " not readable"
		return
	endif
	"preview
	if a:sExt==#'|ped'
		if sLine==#'f'
			let sExe=":pedit " . sPath
		else
			let sExe=":pedit " . sPath . "|wincmd P|" . sLine
		endif
		echom sExe
		execute(sExe)
		return
	endif

	let iWinNum=bufwinnr(sPath)	
	if iWinNum==#-1
		let iWinNum=GetModifiableW()
		if iWinNum==#-1
			echom "no modifiable window"
			return
		endif
		let sExe=iWinNum . " wincmd w|w" . a:sExt . "|e " . sPath ."|" . sLine
	"do not change line if we search the file
	elseif sLine==#'f'
		let sExe=iWinNum . " wincmd w|"
	else
		let sExe=iWinNum . " wincmd w|" . sLine
	endif
	execute(sExe)
endfunction

nnoremap <buffer> <cr> :call OnHitEnter("")<cr> 
nnoremap <buffer> ;s :call OnHitEnter("\|split")<cr>
nnoremap <buffer> ;v :call OnHitEnter("\|vs")<cr>
nnoremap <buffer> ;p :call OnHitEnter("\|ped")<cr>
nnoremap <buffer> <left> :call BackEffqfHis()<cr>
nnoremap <buffer> <right> :call FrontEffqfHis()<cr>
