---
title: "Content 2-1"
date: "Monday, September 22, 2025"
output: 
  html_document:
    number_sections: false
    toc: true
    toc_depth: 1
    keep_md: yes
---


For Module 2, you will learn how to transform data using the package `dplyr`. `dplyr` is part of the `tidyverse` and provides a set of verbs for manipulating and transforming data.

*Note:* These class activities are adapted from "R for Data Science" by Grolemund and Wickham, chapter 5.  You can find this chapter [here](https://r4ds.had.co.nz/transform.html).

First we will load the `tidyverse` group of packages to have access to `dplyr`.  Remember that the line below loads the `tidyverse` group of packages; you can see that `dplyr` is one of these core packages.  We've already learned about `ggplot2` and we will learn about more of these later in the course.


``` r
library(tidyverse)
```

```
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ readr     2.1.5
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.5.2     ✔ tibble    3.3.0
## ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
## ✔ purrr     1.0.4     
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

**Side note:** You see there is "conflict" message when you load the tidyverse.  One of these conflicts says that `dplyr::filter() masks stats::filter()`. This is something that is good to be aware of, even though it probably won't impact you for this week's content.  The syntax here is `package::function()`.  So `dplyr::filter()` means the `filter()` function from the `dplyr` package and `stats::filter()` means the `filter()` function from the `stats` package.  Since these two functions have the same name, there is a conflict!  The way `R` handles conflicts like this is that the second package loaded overwrites the function from the earlier package.  Here the `stats` package in one of the base packages in `R`, so it is loaded first.  Then, when we load the `tidyverse` the `filter()` function from `dplyr` overwrites (or *masks*) the `filter()` function from `stats`.  This is good for us, because we want the function from `dplyr`!  However, if you ever encounter a situation where a function isn't working the way you expect it to, one thing to check is whether it has been masked by a function with the same name from a different package!  You can always explicitly designate the package you want for the function by using `dplyr::filter()` instead of just `filter()`. 

We will again work with the National Medical Expenditures (NMES) data for this module, but we will work with the full set of data you used in Assignment 1.  Load the full `nmes.data` object into your workspace with the command below.


``` r
load("nmes2018.rda")
```

Now back to our data! Recall that this `nmes.data` object is a data frame, which is a collection of observations (in the rows) across different variables (in the columns). Remember you can see the full dataset in a tab by typing:

``` r
View(nmes.data)
```

First lets look more closely at how the data prints when we view it in `R`:

``` r
nmes.data
```

```
## # A tibble: 4,078 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449  25952.  LC    No CHD no      <NA>    no         0             0  24.0
##  2 15534    378.  No LC No CHD Yes     Yes     no         3             0  26.7
##  3  9503     51.2 No LC No CHD Yes     no      Yes       40             9  22.3
##  4 15024   1899.  No LC No CHD no      <NA>    no         0             0  25.1
##  5 17817    154.  No LC No CHD Yes     Yes     no        86             0  20.2
##  6 31716    270   No LC No CHD no      <NA>    no         0             0  22.2
##  7   679    142   No LC No CHD no      <NA>    no         0             0  24.4
##  8 32819    898.  No LC No CHD Yes     no      Yes        0.900        32  24.1
##  9 33173    346   No LC No CHD no      <NA>    no         0             0  17.5
## 10 38247   2543.  No LC No CHD no      <NA>    no         0             0  25.4
## # ℹ 4,068 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

We only see the first few rows of the data and we only see the number of columns that can print on the screen.  Change your window size and run the code again and see again how it adapts!  This is because the data is stored in a **tibble**, which is a data structure that's easy to work with in the `tidyverse`.  We'll learn more about these later!  

We can force `R` to show us all the columns in the dataset by using the `print()` function with `width = Inf`, which will split the columns across multiple rows.

``` r
print(nmes.data, width = Inf)
```

```
## # A tibble: 4,078 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449  25952.  LC    No CHD no      <NA>    no         0             0  24.0
##  2 15534    378.  No LC No CHD Yes     Yes     no         3             0  26.7
##  3  9503     51.2 No LC No CHD Yes     no      Yes       40             9  22.3
##  4 15024   1899.  No LC No CHD no      <NA>    no         0             0  25.1
##  5 17817    154.  No LC No CHD Yes     Yes     no        86             0  20.2
##  6 31716    270   No LC No CHD no      <NA>    no         0             0  22.2
##  7   679    142   No LC No CHD no      <NA>    no         0             0  24.4
##  8 32819    898.  No LC No CHD Yes     no      Yes        0.900        32  24.1
##  9 33173    346   No LC No CHD no      <NA>    no         0             0  17.5
## 10 38247   2543.  No LC No CHD no      <NA>    no         0             0  25.4
##    beltuse educate  marital poor       age female mscd  ageCat 
##    <fct>   <fct>      <int> <fct>    <dbl> <fct>  <chr> <fct>  
##  1 Some    Other          1 Poor        78 Female Yes   (65,99]
##  2 Always  CollGrad       5 Not Poor    30 Female No    (0,40] 
##  3 Always  Other          1 Not Poor    72 Female No    (65,99]
##  4 Always  Other          2 Not Poor    64 Female No    (40,65]
##  5 Always  CollGrad       1 Not Poor    59 Female No    (40,65]
##  6 Some    CollGrad       5 Not Poor    25 Male   No    (0,40] 
##  7 Always  CollGrad       1 Not Poor    58 Female No    (40,65]
##  8 Always  CollGrad       1 Not Poor    56 Female No    (40,65]
##  9 Always  CollGrad       1 Not Poor    26 Female No    (0,40] 
## 10 Always  Other          1 Poor        81 Female No    (65,99]
## # ℹ 4,068 more rows
```

If we wanted to see the full data set (or as much of it as `R` will allow), we could view it as a data frame:


``` r
as.data.frame(nmes.data)
```

Which is easier to view?  When would you use one versus the other?

Going back to our tibble:

``` r
nmes.data
```

```
## # A tibble: 4,078 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449  25952.  LC    No CHD no      <NA>    no         0             0  24.0
##  2 15534    378.  No LC No CHD Yes     Yes     no         3             0  26.7
##  3  9503     51.2 No LC No CHD Yes     no      Yes       40             9  22.3
##  4 15024   1899.  No LC No CHD no      <NA>    no         0             0  25.1
##  5 17817    154.  No LC No CHD Yes     Yes     no        86             0  20.2
##  6 31716    270   No LC No CHD no      <NA>    no         0             0  22.2
##  7   679    142   No LC No CHD no      <NA>    no         0             0  24.4
##  8 32819    898.  No LC No CHD Yes     no      Yes        0.900        32  24.1
##  9 33173    346   No LC No CHD no      <NA>    no         0             0  17.5
## 10 38247   2543.  No LC No CHD no      <NA>    no         0             0  25.4
## # ℹ 4,068 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

Underneath each variable name is an abbreviation that tells us the type of the variable:

* `int` means integers
* `dbl` means doubles (or real numbers)
* `fct` means factors, how `R` represents categorical variables with fixed possible categories
* `chr` means characters (also called strings)

There are other types of variables not present in our dataset:

* `lgl` means logicals (values that can only be `TRUE` or `FALSE`)
* `date` means dates
* `dttm` means date-times (a date + a time)

The type of variable is important for what we are allowed to do with it; some of this is similar to the types of variables we have seen in class --
knowing whether a variable is continuous or binary/categorical helps us decide which type of summary to calculate (mean or proportion) or which type of graph to make (boxplot or barchart).

In this module we are going to learn 6 key functions to work with data: 

* `filter()` allows us to choose *observations* by their values; useful for defining subsets of the data that meet certain criteria
* `arrange()` allows us to order rows in the data based on some criteria
* `select()` allows us to choose *variables* from the dataset
* `mutate()` allows us to create new variables out of existing variables
* `summarize()` allows us to collapse values into a summary, such as collapsing individual values of a variable into the mean value or the sum of the values
* `group_by()` allows us to perform any of the previous 5 function on a group-by-group basis, for example summarizing to calculate a mean value for each group

All 6 of these function have a similar syntax:

* The first argument is a data frame (or tibble)
* The next arguments describe what to do with the data frame by referring to names of variables in the data set
* The result of the function is a new data frame (tibble)

# Filter rows with `filter()`

The `filter()` function allows us to subset our data by choosing observations (or rows) that meet certain criteria.  The first argument is the name of the data frame.  The second and following arguments are expressions that filter the data based on variable values.

**Example:** Only individuals who have ever smoked

``` r
filter(nmes.data, eversmk == "Yes")
```

```
## # A tibble: 1,994 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 15534    378.  No LC No CHD Yes     Yes     no         3             0  26.7
##  2  9503     51.2 No LC No CHD Yes     no      Yes       40             9  22.3
##  3 17817    154.  No LC No CHD Yes     Yes     no        86             0  20.2
##  4 32819    898.  No LC No CHD Yes     no      Yes        0.900        32  24.1
##  5  2689   8331.  No LC CHD    Yes     no      Yes       26             9  29.8
##  6  4258    536.  No LC No CHD Yes     no      Yes        0.200        45  30.2
##  7 22853   1642.  No LC No CHD Yes     Yes     no        28             0  NA  
##  8 35056   1049.  No LC No CHD Yes     Yes     no         2.40          0  20.9
##  9 25793   4108.  No LC No CHD Yes     no      Yes      175             8  27.7
## 10  8127  18694.  No LC CHD    Yes     no      Yes       13            12  24.1
## # ℹ 1,984 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*You can see there are 1,994 individuals who have ever smoked in our data set.*

**Example:** Only individuals who spent more than $10,000 on medical expenditures

``` r
filter(nmes.data, totalexp > 10000)
```

```
## # A tibble: 201 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449   25952. LC    No CHD no      <NA>    no             0         0  24.0
##  2  8127   18694. No LC CHD    Yes     no      Yes           13        12  24.1
##  3 38147   47284. No LC No CHD no      <NA>    no             0         0  NA  
##  4 22419   26799. No LC No CHD no      <NA>    no             0         0  20.0
##  5 25444  108639. No LC No CHD no      <NA>    no             0         0  22.7
##  6  6800   10293. No LC No CHD no      <NA>    no             0         0  30.1
##  7 31017   13133. No LC CHD    no      <NA>    no             0         0  24.1
##  8 25689   26864. No LC CHD    no      <NA>    no             0         0  20.9
##  9  3289   10936. No LC CHD    no      <NA>    no             0         0  30.1
## 10 30415   13471  No LC No CHD no      <NA>    no             0         0  23.3
## # ℹ 191 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*You can see there are 201 individuals who spent more than $10,000 on medical expenditures.*

**Example:** Only never smokers who spent more than $10,000 on medical expenditures

``` r
filter(nmes.data, eversmk == "no", totalexp > 10000)
```

```
## # A tibble: 86 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449   25952. LC    No CHD no      <NA>    no             0         0  24.0
##  2 38147   47284. No LC No CHD no      <NA>    no             0         0  NA  
##  3 22419   26799. No LC No CHD no      <NA>    no             0         0  20.0
##  4 25444  108639. No LC No CHD no      <NA>    no             0         0  22.7
##  5  6800   10293. No LC No CHD no      <NA>    no             0         0  30.1
##  6 31017   13133. No LC CHD    no      <NA>    no             0         0  24.1
##  7 25689   26864. No LC CHD    no      <NA>    no             0         0  20.9
##  8  3289   10936. No LC CHD    no      <NA>    no             0         0  30.1
##  9 30415   13471  No LC No CHD no      <NA>    no             0         0  23.3
## 10 32637   20302. No LC No CHD no      <NA>    no             0         0  30.7
## # ℹ 76 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*You can see there are 86 individuals who had never smoked and spent more than $10,000.*

If we want to save any of these *new* data frames for further use, we need to store the result as something using the *assignment operator*, `<-`:

``` r
high_spenders <- filter(nmes.data, totalexp > 10000)
high_spenders
```

```
## # A tibble: 201 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449   25952. LC    No CHD no      <NA>    no             0         0  24.0
##  2  8127   18694. No LC CHD    Yes     no      Yes           13        12  24.1
##  3 38147   47284. No LC No CHD no      <NA>    no             0         0  NA  
##  4 22419   26799. No LC No CHD no      <NA>    no             0         0  20.0
##  5 25444  108639. No LC No CHD no      <NA>    no             0         0  22.7
##  6  6800   10293. No LC No CHD no      <NA>    no             0         0  30.1
##  7 31017   13133. No LC CHD    no      <NA>    no             0         0  24.1
##  8 25689   26864. No LC CHD    no      <NA>    no             0         0  20.9
##  9  3289   10936. No LC CHD    no      <NA>    no             0         0  30.1
## 10 30415   13471  No LC No CHD no      <NA>    no             0         0  23.3
## # ℹ 191 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

We can both store and print out the results in a single line by putting parentheses around the assignment command:

``` r
(highSpenders <- filter(nmes.data, totalexp > 10000))
```

```
## # A tibble: 201 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449   25952. LC    No CHD no      <NA>    no             0         0  24.0
##  2  8127   18694. No LC CHD    Yes     no      Yes           13        12  24.1
##  3 38147   47284. No LC No CHD no      <NA>    no             0         0  NA  
##  4 22419   26799. No LC No CHD no      <NA>    no             0         0  20.0
##  5 25444  108639. No LC No CHD no      <NA>    no             0         0  22.7
##  6  6800   10293. No LC No CHD no      <NA>    no             0         0  30.1
##  7 31017   13133. No LC CHD    no      <NA>    no             0         0  24.1
##  8 25689   26864. No LC CHD    no      <NA>    no             0         0  20.9
##  9  3289   10936. No LC CHD    no      <NA>    no             0         0  30.1
## 10 30415   13471  No LC No CHD no      <NA>    no             0         0  23.3
## # ℹ 191 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

Notice that we filtered on 3 different conditions:

* `eversmk == "Yes"`
* `totalexp > 10000`
* `eversmk == "no"`

We define these conditions using comparisons: We compare the values in `eversmk` to either `"Yes"` or `"No"` and we compare the values in `totalexp` to the value 10000.  The standard comparison operators we can use are:

* `>` greater than
* `>=` greater than or equal to
* `<` less than
* `<=` less than or equal to
* `!=` not equal to
* `==` equal to
* `near()` equal to when using doubles, since the precision of the stored values might not match *exactly* out in the smallest digit!  See the small examples below:


``` r
sqrt(2)^2
```

```
## [1] 2
```

``` r
sqrt(2)^2 == 2
```

```
## [1] FALSE
```

``` r
near(sqrt(2)^2, 2)
```

```
## [1] TRUE
```

``` r
(1/49)*(7^2)
```

```
## [1] 1
```

``` r
(1/49)*(7^2) == 1
```

```
## [1] FALSE
```

``` r
near((1/49)*(7^2), 1)
```

```
## [1] TRUE
```

Multiple arguments to the `filter()` function are combined with AND so that all of the expressions must be met in the filtered output.  So the following command subsets to individuals with `eversmk == "No"` AND `totalexp > 10000`.  This gives us never smokers with high expenditures:

``` r
filter(nmes.data, eversmk == "no", totalexp > 10000)
```

```
## # A tibble: 86 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449   25952. LC    No CHD no      <NA>    no             0         0  24.0
##  2 38147   47284. No LC No CHD no      <NA>    no             0         0  NA  
##  3 22419   26799. No LC No CHD no      <NA>    no             0         0  20.0
##  4 25444  108639. No LC No CHD no      <NA>    no             0         0  22.7
##  5  6800   10293. No LC No CHD no      <NA>    no             0         0  30.1
##  6 31017   13133. No LC CHD    no      <NA>    no             0         0  24.1
##  7 25689   26864. No LC CHD    no      <NA>    no             0         0  20.9
##  8  3289   10936. No LC CHD    no      <NA>    no             0         0  30.1
##  9 30415   13471  No LC No CHD no      <NA>    no             0         0  23.3
## 10 32637   20302. No LC No CHD no      <NA>    no             0         0  30.7
## # ℹ 76 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

We can also combine expressions with logical operators ourselves using:

* `&` means AND; all of the conditions must be met
* `|` means OR; at least one of the conditions must be met
* `!` means NOT; the condition must NOT be met

So we could also write the following to get never smokers with high expenditures:

``` r
filter(nmes.data, eversmk == "no" & totalexp > 10000)
```

```
## # A tibble: 86 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449   25952. LC    No CHD no      <NA>    no             0         0  24.0
##  2 38147   47284. No LC No CHD no      <NA>    no             0         0  NA  
##  3 22419   26799. No LC No CHD no      <NA>    no             0         0  20.0
##  4 25444  108639. No LC No CHD no      <NA>    no             0         0  22.7
##  5  6800   10293. No LC No CHD no      <NA>    no             0         0  30.1
##  6 31017   13133. No LC CHD    no      <NA>    no             0         0  24.1
##  7 25689   26864. No LC CHD    no      <NA>    no             0         0  20.9
##  8  3289   10936. No LC CHD    no      <NA>    no             0         0  30.1
##  9 30415   13471  No LC No CHD no      <NA>    no             0         0  23.3
## 10 32637   20302. No LC No CHD no      <NA>    no             0         0  30.7
## # ℹ 76 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

To get never smokers OR those with high expenditures we would write:

``` r
filter(nmes.data, eversmk == "no" | totalexp > 10000)
```

```
## # A tibble: 2,199 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449   25952. LC    No CHD no      <NA>    no             0         0  24.0
##  2 15024    1899. No LC No CHD no      <NA>    no             0         0  25.1
##  3 31716     270  No LC No CHD no      <NA>    no             0         0  22.2
##  4   679     142  No LC No CHD no      <NA>    no             0         0  24.4
##  5 33173     346  No LC No CHD no      <NA>    no             0         0  17.5
##  6 38247    2543. No LC No CHD no      <NA>    no             0         0  25.4
##  7  9649     127. No LC No CHD no      <NA>    no             0         0  21.3
##  8 11671    1617. No LC No CHD no      <NA>    no             0         0  18.0
##  9  6613    2840. No LC No CHD no      <NA>    no             0         0  26.2
## 10 37969    1803. No LC No CHD no      <NA>    no             0         0  22.9
## # ℹ 2,189 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

To get all ever smokers EXCEPT those with high expenditures we could write:

``` r
filter(nmes.data, eversmk == "Yes" & !(totalexp > 10000))
```

```
## # A tibble: 1,879 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 15534    378.  No LC No CHD Yes     Yes     no         3             0  26.7
##  2  9503     51.2 No LC No CHD Yes     no      Yes       40             9  22.3
##  3 17817    154.  No LC No CHD Yes     Yes     no        86             0  20.2
##  4 32819    898.  No LC No CHD Yes     no      Yes        0.900        32  24.1
##  5  2689   8331.  No LC CHD    Yes     no      Yes       26             9  29.8
##  6  4258    536.  No LC No CHD Yes     no      Yes        0.200        45  30.2
##  7 22853   1642.  No LC No CHD Yes     Yes     no        28             0  NA  
##  8 35056   1049.  No LC No CHD Yes     Yes     no         2.40          0  20.9
##  9 25793   4108.  No LC No CHD Yes     no      Yes      175             8  27.7
## 10 21497     42.2 No LC No CHD Yes     no      Yes        1             0  21.7
## # ℹ 1,869 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

## Dealing with missing values

`R` uses `NA` to designate a missing value in a dataset.  A missing value means we don't know the value of the variable for that observation/individual.  It's hard to do comparisons with missing values:

``` r
NA > 5
```

```
## [1] NA
```

``` r
NA == 10
```

```
## [1] NA
```

``` r
NA == NA
```

```
## [1] NA
```

This is because if we don't know the value, we don't know whether it's greater than 5 or equal to 10.  And if two values are missing, we don't know whether they are equal because we don't know either of them!

This means we can't look at the subset with missing values for BMI just by filtering on `bmi == NA` because values for this vector will be `NA` when the condition is met instead of `TRUE`.  Try it:

``` r
filter(nmes.data, bmi == NA)
```

```
## # A tibble: 0 × 18
## # ℹ 18 variables: id <int>, totalexp <dbl>, lc5 <fct>, chd5 <fct>,
## #   eversmk <fct>, current <fct>, former <fct>, packyears <dbl>,
## #   yearsince <int>, bmi <dbl>, beltuse <fct>, educate <fct>, marital <int>,
## #   poor <fct>, age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*It doesn't look like there are any individuals with missing BMI.*

Instead for missing data we use `is.na()` to decide whether a value is missing:

``` r
filter(nmes.data, is.na(bmi))
```

```
## # A tibble: 124 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 22853   1642.  No LC No CHD Yes     Yes     no            28         0    NA
##  2   912    438.  No LC No CHD no      <NA>    no             0         0    NA
##  3 38147  47284.  No LC No CHD no      <NA>    no             0         0    NA
##  4 18735    576.  No LC No CHD no      <NA>    no             0         0    NA
##  5 14370   6726.  No LC No CHD no      <NA>    no             0         0    NA
##  6 18725    155   No LC No CHD no      <NA>    no             0         0    NA
##  7 13512   4692.  No LC No CHD Yes     Yes     no             9         0    NA
##  8 33336     36   No LC No CHD no      <NA>    no             0         0    NA
##  9 35811     63.3 No LC No CHD no      <NA>    no             0         0    NA
## 10 27384   7674.  No LC No CHD no      <NA>    no             0         0    NA
## # ℹ 114 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*Now we see there are 124 individuals with missing BMI values, and you can see the `bmi` column in all `NA` for these 124 rows.*

This means that to exclude observations with missing values for BMI we could filter on `!is.na(bmi)`:

``` r
filter(nmes.data, !is.na(bmi))
```

```
## # A tibble: 3,954 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449  25952.  LC    No CHD no      <NA>    no         0             0  24.0
##  2 15534    378.  No LC No CHD Yes     Yes     no         3             0  26.7
##  3  9503     51.2 No LC No CHD Yes     no      Yes       40             9  22.3
##  4 15024   1899.  No LC No CHD no      <NA>    no         0             0  25.1
##  5 17817    154.  No LC No CHD Yes     Yes     no        86             0  20.2
##  6 31716    270   No LC No CHD no      <NA>    no         0             0  22.2
##  7   679    142   No LC No CHD no      <NA>    no         0             0  24.4
##  8 32819    898.  No LC No CHD Yes     no      Yes        0.900        32  24.1
##  9 33173    346   No LC No CHD no      <NA>    no         0             0  17.5
## 10 38247   2543.  No LC No CHD no      <NA>    no         0             0  25.4
## # ℹ 3,944 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*Now we see there are 3,954 individuals with without missing BMI values.*

## Practice

1. Find all individuals who meet the following characteristics:

a. Had more than $1,000 but less than $10,000 in medical expenditures


b. Always wear a seatbelt


c. Have a BMI of at least 30 and currently smoke


d. Are both poor and college grads


e. Quit smoking more than 10 years ago


f. Quit smoking more than 10 years ago and are younger than 25 years old


g. Quit smoking more than 10 years ago or are younger than 25 years old


2. Another useful filtering helper is `between()`.  Look at the help file for this function using `?between`.  Can you use it to simplify the code below?

``` r
filter(nmes.data, totalexp >= 1000, totalexp <= 10000)
```

```
## # A tibble: 1,131 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 15024    1899. No LC No CHD no      <NA>    no             0         0  25.1
##  2 38247    2543. No LC No CHD no      <NA>    no             0         0  25.4
##  3  2689    8331. No LC CHD    Yes     no      Yes           26         9  29.8
##  4 11671    1617. No LC No CHD no      <NA>    no             0         0  18.0
##  5  6613    2840. No LC No CHD no      <NA>    no             0         0  26.2
##  6 37969    1803. No LC No CHD no      <NA>    no             0         0  22.9
##  7 31101    1183. No LC No CHD no      <NA>    no             0         0  29.9
##  8 33949    2240. No LC No CHD no      <NA>    no             0         0  22.4
##  9 19948    6228. No LC CHD    no      <NA>    no             0         0  25.1
## 10 24491    1936. No LC No CHD no      <NA>    no             0         0  23.8
## # ℹ 1,121 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

3. How many individuals are missing `bmi` values?


4. How many individuals are missing `current` values?  Filter to these individuals.  Do you think this is really *missing* data?



# Arrange rows with `arrange()`

The `arrange()` function changes the order of rows based on given criteria.  Again, the first argument is the name of the data frame.  The second and following arguments are either variable names or expressions containing variable names that are used to order the data set.  This function doesn't change the number of observations in the data set like `filter()` does, it just changes the order of the rows. 


``` r
arrange(nmes.data, totalexp)
```

```
## # A tibble: 4,078 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1  2326     3.29 No LC No CHD Yes     Yes     no        19             0  24.4
##  2  5183     4.5  No LC No CHD no      <NA>    no         0             0  27.2
##  3 37455     4.60 No LC No CHD Yes     Yes     no         0.600         0  25.9
##  4 27564     5    No LC No CHD no      <NA>    no         0             0  23.0
##  5 25128     5    No LC No CHD no      <NA>    no         0             0  22.2
##  6 22129     5    No LC No CHD Yes     no      Yes        1.80         24  NA  
##  7 36555     5    No LC No CHD no      <NA>    no         0             0  20.0
##  8  9384     5    No LC No CHD no      <NA>    no         0             0  22.2
##  9 36469     5.25 No LC No CHD no      <NA>    no         0             0  19.1
## 10  5486     5.69 No LC No CHD Yes     Yes     no        12.6           0  29.8
## # ℹ 4,068 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*There are still 4,078 individuals in the dataset, but the first row now shows the individual with the smallest medical expenditure.*

If more than one arrangement variable or expression is given, the later ones are used to break ties in the values of the preceding orderings:

``` r
arrange(nmes.data, totalexp, bmi)
```

```
## # A tibble: 4,078 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1  2326     3.29 No LC No CHD Yes     Yes     no        19             0  24.4
##  2  5183     4.5  No LC No CHD no      <NA>    no         0             0  27.2
##  3 37455     4.60 No LC No CHD Yes     Yes     no         0.600         0  25.9
##  4 36555     5    No LC No CHD no      <NA>    no         0             0  20.0
##  5 25128     5    No LC No CHD no      <NA>    no         0             0  22.2
##  6  9384     5    No LC No CHD no      <NA>    no         0             0  22.2
##  7 27564     5    No LC No CHD no      <NA>    no         0             0  23.0
##  8 22129     5    No LC No CHD Yes     no      Yes        1.80         24  NA  
##  9 36469     5.25 No LC No CHD no      <NA>    no         0             0  19.1
## 10  5486     5.69 No LC No CHD Yes     Yes     no        12.6           0  29.8
## # ℹ 4,068 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*You should see here that the 5 individuals with total expenditures of 5 are now arranged in order of increasing BMI value, with the `NA` value at the end.*

The default is to arrange in increasing (ascending) order.  To get decreasing (descending) order, use `desc()` within the `arrange()` function:

``` r
arrange(nmes.data, desc(totalexp))
```

```
## # A tibble: 4,078 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1  6375  138381. LC    No CHD Yes     no      Yes           56        21  25.0
##  2 18824  137345. No LC No CHD Yes     no      Yes           18         1  23.1
##  3  4502  128157. No LC No CHD no      <NA>    no             0         0  22.3
##  4 18082  113058. No LC CHD    Yes     Yes     no            49         0  23.2
##  5 25444  108639. No LC No CHD no      <NA>    no             0         0  22.7
##  6 12058   81493. No LC No CHD no      <NA>    no             0         0  18.9
##  7   965   75018. No LC CHD    no      <NA>    no             0         0  18.3
##  8  4570   74615. No LC CHD    Yes     Yes     no            60         0  25.9
##  9 33758   73385. No LC No CHD Yes     Yes     no            44         0  26.3
## 10 28046   71196. No LC CHD    no      <NA>    no             0         0  34.2
## # ℹ 4,068 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*Now the first row gives the individual with the highest medical expenditure.*

Missing values are always sorted to the end, regardless of whether you sort in increasing or decreasing order.

**What happens when you arrange using a categorical variable?**  It still orders the data by the variable, grouping those with the same variable value together:

``` r
arrange(nmes.data, lc5)
```

```
## # A tibble: 4,078 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 15534    378.  No LC No CHD Yes     Yes     no         3             0  26.7
##  2  9503     51.2 No LC No CHD Yes     no      Yes       40             9  22.3
##  3 15024   1899.  No LC No CHD no      <NA>    no         0             0  25.1
##  4 17817    154.  No LC No CHD Yes     Yes     no        86             0  20.2
##  5 31716    270   No LC No CHD no      <NA>    no         0             0  22.2
##  6   679    142   No LC No CHD no      <NA>    no         0             0  24.4
##  7 32819    898.  No LC No CHD Yes     no      Yes        0.900        32  24.1
##  8 33173    346   No LC No CHD no      <NA>    no         0             0  17.5
##  9 38247   2543.  No LC No CHD no      <NA>    no         0             0  25.4
## 10  2689   8331.  No LC CHD    Yes     no      Yes       26             9  29.8
## # ℹ 4,068 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

*Here we see the `No LC` individuals are sorted first!*

The **ordering** of a categorical depends on how `R` has ordered the possible categories of the variables.  We will talk more about how to order the categories later.  But if you want to check the order of the categories, you can do that with the `levels()` function:

``` r
levels(nmes.data$lc5)
```

```
## [1] "No LC" "LC"
```

Here we see that `No LC` is the first category and `LC` is the second.  So when we order by `lc5` we will get the `No LC` values first.  If we were to order by `desc(lc5)`, we would get the `LC` values first.

**Side note:** To use this `levels()` function, we have to give it the name of the data set followed by the name of the variable, with a dollar sign in between.  This is a common way to refer to variable in `R`.  It makes sure `R` knows which dataset to use to get the variable of interest.


## Practice

5. Sort individuals in this dataset to find the youngest people. Remember you can force `R` to show all the columns with the `print()` function and `width = Inf`.


6. Sort individuals in this dataset to find the oldest never smokers.


7. Sort individuals in this dataset to find the oldest ever smokers


8. Sort individuals in this dataset to find the never smokers with the highest medical expenditures.


# Select columns with `select()`

The `select()` function allows you to select only a subset of the total variables in the dataset.  This can be especially useful if the dataset contains hundreds of different variables but you only need to work with a smaller number of them.  Again, the first argument to this function is the name of the data frame.  The second and following arguments are the variable names you want to keep, or expressions relating to the variable names you want to keep.

The `:` operator allows you to select all variables between two variables.  The `-` operator allows you to remove certain variables while keeping the rest.

See how these different selections compare to the entire data set:

``` r
nmes.data
```

```
## # A tibble: 4,078 × 18
##       id totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##    <int>    <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1 20449  25952.  LC    No CHD no      <NA>    no         0             0  24.0
##  2 15534    378.  No LC No CHD Yes     Yes     no         3             0  26.7
##  3  9503     51.2 No LC No CHD Yes     no      Yes       40             9  22.3
##  4 15024   1899.  No LC No CHD no      <NA>    no         0             0  25.1
##  5 17817    154.  No LC No CHD Yes     Yes     no        86             0  20.2
##  6 31716    270   No LC No CHD no      <NA>    no         0             0  22.2
##  7   679    142   No LC No CHD no      <NA>    no         0             0  24.4
##  8 32819    898.  No LC No CHD Yes     no      Yes        0.900        32  24.1
##  9 33173    346   No LC No CHD no      <NA>    no         0             0  17.5
## 10 38247   2543.  No LC No CHD no      <NA>    no         0             0  25.4
## # ℹ 4,068 more rows
## # ℹ 8 more variables: beltuse <fct>, educate <fct>, marital <int>, poor <fct>,
## #   age <dbl>, female <fct>, mscd <chr>, ageCat <fct>
```

``` r
select(nmes.data, totalexp, eversmk)
```

```
## # A tibble: 4,078 × 2
##    totalexp eversmk
##       <dbl> <fct>  
##  1  25952.  no     
##  2    378.  Yes    
##  3     51.2 Yes    
##  4   1899.  no     
##  5    154.  Yes    
##  6    270   no     
##  7    142   no     
##  8    898.  Yes    
##  9    346   no     
## 10   2543.  no     
## # ℹ 4,068 more rows
```

``` r
select(nmes.data, totalexp:bmi)
```

```
## # A tibble: 4,078 × 9
##    totalexp lc5   chd5   eversmk current former packyears yearsince   bmi
##       <dbl> <fct> <fct>  <fct>   <fct>   <fct>      <dbl>     <int> <dbl>
##  1  25952.  LC    No CHD no      <NA>    no         0             0  24.0
##  2    378.  No LC No CHD Yes     Yes     no         3             0  26.7
##  3     51.2 No LC No CHD Yes     no      Yes       40             9  22.3
##  4   1899.  No LC No CHD no      <NA>    no         0             0  25.1
##  5    154.  No LC No CHD Yes     Yes     no        86             0  20.2
##  6    270   No LC No CHD no      <NA>    no         0             0  22.2
##  7    142   No LC No CHD no      <NA>    no         0             0  24.4
##  8    898.  No LC No CHD Yes     no      Yes        0.900        32  24.1
##  9    346   No LC No CHD no      <NA>    no         0             0  17.5
## 10   2543.  No LC No CHD no      <NA>    no         0             0  25.4
## # ℹ 4,068 more rows
```

``` r
select(nmes.data, -id)
```

```
## # A tibble: 4,078 × 17
##    totalexp lc5   chd5  eversmk current former packyears yearsince   bmi beltuse
##       <dbl> <fct> <fct> <fct>   <fct>   <fct>      <dbl>     <int> <dbl> <fct>  
##  1  25952.  LC    No C… no      <NA>    no         0             0  24.0 Some   
##  2    378.  No LC No C… Yes     Yes     no         3             0  26.7 Always 
##  3     51.2 No LC No C… Yes     no      Yes       40             9  22.3 Always 
##  4   1899.  No LC No C… no      <NA>    no         0             0  25.1 Always 
##  5    154.  No LC No C… Yes     Yes     no        86             0  20.2 Always 
##  6    270   No LC No C… no      <NA>    no         0             0  22.2 Some   
##  7    142   No LC No C… no      <NA>    no         0             0  24.4 Always 
##  8    898.  No LC No C… Yes     no      Yes        0.900        32  24.1 Always 
##  9    346   No LC No C… no      <NA>    no         0             0  17.5 Always 
## 10   2543.  No LC No C… no      <NA>    no         0             0  25.4 Always 
## # ℹ 4,068 more rows
## # ℹ 7 more variables: educate <fct>, marital <int>, poor <fct>, age <dbl>,
## #   female <fct>, mscd <chr>, ageCat <fct>
```

``` r
select(nmes.data, -id, -lc5, -chd5)
```

```
## # A tibble: 4,078 × 15
##    totalexp eversmk current former packyears yearsince   bmi beltuse educate 
##       <dbl> <fct>   <fct>   <fct>      <dbl>     <int> <dbl> <fct>   <fct>   
##  1  25952.  no      <NA>    no         0             0  24.0 Some    Other   
##  2    378.  Yes     Yes     no         3             0  26.7 Always  CollGrad
##  3     51.2 Yes     no      Yes       40             9  22.3 Always  Other   
##  4   1899.  no      <NA>    no         0             0  25.1 Always  Other   
##  5    154.  Yes     Yes     no        86             0  20.2 Always  CollGrad
##  6    270   no      <NA>    no         0             0  22.2 Some    CollGrad
##  7    142   no      <NA>    no         0             0  24.4 Always  CollGrad
##  8    898.  Yes     no      Yes        0.900        32  24.1 Always  CollGrad
##  9    346   no      <NA>    no         0             0  17.5 Always  CollGrad
## 10   2543.  no      <NA>    no         0             0  25.4 Always  Other   
## # ℹ 4,068 more rows
## # ℹ 6 more variables: marital <int>, poor <fct>, age <dbl>, female <fct>,
## #   mscd <chr>, ageCat <fct>
```

There are helper functions to help make selecting variables easier, especially if variables share similar names.  These aren't that helpful for our NMES data, but may be when working with other data in the future:

* `starts_with("text")` matches names that begin with "text"
* `ends_with("text")` matches names that end with "text"
* `contains("text")` matches names that contain "text"
* `num_range("x", 1:3)` matches `x1`, `x2`, and `x3`.

So, for example, if we want to select both age variables, `age` and `ageCat`, we could do:

``` r
select(nmes.data, starts_with("age"))
```

```
## # A tibble: 4,078 × 2
##      age ageCat 
##    <dbl> <fct>  
##  1    78 (65,99]
##  2    30 (0,40] 
##  3    72 (65,99]
##  4    64 (40,65]
##  5    59 (40,65]
##  6    25 (0,40] 
##  7    58 (40,65]
##  8    56 (40,65]
##  9    26 (0,40] 
## 10    81 (65,99]
## # ℹ 4,068 more rows
```

Or if we wanted both `packyears1` and `yearsince` and also `bmi` we could do:

``` r
select(nmes.data, contains("years"), bmi)
```

```
## # A tibble: 4,078 × 3
##    packyears yearsince   bmi
##        <dbl>     <int> <dbl>
##  1     0             0  24.0
##  2     3             0  26.7
##  3    40             9  22.3
##  4     0             0  25.1
##  5    86             0  20.2
##  6     0             0  22.2
##  7     0             0  24.4
##  8     0.900        32  24.1
##  9     0             0  17.5
## 10     0             0  25.4
## # ℹ 4,068 more rows
```

We can also rename our variables when we select them:

``` r
select(nmes.data, total_exp = totalexp, lung_cancer = lc5, ever_smoker = eversmk)
```

```
## # A tibble: 4,078 × 3
##    total_exp lung_cancer ever_smoker
##        <dbl> <fct>       <fct>      
##  1   25952.  LC          no         
##  2     378.  No LC       Yes        
##  3      51.2 No LC       Yes        
##  4    1899.  No LC       no         
##  5     154.  No LC       Yes        
##  6     270   No LC       no         
##  7     142   No LC       no         
##  8     898.  No LC       Yes        
##  9     346   No LC       no         
## 10    2543.  No LC       no         
## # ℹ 4,068 more rows
```

Notice that renaming variables with `select()` drops the other variables from the dataset.  If we just want to rename some variables but keep everything, we would use `rename()` instead of `select()`:

``` r
rename(nmes.data, total_exp = totalexp, lung_cancer = lc5, ever_smoker = eversmk)
```

```
## # A tibble: 4,078 × 18
##       id total_exp lung_cancer chd5   ever_smoker current former packyears
##    <int>     <dbl> <fct>       <fct>  <fct>       <fct>   <fct>      <dbl>
##  1 20449   25952.  LC          No CHD no          <NA>    no         0    
##  2 15534     378.  No LC       No CHD Yes         Yes     no         3    
##  3  9503      51.2 No LC       No CHD Yes         no      Yes       40    
##  4 15024    1899.  No LC       No CHD no          <NA>    no         0    
##  5 17817     154.  No LC       No CHD Yes         Yes     no        86    
##  6 31716     270   No LC       No CHD no          <NA>    no         0    
##  7   679     142   No LC       No CHD no          <NA>    no         0    
##  8 32819     898.  No LC       No CHD Yes         no      Yes        0.900
##  9 33173     346   No LC       No CHD no          <NA>    no         0    
## 10 38247    2543.  No LC       No CHD no          <NA>    no         0    
## # ℹ 4,068 more rows
## # ℹ 10 more variables: yearsince <int>, bmi <dbl>, beltuse <fct>,
## #   educate <fct>, marital <int>, poor <fct>, age <dbl>, female <fct>,
## #   mscd <chr>, ageCat <fct>
```

If you want to reorder the variables in your data frame to move the most important ones to the first columns but don't want to get rid of any variables, you can use `select()` with the `everything()` helper:

``` r
select(nmes.data, totalexp, mscd, eversmk, bmi, age, everything())
```

```
## # A tibble: 4,078 × 18
##    totalexp mscd  eversmk   bmi   age    id lc5   chd5  current former packyears
##       <dbl> <chr> <fct>   <dbl> <dbl> <int> <fct> <fct> <fct>   <fct>      <dbl>
##  1  25952.  Yes   no       24.0    78 20449 LC    No C… <NA>    no         0    
##  2    378.  No    Yes      26.7    30 15534 No LC No C… Yes     no         3    
##  3     51.2 No    Yes      22.3    72  9503 No LC No C… no      Yes       40    
##  4   1899.  No    no       25.1    64 15024 No LC No C… <NA>    no         0    
##  5    154.  No    Yes      20.2    59 17817 No LC No C… Yes     no        86    
##  6    270   No    no       22.2    25 31716 No LC No C… <NA>    no         0    
##  7    142   No    no       24.4    58   679 No LC No C… <NA>    no         0    
##  8    898.  No    Yes      24.1    56 32819 No LC No C… no      Yes        0.900
##  9    346   No    no       17.5    26 33173 No LC No C… <NA>    no         0    
## 10   2543.  No    no       25.4    81 38247 No LC No C… <NA>    no         0    
## # ℹ 4,068 more rows
## # ℹ 7 more variables: yearsince <int>, beltuse <fct>, educate <fct>,
## #   marital <int>, poor <fct>, female <fct>, ageCat <fct>
```

And, again, remember that if you want to save your modified dataset so you can work with it, you need to assign the new dataset to an object with the assignment operator, `<-`.  Here we assign it back to an object of the same name of `nmes.data` after arranging the columns in a way we like better.

``` r
nmes.data <- select(nmes.data, totalexp, mscd, eversmk, bmi, age, everything())

nmes.data
```

```
## # A tibble: 4,078 × 18
##    totalexp mscd  eversmk   bmi   age    id lc5   chd5  current former packyears
##       <dbl> <chr> <fct>   <dbl> <dbl> <int> <fct> <fct> <fct>   <fct>      <dbl>
##  1  25952.  Yes   no       24.0    78 20449 LC    No C… <NA>    no         0    
##  2    378.  No    Yes      26.7    30 15534 No LC No C… Yes     no         3    
##  3     51.2 No    Yes      22.3    72  9503 No LC No C… no      Yes       40    
##  4   1899.  No    no       25.1    64 15024 No LC No C… <NA>    no         0    
##  5    154.  No    Yes      20.2    59 17817 No LC No C… Yes     no        86    
##  6    270   No    no       22.2    25 31716 No LC No C… <NA>    no         0    
##  7    142   No    no       24.4    58   679 No LC No C… <NA>    no         0    
##  8    898.  No    Yes      24.1    56 32819 No LC No C… no      Yes        0.900
##  9    346   No    no       17.5    26 33173 No LC No C… <NA>    no         0    
## 10   2543.  No    no       25.4    81 38247 No LC No C… <NA>    no         0    
## # ℹ 4,068 more rows
## # ℹ 7 more variables: yearsince <int>, beltuse <fct>, educate <fct>,
## #   marital <int>, poor <fct>, female <fct>, ageCat <fct>
```

## Practice

9. What happens if you include the name of a variable multiple times in a `select()` call?

``` r
select(nmes.data, age, ageCat, bmi, bmi)
```

```
## # A tibble: 4,078 × 3
##      age ageCat    bmi
##    <dbl> <fct>   <dbl>
##  1    78 (65,99]  24.0
##  2    30 (0,40]   26.7
##  3    72 (65,99]  22.3
##  4    64 (40,65]  25.1
##  5    59 (40,65]  20.2
##  6    25 (0,40]   22.2
##  7    58 (40,65]  24.4
##  8    56 (40,65]  24.1
##  9    26 (0,40]   17.5
## 10    81 (65,99]  25.4
## # ℹ 4,068 more rows
```

10. What does the `any_of()` function do? Run the code below to figure it out:

``` r
myVars <- c("totalexp", "mscd", "age", "eversmk", "bmi")
select(nmes.data, any_of(myVars))
```

```
## # A tibble: 4,078 × 5
##    totalexp mscd    age eversmk   bmi
##       <dbl> <chr> <dbl> <fct>   <dbl>
##  1  25952.  Yes      78 no       24.0
##  2    378.  No       30 Yes      26.7
##  3     51.2 No       72 Yes      22.3
##  4   1899.  No       64 no       25.1
##  5    154.  No       59 Yes      20.2
##  6    270   No       25 no       22.2
##  7    142   No       58 no       24.4
##  8    898.  No       56 Yes      24.1
##  9    346   No       26 no       17.5
## 10   2543.  No       81 no       25.4
## # ℹ 4,068 more rows
```


# Add new variables with `mutate()`

Sometimes we want to create a new variable from an old variable and add this new variable to our data set.  We can do this with the `mutate()` function.  Again, the first argument to this function is a data frame.  The following arguments define new variables in terms of variables already in the dataset.

For example, suppose we wanted to create a new variable, `log10_exp`, which contained a log-transformed version of our medical expenditure variable:

``` r
mutate(nmes.data, log10_exp = log10(totalexp))
```

```
## # A tibble: 4,078 × 19
##    totalexp mscd  eversmk   bmi   age    id lc5   chd5  current former packyears
##       <dbl> <chr> <fct>   <dbl> <dbl> <int> <fct> <fct> <fct>   <fct>      <dbl>
##  1  25952.  Yes   no       24.0    78 20449 LC    No C… <NA>    no         0    
##  2    378.  No    Yes      26.7    30 15534 No LC No C… Yes     no         3    
##  3     51.2 No    Yes      22.3    72  9503 No LC No C… no      Yes       40    
##  4   1899.  No    no       25.1    64 15024 No LC No C… <NA>    no         0    
##  5    154.  No    Yes      20.2    59 17817 No LC No C… Yes     no        86    
##  6    270   No    no       22.2    25 31716 No LC No C… <NA>    no         0    
##  7    142   No    no       24.4    58   679 No LC No C… <NA>    no         0    
##  8    898.  No    Yes      24.1    56 32819 No LC No C… no      Yes        0.900
##  9    346   No    no       17.5    26 33173 No LC No C… <NA>    no         0    
## 10   2543.  No    no       25.4    81 38247 No LC No C… <NA>    no         0    
## # ℹ 4,068 more rows
## # ℹ 8 more variables: yearsince <int>, beltuse <fct>, educate <fct>,
## #   marital <int>, poor <fct>, female <fct>, ageCat <fct>, log10_exp <dbl>
```

If you look, you can see that a new variable called `log_exp` has been added to the end of the `nmes.data` data frame.  The `mutate()` function always adds variables to the end, so let's do that again after first creating a smaller data frame with fewer variables.

``` r
nmes.sub <- select(nmes.data, totalexp, mscd, eversmk, bmi, age)

mutate(nmes.sub, log10_exp = log10(totalexp))
```

```
## # A tibble: 4,078 × 6
##    totalexp mscd  eversmk   bmi   age log10_exp
##       <dbl> <chr> <fct>   <dbl> <dbl>     <dbl>
##  1  25952.  Yes   no       24.0    78      4.41
##  2    378.  No    Yes      26.7    30      2.58
##  3     51.2 No    Yes      22.3    72      1.71
##  4   1899.  No    no       25.1    64      3.28
##  5    154.  No    Yes      20.2    59      2.19
##  6    270   No    no       22.2    25      2.43
##  7    142   No    no       24.4    58      2.15
##  8    898.  No    Yes      24.1    56      2.95
##  9    346   No    no       17.5    26      2.54
## 10   2543.  No    no       25.4    81      3.41
## # ℹ 4,068 more rows
```

You can create more than one new variable at once, and can refer to columns you've previously created when creating later variables:

``` r
mutate(nmes.sub, 
       log10_exp = log10(totalexp), 
       high_exp = (log10_exp > 4)
       )
```

```
## # A tibble: 4,078 × 7
##    totalexp mscd  eversmk   bmi   age log10_exp high_exp
##       <dbl> <chr> <fct>   <dbl> <dbl>     <dbl> <lgl>   
##  1  25952.  Yes   no       24.0    78      4.41 TRUE    
##  2    378.  No    Yes      26.7    30      2.58 FALSE   
##  3     51.2 No    Yes      22.3    72      1.71 FALSE   
##  4   1899.  No    no       25.1    64      3.28 FALSE   
##  5    154.  No    Yes      20.2    59      2.19 FALSE   
##  6    270   No    no       22.2    25      2.43 FALSE   
##  7    142   No    no       24.4    58      2.15 FALSE   
##  8    898.  No    Yes      24.1    56      2.95 FALSE   
##  9    346   No    no       17.5    26      2.54 FALSE   
## 10   2543.  No    no       25.4    81      3.41 FALSE   
## # ℹ 4,068 more rows
```

There are lots of different functions you can use together with `mutate()` to create new variables.  Here's a list of a bunch of them, but these are not all of them!

`+`, `-`, `*`, `/`, `^`, `sum()`, `mean()`, `log()`, `log10()`, `log2()`, `<`, `<=`, `>`, `>=`, `==`, `!=`, `min_rank()`, `percent_rank()`, and more!

For example, if you wanted to create a variable to give the percent rank of each individual in terms of medical expenditures:

``` r
mutate(nmes.sub, rank_exp = percent_rank(totalexp))
```

```
## # A tibble: 4,078 × 6
##    totalexp mscd  eversmk   bmi   age rank_exp
##       <dbl> <chr> <fct>   <dbl> <dbl>    <dbl>
##  1  25952.  Yes   no       24.0    78   0.986 
##  2    378.  No    Yes      26.7    30   0.423 
##  3     51.2 No    Yes      22.3    72   0.0701
##  4   1899.  No    no       25.1    64   0.794 
##  5    154.  No    Yes      20.2    59   0.210 
##  6    270   No    no       22.2    25   0.332 
##  7    142   No    no       24.4    58   0.195 
##  8    898.  No    Yes      24.1    56   0.649 
##  9    346   No    no       17.5    26   0.402 
## 10   2543.  No    no       25.4    81   0.841 
## # ℹ 4,068 more rows
```

It's easier to see what this `rank_exp` variable is if we sort by medical expenditures, so we can store this transformed data set and then sort it with `arrange()`:

``` r
nmes.ranked <- mutate(nmes.sub, rank_exp = percent_rank(totalexp))
arrange(nmes.ranked, totalexp)
```

```
## # A tibble: 4,078 × 6
##    totalexp mscd  eversmk   bmi   age rank_exp
##       <dbl> <chr> <fct>   <dbl> <dbl>    <dbl>
##  1     3.29 No    Yes      24.4    36 0       
##  2     4.5  No    no       27.2    24 0.000245
##  3     4.60 No    Yes      25.9    21 0.000491
##  4     5    No    no       23.0    23 0.000736
##  5     5    No    no       22.2    23 0.000736
##  6     5    No    Yes      NA      45 0.000736
##  7     5    No    no       20.0    26 0.000736
##  8     5    No    no       22.2    32 0.000736
##  9     5.25 No    no       19.1    25 0.00196 
## 10     5.69 No    Yes      29.8    40 0.00221 
## # ℹ 4,068 more rows
```
Here you can see that the `rank_exp` variable starts close to 0 and increases as medical expenditures increase.  If we sort by `desc(totalexp)` you see that the rank variable is 1 for the highest expenditures:

``` r
arrange(nmes.ranked, desc(totalexp))
```

```
## # A tibble: 4,078 × 6
##    totalexp mscd  eversmk   bmi   age rank_exp
##       <dbl> <chr> <fct>   <dbl> <dbl>    <dbl>
##  1  138381. Yes   Yes      25.0    66    1    
##  2  137345. No    Yes      23.1    55    1.00 
##  3  128157. No    no       22.3    73    1.00 
##  4  113058. Yes   Yes      23.2    65    0.999
##  5  108639. No    no       22.7    75    0.999
##  6   81493. No    no       18.9    61    0.999
##  7   75018. Yes   no       18.3    88    0.999
##  8   74615. Yes   Yes      25.9    74    0.998
##  9   73385. No    Yes      26.3    64    0.998
## 10   71196. Yes   no       34.2    80    0.998
## # ℹ 4,068 more rows
```

You may be starting to see that the real power of these different functions will be when we can combine them together.  **Next week we will look at `group_by()` and `summarize()` and learn how to work with all these functions in combination!**

## Practice

11. Create the following new variables and add to our NMES dataset in a single mutate command:

* Variable that tells whether an individual always uses their seat belt
* Variable that tells whether an individual's medical expenditures are higher than the mean expenditure value in the dataset
* Variable that tells whether an individual quit smoking more than 5 years ago



