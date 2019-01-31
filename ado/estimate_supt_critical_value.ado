program estimate_supt_critical_value, rclass
    syntax, vcov_matrix(name) [ seed(int 192837) num_sim(int 1000) conf_level(real 0.95) ]

    local initial_rng_state = c(rngstate)
    set seed `seed'

    capture assert `conf_level' > 0 & `conf_level' < 1
    if _rc == 9 {
        di as error "Confidence level must live in (0, 1)"
        exit 111
    }

    local num_dim = rowsof(`vcov_matrix')
    forval i = 1/`num_dim' {
        local drawnorm_varlist "`drawnorm_varlist' v`i'"
    }

    preserve
        tempname normal_draws
        qui drawnorm `drawnorm_varlist', n(`num_sim') cov(`vcov_matrix') clear
        mkmat `drawnorm_varlist', matrix(`normal_draws')
    restore

    mata: get_critical_value(st_matrix("`vcov_matrix'"),                                    ///
                             st_matrix("`normal_draws'"),                      	            ///
                             `conf_level', `num_sim')

    return scalar critical_value = critical_value
    set rngstate `initial_rng_state'
end

mata:
void get_critical_value(real matrix vcov_matrix, real matrix draws,                         ///
                        real scalar conf_level, real scalar num_sim)
{
    stdvs = sqrt(diagonal(vcov_matrix))'
    t = draws :/ (stdvs # J(num_sim,1,1))
    t = rowmax(abs(t))
    t = sort(t,1)

    conf_level_num_sim = conf_level * num_sim

    if (round(conf_level_num_sim) == conf_level_num_sim) {
        critical_value = (t[conf_level_num_sim] + t[conf_level_num_sim + 1]) / 2
    }
    else critical_value = t[floor(conf_level_num_sim) + 1]

    st_numscalar("critical_value", critical_value)
}
end
