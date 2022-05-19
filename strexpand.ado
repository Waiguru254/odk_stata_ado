*** Developer: Waiguru Muriuki

cap program drop strexpand
        program define strexpand, 
        pause on
        version 17.0
        syntax anything [,drop ]
                qui local prefix `anything'

                qui isvar `prefix'? `prefix'?? `prefix'???
                         qui gen idddis=_n
                         qui tempfile datss
                         qui save `datss',replace
                         cap local varla: var lab `prefix'
                         qui split `prefix', p(", ") 
                         qui isvar  `prefix'? `prefix'?? `prefix'???
                         qui keep `r(varlist)'
                         qui gen idddis=_n
                         qui reshape long `prefix', i(idddis) j(what)
                        cap qui label drop what_is_it
                         qui  encode `prefix', gen(what_is_it)
                         qui tabgen what_is_it
                         qui odkshrink what_is_it_
                         qui destring*,replace
                         qui isvar what_is_it what_is_it_? what_is_it_?? what_is_it_??
                         foreach var of varlist `r(varlist)' {
                                replace `var'=what_is_it_ if `var'==1
                         }
                        qui cap drop what_is_it_?
                        qui cap drop what_is_it_
                        qui cap drop `prefix'
                        qui reshape wide what_is_it, i(idddis) j(what)
                        qui egen what_is_it = concat( what_is_it? ), punct( " " )
                        qui isvar  what_is_it? what_is_it?? what_is_it???
                        qui drop  `r(varlist)'
                        qui replace what_is_it=subinstr(what_is_it,".","",.)
                        qui merge 1:1 idddis using `datss', keep(match) nogen
          cap drop `prefix' idddis
          cap qui rename what_is_it `prefix'
          qui isvar  `prefix'? `prefix'?? `prefix'???
          cap qui drop `r(varlist)'
          order `prefix', last
          cap lab var `prefix' "`varla'"
          cap replace `prefix'=trim(`prefix')
          qui odkexpand `prefix', val(what_is_it)
          
        end
