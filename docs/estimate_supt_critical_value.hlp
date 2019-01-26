.-
help for ^estimate_supt_critical_value^
.-

Syntax
-----------------------------------------------------------------------

estimate_supt_critical_value, vcov_matrix(name) [ num_sim(int 1000) conf_level(real 0.95) ]

Description
-----------------------------------------------------------------------

The function takes a variance-covariance matrix and returns the critical value underlying 
the simultaneous sup-t confidence band proposed by Montiel Olea and Plagborg-Møller (2018).

Options
-----------------------------------------------------------------------

vcov_matrix: Variance-covariance matrix (Required)

num_sim: The number of random draws used in calculating the critical value (Default is 1000)
	
conf_level: Confidence level (Default is 0.95)

Return list 
-----------------------------------------------------------------------

r(critical_value): Critical value underlying simultaneous sup-t confidence band 


Example
-----------------------------------------------------------------------

estimate_supt_critical_value, vcov_matrix(cov_matrix) num_sim(100) conf_level(0.95)


Citations
-----------------------------------------------------------------------

Montiel Olea, Jose Luis and Mikkel Plagborg-Moller. 2018. Simultaneous Confidence
Bands: Theory, Implementation, and an Application to SVARs. Working paper.