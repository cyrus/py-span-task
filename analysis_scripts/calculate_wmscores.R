#  The function below reads the protocol of a single participant (as
#  generated by py-span-task) and calculates the working memory scores
#  discussed in Conway et al. (2005).

wm.scores <- function(filename, threshold=2/3) {

  d <- read.table(filename, header=T, sep="\t")
  d <- d[d$phase=="test",,drop=F]

  accuracy <- sum(d$correctly.verified) / sum(d$num.items)
  message(paste("Overall accuracy in the processing task:",
                format(accuracy, digits=2)))

  pcu <- mean(d$correctly.recalled / d$num.items)
  pcl <- sum(d$correctly.recalled) / sum(d$num.items)
  anu <- sum(d$num.items == d$correctly.recalled) / nrow(d)
  anl <- sum(d$num.items * (d$num.items == d$correctly.recalled)) / sum(d$num.items)

  thresh.func <- function(x) { mean(x==1)>threshold }
  t <- tapply(d$correctly.recalled / d$num.items, d$num.items, thresh.func)
  wmc <- max(as.integer(c("0", names(t)[t])))

  t <- tapply(d$correctly.recalled==d$num.items, d$num.items,
              function(x) { sum(x)/length(x)>threshold })
  wmc <- max(as.integer(c("0", names(t)[t])))

  c(wmc=wmc, pcu=pcu, anu=anu, pcl=pcl, anl=anl, accuracy=accuracy)
}

