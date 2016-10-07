sign define PymodeE text=EE texthl=Error

"define EffqfSigns
let g:EffqfSigns = {}
let g:EffqfSigns._sign_ids = []
let g:EffqfSigns._next_id = 10000
let g:EffqfSigns._messages = {}

fun! effqf#signs#refresh(errs) "{{{
	call g:EffqfSigns.clear()
	call g:EffqfSigns.place(a:errs)
endfunction "}}}

fun! g:EffqfSigns.clear() "{{{
    let ids = copy(self._sign_ids)
    for i in ids
        execute "sign unplace " . i
        call remove(self._sign_ids, index(self._sign_ids, i))
    endfor
endfunction "}}}

fun! g:EffqfSigns.place(loclist) "{{{
    for err in a:loclist
		let idx=stridx(err,"|")
		if idx==#-1
			continue
		endif
		let sFile=err[: idx-1]
		let err=err[idx+1 :]
		let idx=stridx(err,"|")
		if idx==-1
			let sLine=err
		else
			let sLine=err[: idx]
		endif
        call add(self._sign_ids, self._next_id)
        execute printf('sign place %s line=%d name=%s file=%s', self._next_id, sLine, "PymodeE", sFile)
        let self._next_id += 1
    endfor
endfunction "}}}
