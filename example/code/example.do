version 14
adopath + ../../ado
set matsize 2000
set scheme s1color 

program main
    simulate_data, num_units(2000) num_time_periods(80)

    run_regression, conf_level(0.95)
    local pw_critical_value = r(pw_critical_value)
    local un_critical_value = r(un_critical_value)

    build_plot ../output/event_study_pw_un_conf_bands,                      ///
        pw_critical_value(`pw_critical_value')                              ///
        un_critical_value(`un_critical_value')
end

program simulate_data  
    syntax [, num_units(int 2000) num_time_periods(int 80) base_month(str)  ///
        unit_fe(real 1) causal_effect(real 1) sd_error(real 5) ]
    if "`base_month'" == "" local base_month "`=ym(2006,12)'"
    
    set obs `=`num_units' * `num_time_periods''
    
    gen unit_id = ceil(_n / `num_time_periods') + 1000
    bysort unit_id : gen year_month = `base_month' + _n 
    bysort unit_id : gen policy_month = int(uniform() * `num_time_periods' + `base_month' + 1) if _n == 1
    format year_month policy_month %tm 
    
    bysort unit_id : carryforward policy_month, replace 
    gen relative_month = year_month - policy_month 
    gen z = relative_month >= 0 
    gen y = `unit_fe' * (unit_id - 1000) + `causal_effect' * z + rnormal(0, `sd_error')

    egen relative_month_ind = group(relative_month)
    replace relative_month_ind = 1000 if relative_month < -12 
    replace relative_month_ind = 2000 if relative_month > 12
    
    xtset unit_id year_month 
    assert r(balanced) == "strongly balanced"
end

program run_regression, rclass 
    syntax, conf_level(real) 
    areg y ib79.relative_month_ind i.year_month, absorb(unit_id) cluster(unit_id)
    
    local pw_critical_value = invttail(e(df_r), (1 - `conf_level') / 2)
    matrix vcov_matrix = e(V)

    estimate_supt_critical_value, vcov_matrix(vcov_matrix) conf_level(`conf_level')
    local un_critical_value = r(critical_value)

    return scalar pw_critical_value = `pw_critical_value'
    return scalar un_critical_value = `un_critical_value'
end 

program build_plot
    syntax anything(name = out_file), pw_critical_value(real) un_critical_value(real)

    preserve 
        regsave 
        keep if strpos(var, ".relative_month_ind") 
        drop if inlist(var, "1000.relative_month_ind", "2000.relative_month_ind")
        
        gen relative_month = substr(var, 1, 2)
        destring relative_month, replace
    
        sum relative_month if strpos(var, "b.relative_month_ind")
        replace relative_month = relative_month - (r(mean) + 1)
    
        foreach cv_type in pw un {
            gen `cv_type'_ci_ub = coef + ``cv_type'_critical_value' * stderr 
            gen `cv_type'_ci_lb = coef - ``cv_type'_critical_value' * stderr
        }
    
        twoway rcap pw_ci_lb pw_ci_ub relative_month,                   ///
                   color(black) msize(medlarge)                      || ///
               rspike un_ci_lb un_ci_ub relative_month, color(black) || ///
               scatter coef relative_month, mcolor(black)               ///
               legend(order(1 "Pointwise confidence band"               ///
                            2 "Sup-t confidence band"))                 ///
               xtitle("Months relative to event") xlabel(-12(2)12)      ///
               ytitle("Coefficient estimate")                           ///
               yline(0, lwidth(vthin) lpattern(dash) lcolor(black))

        graph export `out_file'.pdf, as(pdf) replace
    restore
end

* EXECUTE
main
