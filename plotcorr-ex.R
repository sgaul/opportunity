corr <- cor(x)

corr <- corr+t(corr)
diag(corr) <- 1
vnames <- c("College","Public assistance","Poverty","Unemployment","Owner-occupied","Commute time","Vacancy","Job growth","Math test scores","Reading test scores")
rownames(corr) <- colnames(corr) <- vnames

plot.corr(corr)