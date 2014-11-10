### Version 1.2: Fix examples for R-oldrelease

*2014-11-10*

* Translate the complicated example into a vignette because Uwe says the former doesn't work for `R-oldrelease` on Windows. 
* Add shorter examples that `dontrun`. 
* Remove dependencies on `dplyr` and `magrittr` in examples, remove from `Suggests`. 
* Remove unnecessary date conversion when calculating breaks. 

---

### Version 1.1: Better breaks

*2014-10-27*

* Put breaks in more sensible places: start of week / month / quarter.
* Export the `bd2t` function so I can overlay `geom_vline`s. 
* Make the Yahoo price grabber more generic.

### Version 1.0: Initial package submission

*2014-10-08*
