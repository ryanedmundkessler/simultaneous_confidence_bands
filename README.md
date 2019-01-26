
# Computing Simultaneous Confidence Bands in Stata

Simultaneous confidence bands are versatile tools for visualizing estimation uncertainty for parameter vectors ([Montiel Olea and Plagborg-Møller 2018](https://scholar.princeton.edu/sites/default/files/mikkelpm/files/conf_band.pdf)). 

This repo houses a [Stata](https://www.stata.com/) function that computes the critical values underlying the simultaneous sup-t confidence bands proposed in [Montiel Olea and Plagborg-Møller (2018)](https://scholar.princeton.edu/sites/default/files/mikkelpm/files/conf_band.pdf). 

## Installation 

## Unit Tests

The repo houses two sets of unit tests. 

* [basic_functionality.do](./test/code/basic_functionality.do) : Asserts basic functionality
* [monte_carlo.do](./test/code/monte_carlo.do) : Asserts expected coverage rates for a given data generating process 

Both sets of unit tests can be executed by running [run_tests.py](./test/code/run_tests.py). Output is logged in corresponding [output directory](./test/output/). 

## Authors 

Sergey Egiev
<br>Brown University

Ryan Kessler
<br>Brown University
<br>Email: ryan.edmund.kessler@gmail.com

Michael Sielski
<br>Brown University

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details

## References

Montiel Olea, José Luis and Mikkel Plagborg-Møller. 2018. Simultaneous Confidence Bands: Theory, Implementation, and an Application to SVARs. Working paper.
