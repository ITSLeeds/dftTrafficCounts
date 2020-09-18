
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dftTrafficCounts

<!-- badges: start -->

[![R build
status](https://github.com/itsleeds/dftTrafficCounts/workflows/R-CMD-check/badge.svg)](https://github.com/itsleeds/dftTrafficCounts/actions)
<!-- badges: end -->

The goal of dftTrafficCounts is to provide easy access to datasets
provided by UK Department for Transport (DfT) on their
[roadtraffic.dft.gov.uk](https://roadtraffic.dft.gov.uk) website.

## Installation

<!-- You can install the released version of dftTrafficCounts from [CRAN](https://CRAN.R-project.org) with: -->

<!-- ``` r -->

<!-- install.packages("dftTrafficCounts") -->

<!-- ``` -->

<!-- And the development version from [GitHub](https://github.com/) with: -->

``` r
# install.packages("devtools")
devtools::install_github("itsleeds/dftTrafficCounts")
```

<!-- From previous readme... -->

<!-- If you have traffic count data you would like to contribute to the Bristol City Council open data platform please contact city.transport@bristol.gov.uk -->

<!-- The entire dataset and a shapefile of the count locations can be downloaded here: http://1drv.ms/1LaIsZ4 -->

<!-- This data has not been quality checked and we strongly advise users conduct their own assessment of the quality of the data before using it. -->

# Reproducibility

You can reproduce the work presented here using the `targets` package:

``` r
library(targets)
```

``` r
targets::tar_glimpse()
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

``` r
print(tar_read(summary_dft))
#>  count_point_id   direction_of_travel      year        count_date        
#>  Min.   :    51   Length:4337901      Min.   :2000   Min.   :2000-03-17  
#>  1st Qu.: 46110   Class :character    1st Qu.:2005   1st Qu.:2005-05-13  
#>  Median :810147   Mode  :character    Median :2009   Median :2009-06-26  
#>  Mean   :529590                       Mean   :2010   Mean   :2010-01-28  
#>  3rd Qu.:945786                       3rd Qu.:2015   3rd Qu.:2015-04-24  
#>  Max.   :999999                       Max.   :2019   Max.   :2019-10-18  
#>       hour        region_id      local_authority_id  road_name        
#>  Min.   : 0.0   Min.   : 1.000   Min.   :  1.0      Length:4337901    
#>  1st Qu.: 9.0   1st Qu.: 4.000   1st Qu.: 67.0      Class :character  
#>  Median :12.0   Median : 7.000   Median : 97.0      Mode  :character  
#>  Mean   :12.5   Mean   : 6.157   Mean   :102.5                        
#>  3rd Qu.:15.0   3rd Qu.: 9.000   3rd Qu.:141.0                        
#>  Max.   :18.0   Max.   :11.000   Max.   :210.0                        
#>  road_category       road_type         start_junction_road_name
#>  Length:4337901     Length:4337901     Length:4337901          
#>  Class :character   Class :character   Class :character        
#>  Mode  :character   Mode  :character   Mode  :character        
#>                                                                
#>                                                                
#>                                                                
#>  end_junction_road_name    easting          northing          latitude    
#>  Length:4337901         Min.   : 70406   Min.   :  10240   Min.   :49.91  
#>  Class :character       1st Qu.:367870   1st Qu.: 178500   1st Qu.:51.49  
#>  Mode  :character       Median :432710   Median : 275950   Median :52.36  
#>                         Mean   :432488   Mean   : 302533   Mean   :52.61  
#>                         3rd Qu.:510541   3rd Qu.: 396995   3rd Qu.:53.47  
#>                         Max.   :655040   Max.   :1209448   Max.   :60.76  
#>    longitude       link_length_km     link_length_miles    sequence        
#>  Min.   :-7.4431   Length:4337901     Length:4337901     Length:4337901    
#>  1st Qu.:-2.4816   Class :character   Class :character   Class :character  
#>  Median :-1.5119   Mode  :character   Mode  :character   Mode  :character  
#>  Mean   :-1.5373                                                           
#>  3rd Qu.:-0.3847                                                           
#>  Max.   : 2.0000                                                           
#>      ramp            pedal_cycles      two_wheeled_motor_vehicles
#>  Length:4337901     Min.   :   0.000   Min.   :  0.000           
#>  Class :character   1st Qu.:   0.000   1st Qu.:  0.000           
#>  Mode  :character   Median :   0.000   Median :  1.000           
#>                     Mean   :   2.873   Mean   :  4.982           
#>                     3rd Qu.:   2.000   3rd Qu.:  5.000           
#>                     Max.   :2207.000   Max.   :768.000           
#>  cars_and_taxis   buses_and_coaches       lgvs         hgvs_2_rigid_axle
#>  Min.   :   0.0   Min.   :   0.000   Min.   :   0.00   Min.   :   0.00  
#>  1st Qu.:  44.0   1st Qu.:   0.000   1st Qu.:   7.00   1st Qu.:   0.00  
#>  Median : 195.0   Median :   2.000   Median :  29.00   Median :   3.00  
#>  Mean   : 417.2   Mean   :   5.662   Mean   :  71.33   Mean   :  14.43  
#>  3rd Qu.: 517.0   3rd Qu.:   7.000   3rd Qu.:  82.00   3rd Qu.:  14.00  
#>  Max.   :9709.0   Max.   :1425.000   Max.   :5811.00   Max.   :2327.00  
#>  hgvs_3_rigid_axle hgvs_4_or_more_rigid_axle hgvs_3_or_4_articulated_axle
#>  Min.   : -3.000   Min.   :  0.000           Min.   :  0.00              
#>  1st Qu.:  0.000   1st Qu.:  0.000           1st Qu.:  0.00              
#>  Median :  0.000   Median :  0.000           Median :  0.00              
#>  Mean   :  2.368   Mean   :  2.597           Mean   :  2.14              
#>  3rd Qu.:  2.000   3rd Qu.:  2.000           3rd Qu.:  1.00              
#>  Max.   :290.000   Max.   :796.000           Max.   :927.00              
#>  hgvs_5_articulated_axle hgvs_6_articulated_axle    all_hgvs      
#>  Min.   :   0.000        Min.   :   0.000        Min.   :   0.00  
#>  1st Qu.:   0.000        1st Qu.:   0.000        1st Qu.:   1.00  
#>  Median :   0.000        Median :   0.000        Median :   5.00  
#>  Mean   :   7.449        Mean   :   7.459        Mean   :  36.45  
#>  3rd Qu.:   2.000        3rd Qu.:   2.000        3rd Qu.:  26.00  
#>  Max.   :1107.000        Max.   :1430.000        Max.   :2691.00  
#>  all_motor_vehicles
#>  Min.   :    0.0   
#>  1st Qu.:   54.0   
#>  Median :  245.0   
#>  Mean   :  535.6   
#>  3rd Qu.:  650.0   
#>  Max.   :10905.0
```

``` r
targets::tar_make()
```
