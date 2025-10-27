---
title: "Content 4-1: Getting started with functions"
date: "Monday, October 27, 2025"
output: 
  html_document:
    number_sections: false
    toc: true
    toc_depth: 1
    keep_md: yes
---


In Module 4, we will learn to write functions.  In Class 4-1, we will learn the basics of functions.  In later classes, we will learn about conditional execution and write more complicated functions.

*Note:* These class activities are adapted from "R for Data Science" by Grolemund and Wickham, chapter 19.  You can find this chapter [here](https://r4ds.had.co.nz/functions.html#when-should-you-write-a-function).

# What is a function?

A **function** takes an input (or set of inputs) and produces an output (or set of outputs). We've worked with lots of functions so far in `R`, like `mean()`, `mutate()`, and others.  What are the inputs and outputs of these functions?

If you open the help file for `mean()`, you can see what the inputs and outputs of the function will be.

``` r
?mean
```
The inputs of the function are listed under the **Arguments** section of the help file.  The outputs are listed in the **Value** section of the help file.  

We'll learn more about types of function arguments next week, but from this help file you can see that the inputs to the `mean()` function are a vector, `x`, of which we will calculate the mean and some options for calculating the mean called `trim`, `na.rm`, and `...`.  

In terms of the output for this function, from the **Value** section we see that the function produces the arithmetic mean of the values in the `x` input vector as a vector of length one.  If the argument `trim` is given a value other than 0, then a fraction of the largest/smallest observations are removed (trimmed) before the mean is calculated.

# Why should you use functions?

Functions are useful because they allow us to automate tasks that we do a lot instead of copying and pasting.  This is why for common tasks there are already functions in `R` to do these things.  However, we may want to write our own functions to avoid using copy/paste for our own unique tasks.

There are three big advantages of functions over copy/paste:

(1) Including functions in your code can make your code easier to understand -- you can break down complicated code into smaller pieces (functions) with names that clearly describe what each piece is doing.

(2) If you need to update/change your code, you only need to do so in one place (the function itself) instead of every place you want to do the task.

(3) You reduce the chance of incidental mistakes that happen during copy/paste, such as forgetting to change the variable name in one line of code.

# When should you use functions?

A good rule of thumb is that you should write a function whenever you've copied and pasted the same block of code more than twice.  The it is probably worth your time to create a function to do the task instead.

Look at the code below.  What does it do?

``` r
# Creates data frame (tibble) with 4 variables
df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# Look at this tibble
df
```

```
## # A tibble: 10 × 4
##          a      b      c      d
##      <dbl>  <dbl>  <dbl>  <dbl>
##  1  1.57    1.35   0.602  0.473
##  2 -1.10   -0.991 -0.200  0.919
##  3  0.163  -0.961 -0.518  0.236
##  4 -0.0764 -0.749  1.32   1.10 
##  5 -2.04    0.635  0.389 -1.05 
##  6 -2.10   -0.183  1.35  -0.649
##  7  0.0942 -0.867 -0.527  0.116
##  8 -0.0770 -0.829  1.05  -1.18 
##  9 -0.573   0.749  0.468  1.14 
## 10  2.88   -0.571 -2.01   1.59
```

``` r
# What does this code do?
df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))
```

This code rescales each column of the tibble to have a range from 0 to 1.  It does this by subtracting the minimum value from each observation and the dividing by the range (maximum - minimum) of the column.  You can verify this by looking at the tibble again.

``` r
df
```

```
## # A tibble: 10 × 4
##         a      b     c      d
##     <dbl>  <dbl> <dbl>  <dbl>
##  1 0.738  1.73   0.777 0.598 
##  2 0.201  0      0.539 0.760 
##  3 0.454  0.0218 0.445 0.513 
##  4 0.406  0.179  0.990 0.826 
##  5 0.0121 1.20   0.714 0.0498
##  6 0      0.597  1     0.193 
##  7 0.441  0.0916 0.442 0.470 
##  8 0.406  0.120  0.909 0     
##  9 0.307  1.28   0.738 0.839 
## 10 1      0.310  0     1
```

**However, there's a mistake in the code -- can you find it?** There's a copy/paste error where one `a` wasn't changed to a `b` as was intended. And that's why the `b` column wasn't rescaled correctly to be between 0 and 1.

This code is a good candidate for a function instead.

# How to write a function

To create a function, it's helpful to look at just one iteration of the code:

``` r
(df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
```

```
##  [1] 0.73769912 0.20064394 0.45442493 0.40642608 0.01208648 0.00000000
##  [7] 0.44065298 0.40631336 0.30677495 1.00000000
```

How many inputs does this code have? What are they?

From the snippet of code above, you can see the main input is the column of the tibble, `df$a`.  There's also an option having to do with `na.rm = TRUE`.

Once we have the inputs determined, it's a good idea to rewrite the code with a temporary input variable with a generic name like `x`.  We assign that temporary variable before the main piece of code and then replace the input variable with that temporary variable wherever it appears in the code:

``` r
x <- df$a

(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
```

```
##  [1] 0.73769912 0.20064394 0.45442493 0.40642608 0.01208648 0.00000000
##  [7] 0.44065298 0.40631336 0.30677495 1.00000000
```

This code already looks easier to read!  But to make the code even easier to read, we might notice there's some duplication: we are calculating the minimum value twice!  We can instead assign intermediate values to variables with meaningful names.  The following changes make the code even more readable.

``` r
x <- df$a
min_x <- min(x, na.rm = TRUE)
max_x <- max(x, na.rm = TRUE)

(x - min_x) / (max_x - min_x)
```

```
##  [1] 0.73769912 0.20064394 0.45442493 0.40642608 0.01208648 0.00000000
##  [7] 0.44065298 0.40631336 0.30677495 1.00000000
```

Pulling out intermediate calculations into separate variables with meaningful names is good practice because it makes it more clear what the code is doing.

Now we can turn our code into a function using the `function()` function:

``` r
rescale01 <- function(x) {
  min_x <- min(x, na.rm = TRUE)
  max_x <- max(x, na.rm = TRUE)
  
  (x - min_x) / (max_x - min_x)
}
```

To define our function so we can use it, we need to run the chunk of code that contains the function definition (above).  Now we can use the function in our subsequent code.  Each time we start a fresh `R` instance, we will need to redefine our function by running the code again.

[Note: you can see that this function is defined in the `Environment` tab in the upper right window of RStudio.  Click on this tab and scroll down to see all the functions in your current environment.]

Let's use our function (be sure to first run the code chunk above that defines it!):

``` r
rescale01(df$a)
```

```
##  [1] 0.73769912 0.20064394 0.45442493 0.40642608 0.01208648 0.00000000
##  [7] 0.44065298 0.40631336 0.30677495 1.00000000
```

``` r
rescale01(df$b)
```

```
##  [1] 1.00000000 0.00000000 0.01260762 0.10334568 0.69326240 0.34463459
##  [7] 0.05291276 0.06923682 0.74182033 0.17896210
```

``` r
rescale01(df$c)
```

```
##  [1] 0.7774207 0.5388784 0.4445801 0.9904890 0.7139015 1.0000000 0.4418639
##  [8] 0.9090362 0.7375591 0.0000000
```

``` r
rescale01(df$d)
```

```
##  [1] 0.59829514 0.75957611 0.51301236 0.82604737 0.04977199 0.19336676
##  [7] 0.46962422 0.00000000 0.83851704 1.00000000
```

There are three key steps to creating a new function:

(1) You need to pick a **name** for the function. You should make the name meaningful to the task the function does.  Here the name `rescale01` nicely describes what this function rescales a vector to values between 0 and 1.

(2) You list the inputs of the function, called **arguments**, inside `function()`. Here there is just one argument, `x`. If we had more arguments, we would have something that looks like `function(x, y, z)`.

(3) You place the code that does the task in the **body** of the function, a block between `{` and `}` that immediately follows `function(...)`.

Creating a function is **much** easier after you've already figured out how to make the code work with a single iteration of the task and a simple input.  So a good process is to create the function once you already have working code.

It's also a good idea to check your function with a few different inputs.  For example, will it work with negative numbers?  What about missing `NA` values?  What about infinite values?


``` r
rescale01(c(-10, 0, 10))
```

```
## [1] 0.0 0.5 1.0
```

``` r
rescale01(c(1, 2, 3, NA, 5))
```

```
## [1] 0.00 0.25 0.50   NA 1.00
```

``` r
rescale01(c(1:10, Inf))
```

```
##  [1]   0   0   0   0   0   0   0   0   0   0 NaN
```

It looks like if our variable contains infinite values then the `rescale01()` function fails!  We may want to update our code as follows to account for this:

``` r
rescale01 <- function(x) {
  min_x <- min(x[is.finite(x)], na.rm = TRUE)
  max_x <- max(x[is.finite(x)], na.rm = TRUE)
  
  (x - min_x) / (max_x - min_x)
}
```

And now try our variable with infinite values again:

``` r
rescale01(c(1:10, Inf))
```

```
##  [1] 0.0000000 0.1111111 0.2222222 0.3333333 0.4444444 0.5555556 0.6666667
##  [8] 0.7777778 0.8888889 1.0000000       Inf
```

Notice that we only needed to fix the code in one place, in the function itself! To update our function definition, we just need to run the code that redefines our function and now whenever we use it, the function will be "fixed".  This is an important part of the “do not repeat yourself” (or DRY) principle. The more repetition you have in your code, the more places you need to remember to update when things change (and they always do!), and the more likely you are to create bugs over time.

# Practice 

1. See what happens when we delete the `rescale01()` function from our environment and then try to run the following code:

``` r
# remove/delete the rescale01 function
rm(rescale01)

rescale01(df$a)
rescale01(df$b)
rescale01(df$c)
rescale01(df$d)
```
How can you fix this problem?

2. Turn the following code into a function.  Think about what the function does. What would you call it? How many arguments does it need? Can you rewrite it to be more expressive or less duplicative?

``` r
mean(is.na(x))
```

2. Turn the following code into a function.  Think about what the function does. What would you call it? How many arguments does it need? Can you rewrite it to be more expressive or less duplicative?

``` r
x / sum(x, na.rm = TRUE)
```

3. Turn the following code into a function.  Think about what the function does. What would you call it? How many arguments does it need? Can you rewrite it to be more expressive or less duplicative?

``` r
sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)
```

4. Write `both_na()`, a function that takes two vectors of the same length and returns the number of positions that have an NA in both vectors.


# Tips for writing useable functions

Here are some things to keep in mind when writing functions to make your code readable and useable:

(1) Choose your function name carefully!  Keep it short but still meaningful as to what the function actually does.  One rule of thumb is that function names should be verbs (telling what the function *does*) while function arguments should be nouns (telling what the arguments *are*).

* `f()` is too short and tells nothing about what the function does
* `my_awesome_function()` gives no description about what the function does

(2) If your function names includes multiple words, put them together with either `snake_case` or `camelCase` to differentiate the words.  Be consistent!

* `impute_missing()` and `collapse_years()` are good descriptive function names

(3) Try not to overwrite function that already exist in `R`.

* `mean()` is already an `R` function; overwriting it will cause you trouble later!

(4) Include comments, which are lines starting with `#`, to explain why you are doing something in your function: why did you choose this approach instead of an alternative?  What else did you try that didn't work?  

