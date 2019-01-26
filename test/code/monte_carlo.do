version 14
adopath + ../../ado
set matsize 2000

program main
    sup_t_monte_carlo, num_reps(1000)
end

program sup_t_monte_carlo 
    syntax [, num_reps(int 500) conf_level(real 0.95) ]

    simulate pw_critical_value = r(pw_critical_value)                        ///
             pw_beta_covered   = r(pw_beta_covered)                          ///
             un_critical_value = r(un_critical_value)                        ///
             un_beta_covered   = r(un_beta_covered)                          ///
             , reps(`num_reps') : is_beta_covered, conf_level(`conf_level') 
    
    sum pw_beta_covered 
    di "Pointwise coverage rate = " r(mean)         
    cii `num_reps' `=`num_reps' * `r(mean)''
    assert r(ub) < `conf_level' 
    
    sum un_beta_covered 
    di "Uniform sup-t coverage rate = " r(mean)         
    cii `num_reps' `=`num_reps' * `r(mean)''
    assert inrange(`conf_level', r(lb), r(ub)) 
end 

program is_beta_covered, rclass 
    syntax [, num_obs(int 1000) sd_epsilon(int 10)                              ///
        num_sim(int 1000) conf_level(real 0.95) ]

    simulate_data, num_obs(`num_obs') sd_epsilon(`sd_epsilon') 

    reg y x1 x2 x3 
    matrix beta = e(b)
    matrix vcov = e(V)
    local pw_critical_value = invttail(e(df_r), (1 - `conf_level') / 2)

    estimate_supt_critical_value, vcov_matrix(vcov)                             ///
        num_sim(`num_sim') conf_level(`conf_level')
    local un_critical_value = r(critical_value)

    mata: build_is_beta_covered(st_matrix("beta"), st_matrix("vcov"),           ///
                                st_matrix("true_beta"), `pw_critical_value')
    local pw_beta_covered = beta_covered 
              
    mata: build_is_beta_covered(st_matrix("beta"), st_matrix("vcov"),           ///
                                st_matrix("true_beta"), `un_critical_value')
    local un_beta_covered = beta_covered 
              
    return scalar pw_critical_value = `pw_critical_value' 
    return scalar pw_beta_covered   = `pw_beta_covered'
    return scalar un_critical_value = `un_critical_value' 
    return scalar un_beta_covered   = `un_beta_covered'
end 

mata:
void build_is_beta_covered(real matrix beta, real matrix vcov_matrix,           ///
                     real matrix true_beta, real scalar critical_value)
{
    std_error = sqrt(diagonal(vcov_matrix))
    
    conf_lb = beta' - critical_value * std_error 
    conf_ub = beta' + critical_value * std_error
    
    covered     = (true_beta' :>= conf_lb) :& (true_beta' :<= conf_ub)
    min_covered = min(covered)
    
    st_numscalar("beta_covered", min_covered)
}
end

program simulate_data 
    syntax [, num_obs(int 1000) sd_epsilon(int 10) ] 
    
    clear
    set obs `num_obs'
    matrix cov_x = (1.0, 0.2, 0.6  \    ///
                    0.2, 1.0, 0.1  \    ///
                    0.6, 0.1, 1.0)
    drawnorm x1 x2 x3, cov(cov_x)
    gen epsilon = rnormal(1, `sd_epsilon')
    
    gen y = x1 + x2 + x3 + epsilon 
    matrix true_beta = (1, 1, 1, 1)
end

* EXECUTE
main
