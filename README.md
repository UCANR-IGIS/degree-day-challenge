Degree Days Validation Challenge
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

  

*The Degree Days Validation Challenge is an opportunity for researchers
and computer programmers to validate and share their code that computes
degree days.*

  

## Background

‘Degree days’ are a measure of accumulated heat. The concept was
developed by biologists who realized that you can predict the growth of
plants and insects by tallying the temperature each day, starting when
they emerge. Today, degree day models are widely used in agriculture to
predict crop growth and stages of insect pest development.

In practice, one computes degree days using hourly temperature data. In
the event that hourly data are not available, one can also estimate
degree days based on the daily minimum and maximum temperature. Several
different forumula have been developed to estimate degree days from
daily min and max temperature.

  

## Degree Day Estimation Formulas

There are several mathematical formula that can be used to estimate
degree days based on daily minimum and maximum temperature. One of the
earliest papers to publish formulas for the different methods was Zalom
et al ([1983](https://catalog.hathitrust.org/Record/008707238)).

![](./images/zalom83_fig04_350x670x256.png)  
*Zalom et al (1983) provide formula for different methods of estimating
degree days based on daily minimum and maximum temperature*

<br/><br/>

![](./images/zalom83_tbl5-eq6_866x162x256.png) *Sample equation for
accumulated degree days for the single-sine method*

<br/>

Later authors developed variations of these formulas, including three
types of cutoff methods: horizontal, vertical, and intermediate.

![](./images/ucipm_fig7_373x476.png)

  

These formula have been used by researchers over the decades, and are
the engine behind the Degree Day calculators on the [UC ANR Integrated
Pest Management](http://ipm.ucanr.edu/WEATHER/) (UC IPM) website.

  

## Validate Your Code

Numerous researchers and web developers have written computer code to
compute degrees for specific applications, using programming languages
such as Fortran, Python, R, JavaScript, Matlab, Perl, and others, etc.
To check whether your code works as expected, all researchers are
invited to run their code on the reference dataset below, and optionally
share their code.

**Reference daily temperature dataset**

The reference temperature dataset contains 1 year of daily minimum and
maximum temperature values (°F) from the Esparto-A CIMIS weather
station:

[espartoa-weather-2020.csv](https://raw.githubusercontent.com/UCANR-IGIS/degree-day-challenge/main/data/espartoa-weather-2020.csv)

  

Preview:

``` r
library(dplyr)
daily_min_max_tbl = read.csv("./data/espartoa-weather-2020.csv")
nrow(daily_min_max_tbl)
```

    ## [1] 366

``` r
daily_min_max_tbl %>% slice(1:10)
```

    ##      station       date tmin tmax
    ## 1  Esparto.A 2020-01-01   38   55
    ## 2  Esparto.A 2020-01-02   36   67
    ## 3  Esparto.A 2020-01-03   33   59
    ## 4  Esparto.A 2020-01-04   37   59
    ## 5  Esparto.A 2020-01-05   38   63
    ## 6  Esparto.A 2020-01-06   36   58
    ## 7  Esparto.A 2020-01-07   30   53
    ## 8  Esparto.A 2020-01-08   41   50
    ## 9  Esparto.A 2020-01-09   37   53
    ## 10 Esparto.A 2020-01-10   32   55

  

To check the validity of your code, you should compute degree days for
this dataset with a **lower threshold of 50** and an **upper threshold
of 70**. The reference dataset has tmin and tmax values that cover all
six cases of relationship within this temperature range:

``` r
thresh_low = 50
thresh_high = 70

## Case 1: tmin < thresh_low; tmax < thresh_low
case1 = sum(daily_min_max_tbl$tmin < thresh_low & 
      daily_min_max_tbl$tmax < thresh_low)
case1
```

    ## [1] 3

``` r
## Case 2: tmin < thresh_low; tmax between thresh_low and thresh_high
case2 = sum(daily_min_max_tbl$tmin < thresh_low &
      daily_min_max_tbl$tmax >= thresh_low &
      daily_min_max_tbl$tmax <= thresh_high)
case2 
```

    ## [1] 131

``` r
## Case 3: tmin between thresh_low and thresh_high; tmax between thresh_low and thresh_high
case3 = sum(daily_min_max_tbl$tmin >= thresh_low &
      daily_min_max_tbl$tmin <= thresh_high &
      daily_min_max_tbl$tmax >= thresh_low &
      daily_min_max_tbl$tmax <= thresh_high)
case3
```

    ## [1] 6

``` r
## Case 4: tmin between thresh_low and thresh_high; tmax > thresh_high
case4 = sum(daily_min_max_tbl$tmin >= thresh_low &
      daily_min_max_tbl$tmin <= thresh_high &
      daily_min_max_tbl$tmax > thresh_high)
case4
```

    ## [1] 179

``` r
## Case 5: min > thresh_high; tmax > thresh_high
case5 = sum(daily_min_max_tbl$tmin > thresh_high &
      daily_min_max_tbl$tmax > thresh_high)
case5
```

    ## [1] 4

``` r
## Case 6: tmin < thresh_low; tmax > thresh_high
case6 = sum(daily_min_max_tbl$tmin < thresh_low &
      daily_min_max_tbl$tmax > thresh_high)
case6
```

    ## [1] 43

``` r
## The cases should add up to the number of rows (366)
case1 + case2 + case3 + case4 + case5 + case6
```

    ## [1] 366

# The Correct Answers

**TODO: need to add simple average method 1 and 2 (McMaster and Wilhelm,
1997)**

The results from the [UC IPM
website](http://ipm.ucanr.edu/WEATHER/index.html) shall serve as the
correct answers. The UC IPM website has been the reference for degree
day calculations for decades, and they have all the major methods
available. The correct answers have been compiled into a single CSV
file:

[ucipm_low50_high70_all.csv](https://raw.githubusercontent.com/UCANR-IGIS/degree-day-challenge/main/data/ucipm_results/ucipm_low50_high70_all.csv)

  

Preview:

``` r
answers_tbl = read.csv("./data/ucipm_results/ucipm_low50_high70_all.csv")
answers_tbl %>% slice(1:10)
```

    ##         date tmin tmax sngsine_horiz sngsine_vert sngsine_intrmd dblsine_horiz
    ## 1   1/1/2020   38   55          1.19         1.19           1.19          1.15
    ## 2   1/2/2020   36   67          5.71         5.71           5.71          5.56
    ## 3   1/3/2020   33   59          2.34         2.34           2.34          2.45
    ## 4   1/4/2020   37   59          2.56         2.56           2.56          2.59
    ## 5   1/5/2020   38   63          4.23         4.23           4.23          4.14
    ## 6   1/6/2020   36   58          2.13         2.13           2.13          2.00
    ## 7   1/7/2020   30   53          0.47         0.47           0.47          0.56
    ## 8   1/8/2020   41   50          0.00         0.00           0.00          0.00
    ## 9   1/9/2020   37   53          0.56         0.56           0.56          0.53
    ## 10 1/10/2020   32   55          1.01         1.01           1.01          1.19
    ##    dblsine_vert dblsine_intrmd sngtri_horiz sngtri_vert sngtri_intrmd
    ## 1          1.15           1.15         0.74        0.74          0.74
    ## 2          5.56           5.56         4.66        4.66          4.66
    ## 3          2.45           2.45         1.56        1.56          1.56
    ## 4          2.59           2.59         1.84        1.84          1.84
    ## 5          4.14           4.14         3.38        3.38          3.38
    ## 6          2.00           2.00         1.45        1.45          1.45
    ## 7          0.56           0.56         0.20        0.20          0.20
    ## 8          0.00           0.00         0.00        0.00          0.00
    ## 9          0.53           0.53         0.28        0.28          0.28
    ## 10         1.19           1.19         0.54        0.54          0.54
    ##    dbltri_horiz dbltri_vert dbltri_intrmd
    ## 1          0.70        0.70          0.70
    ## 2          4.46        4.46          4.46
    ## 3          1.70        1.70          1.70
    ## 4          1.88        1.88          1.88
    ## 5          3.25        3.25          3.25
    ## 6          1.30        1.30          1.30
    ## 7          0.29        0.29          0.29
    ## 8          0.00        0.00          0.00
    ## 9          0.25        0.25          0.25
    ## 10         0.75        0.75          0.75

  

To re-generate the correct answers, go to the [UC IPM
website](http://ipm.ucanr.edu/WEATHER/index.html) and upload the version
of the reference data that has [no
headers](https://raw.githubusercontent.com/UCANR-IGIS/degree-day-challenge/main/data/espartoa-weather-2020-noheader.csv).

## Submit Your Degree Day Computations!

If you have gone through all the trouble of coding up the degree day
formulas, you should get some credit for it! Let us know about your
results by starting a [Github
issue](https://github.com/UCANR-IGIS/degree-day-challenge/issues), and
we will link them below. Your codes **doesn’t have to support every
single method**, but it should present the comparisons to the answers.
If you’re willing to share your code with others, please put enough
description and links so others can replicate your work.

When your submission is posted, you’ll be sent embed code to display the
coveted **degree-day-challenge badge** on your site:

![](https://raw.githubusercontent.com/ucanr-igis/degree-day-challenge/main/badges/degree-day-challenge-passing.svg)

### Python

<div style="margin-left:2em;">

**Library**: HeatUnits  
**Author**: Shane Feirer  
**Code**:
[HeatUnits.py](https://github.com/UCANR-IGIS/caladapt-py/blob/master/CookBooks/HeatUnits.py)  
**Notebook**:
[DegreeDaysChallenge.ipynb](https://ucanr-igis.github.io/degree-day-challenge/submissions/heatunits_py/HeatUnits_py.html)
([HeatUnits_py.ipynb]())

**Results**:

| Method                                | Result                                            |
|:--------------------------------------|:--------------------------------------------------|
| Single-sine (horizontal cutoff)       | <span style="color:#14c700;">passing</span>       |
| Double-sine (horizontal cutoff)       | <span style="color:#14c700;">passing</span>       |
| Single-triangle (horizontal cutoff)   | <span style="color:#14c700;">passing</span>       |
| Double-triangle (horizontal cutoff)   | <span style="color:#14c700;">passing</span>       |
| Single-sine (intermediate cutoff)     | <span style="color:#ed6a43;">\>95% passing</span> |
| Double-sine (intermediate cutoff)     | <span style="color:#ed6a43;">\>95% passing</span> |
| Single-triangle (intermediate cutoff) | <span style="color:#ed6a43;">\>95% passing</span> |
| Double-triangle (intermediate cutoff) | <span style="color:#ed6a43;">\>95% passing</span> |
| Single-sine (vertical cutoff)         | <span style="color:#ed6a43;">\>95% passing</span> |
| Double-sine (vertical cutoff)         | <span style="color:#ed6a43;">\>95% passing</span> |
| Single-triangle (vertical cutoff)     | <span style="color:#ed6a43;">\>95% passing</span> |
| Double-triangle (vertical cutoff)     | <span style="color:#ed6a43;">\>95% passing</span> |

</div>

### R

<div style="margin-left:2em;">

**Library**: degday  
**Author**: Andy Lyons  
**Code**: [degday](https://ucanr-igis.github.io/degday/)  
**Notebook**: [Degree Day Validation Challenge with
degday](https://ucanr-igis.github.io/degree-day-challenge/submissions/degday_r/degday_R.nb.html)
([degday_R.Rmd]()) **Results**:

| Method                              | Result                                      |
|:------------------------------------|:--------------------------------------------|
| Single-sine (horizontal cutoff)     | <span style="color:#14c700;">passing</span> |
| Double-sine (horizontal cutoff)     | <span style="color:#14c700;">passing</span> |
| Single-triangle (horizontal cutoff) | <span style="color:#14c700;">passing</span> |
| Double-triangle (horizontal cutoff) | <span style="color:#14c700;">passing</span> |

</div>

### JavaScript

*No submissions yet*

### Matlab

*No submissions yet*
