version 14
adopath + ../../ado
set matsize 2000
set seed 1928384

program main
    test_return_function 
    test_stability

    matrix non_square = (1, 2 \ 3, 4 \ 5, 6)
    test_wrong_covariance_matrix, matr(non_square)

    matrix negative_definite = (-3, 0, 0 \ 0, -2, 0 \ 0, 0, -1)
    test_wrong_covariance_matrix, matr(negative_definite)

    test_wrong_number_of_simulations, number(100.5)    
    test_wrong_number_of_simulations, number(-5) 

    test_wrong_confidence_level, level(1)
    test_wrong_confidence_level, level(0)
    test_wrong_confidence_level, level(-0.5)
end

program test_return_function
    sysuse auto, clear

    qui reg mpg price weight trunk 
    matrix vcov_matrix = e(V)

    estimate_supt_critical_value, vcov_matrix(vcov_matrix)
    assert "`r(critical_value)'" != ""

    di "Test passed"
end 

program test_stability
    sysuse auto, clear

    qui reg mpg price weight trunk 
    matrix vcov_matrix = e(V)

    estimate_supt_critical_value, vcov_matrix(vcov_matrix)
    local critical_value_r1 = r(critical_value)

    qui reg mpg price weight trunk 
    matrix vcov_matrix = e(V)

    estimate_supt_critical_value, vcov_matrix(vcov_matrix)
    local critical_value_r2 = r(critical_value)

    assert `critical_value_r1' == `critical_value_r2'

    di "Test passed"
end 

program test_wrong_covariance_matrix
    syntax, matr(name)

    cap estimate_supt_critical_value, vcov_matrix(matr)
    assert _rc > 0

    di "Test passed"
end

program test_wrong_number_of_simulations
    syntax, number(real)

    matrix positive_definite = (1, 0.5 \ 0.5, 1)
    cap estimate_supt_critical_value, vcov_matrix(positive_definite) num_sim(number)
    assert _rc > 0

    di "Test passed"
end

program test_wrong_confidence_level
    syntax, level(real)

    matrix positive_definite = (1, 0.5 \ 0.5, 1)
    cap estimate_supt_critical_value, vcov_matrix(positive_definite) conf_level(level)
    assert _rc > 0
    
    di "Test passed"
end

* EXECUTE
main
