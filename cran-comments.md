### Version 2.0: update for ggplot2 2.0

*2015-03-16*

* Require `ggplot2 >= 2.0.0` and modify `bdscale` accordingly. 

---

### Version 1.2: Fix for R-oldrelease

*2014-11-13*

* Require `R >= 3.1.0` for the `%u` `strftime` specification. 
* Translate the one long example into a vignette. 
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
