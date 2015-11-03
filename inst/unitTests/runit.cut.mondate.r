test.cut.mondate <- function() {

  #require(RUnit)
  y <- cut(mondate(12:24), breaks = 12:24)
  checkEquals(length(levels(y)), 12)

  # mondate

  x <- mondate(0:4)
  (y <- cut(x, x))
  checkEquals(levels(y), c("(12/31/1999,01/31/2000]","(01/31/2000,02/29/2000]",
                           "(02/29/2000,03/31/2000]","(03/31/2000,04/30/2000]"))
  (y <- cut(x, x, right = FALSE))
  checkEquals(levels(y), c("[12/31/1999,01/31/2000)","[01/31/2000,02/29/2000)",
                           "[02/29/2000,03/31/2000)","[03/31/2000,04/30/2000)"))

  # 4 levels of unit width.
  (y <- cut.mondate(x, breaks = 4, attr.breaks = TRUE))
  checkTrue(is.na(y[1]))
  checkEquals(levels(y), c("(12/31/1999,01/31/2000]", "(01/31/2000,02/29/2000]", "(02/29/2000,03/31/2000]", "(03/31/2000,04/30/2000]"))
  (y <- cut.mondate(x, breaks = 4, include.lowest = TRUE))
  checkTrue(!is.na(y[1]))
  checkEquals(levels(y), c("[12/31/1999,01/31/2000]", "(01/31/2000,02/29/2000]", "(02/29/2000,03/31/2000]", "(03/31/2000,04/30/2000]"))

  (y <- cut(x, attr(y, "breaks"), right = TRUE, include.lowest = TRUE))
  checkEquals(levels(y), c("[11/30/1999,12/31/1999]", "(12/31/1999,01/31/2000]", "(01/31/2000,02/29/2000]", "(02/29/2000,03/31/2000]", "(03/31/2000,04/30/2000]"))

  # "weeks"
  x <- c(mondate.ymd(2014, 3, 30:31), mondate.ymd(2014, 4, 1:30))
  (y <- cut.mondate(x, "weeks", attr.breaks = TRUE))
  checkTrue(is.na(y[1]))
  checkEquals(levels(y), c("04/06/2014", "04/13/2014", "04/20/2014", "04/27/2014", "05/04/2014"))
  (y <- cut.mondate(x, "weeks", attr.breaks = TRUE, right = FALSE))
  checkTrue(is.na(y[1]))
  checkEquals(levels(y), c("03/30/2014", "04/06/2014", "04/13/2014", "04/20/2014", "04/27/2014"))

  x <- c(mondate.ymd(2014, 3, 31), mondate.ymd(2014, 4, 1:30))
  (y <- cut.mondate(x, "weeks", attr.breaks = TRUE))
  checkTrue(!is.na(y[1]))
  checkEquals(levels(y), c("04/06/2014", "04/13/2014", "04/20/2014", "04/27/2014", "05/04/2014"))

  x <- c(mondate.ymd(2014, 3, 30:31), mondate.ymd(2014, 4, 1:30))
  (y <- cut.mondate(x, "weeks", include.lowest = TRUE, attr.breaks = TRUE))
  checkTrue(!is.na(y[1]))
  checkEquals(levels(y), c("03/30/2014", "04/06/2014", "04/13/2014", "04/20/2014", "04/27/2014", "05/04/2014"))
  
  x <- c(mondate.ymd(2014, 3, 30:31), mondate.ymd(2014, 4, 1:30))
  (y <- cut.mondate(x, "weeks", start.on.monday = FALSE, attr.breaks = TRUE))
  checkTrue(!is.na(y[1]))
  checkEquals(as.character(y[1]), "04/05/2014")
  checkEquals(levels(y), c("04/05/2014", "04/12/2014", "04/19/2014", "04/26/2014", "05/03/2014"))
  
  # 2 weeks
  x <- c(mondate.ymd(2014, 3, 30:31), mondate.ymd(2014, 4, 1:30))
  (y <- cut.mondate(x, "2 weeks", attr.breaks = TRUE))
  checkTrue(is.na(y[1]))
  checkEquals(levels(y), c("04/13/2014", "04/27/2014", "05/11/2014"))
  (y <- cut.mondate(x, "2 weeks", start.on.monday = FALSE, attr.breaks = TRUE))
  checkTrue(!is.na(y[1]))
  checkEquals(levels(y), c("04/12/2014", "04/26/2014", "05/10/2014"))
}
test.cut.mondate.days <- function() {
  # "days"
  x <- mondate.ymd(2014, 4, c(1, 7))
  (y <- cut.mondate(x, "days", attr.breaks = TRUE))
  checkEquals(as.character(y), c(NA, "04/07/2014"))
  checkEquals(levels(y), c("04/02/2014", "04/03/2014", "04/04/2014", 
                           "04/05/2014", "04/06/2014", "04/07/2014"))
  (y <- cut.mondate(x, "days", include.lowest = TRUE, attr.breaks = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/07/2014"))
  checkEquals(levels(y), c("04/01/2014", "04/02/2014", "04/03/2014", 
                           "04/04/2014", "04/05/2014", "04/06/2014", 
                           "04/07/2014"))

  x <- mondate.ymd(2014, 4, c(1, 8))
  (y <- cut.mondate(x, "days", attr.breaks = TRUE))
  checkEquals(as.character(y), c(NA, "04/08/2014"))
  checkEquals(levels(y), c("04/02/2014", "04/03/2014", "04/04/2014", "04/05/2014", "04/06/2014", "04/07/2014", "04/08/2014"))

  (y <- cut.mondate(x, "days", include.lowest = TRUE, attr.breaks = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/08/2014"))
  checkEquals(levels(y), c("04/01/2014", "04/02/2014", "04/03/2014", "04/04/2014", "04/05/2014", "04/06/2014", "04/07/2014", "04/08/2014"))

  x <- mondate.ymd(2014, 4, c(1, 7))
  (y <- cut.mondate(x, "2 days", attr.breaks = TRUE))
  # old behavior was that the starting value was always min(x) even
  #   when right. Now when right, ending value always max(x)
  # checkEquals(as.character(y), c(NA, "04/08/2014"))
  checkEquals(as.character(y), c(NA, "04/07/2014"))
  # checkEquals(levels(y), c("04/04/2014", "04/06/2014", "04/08/2014"))
  checkEquals(levels(y), c("04/03/2014", "04/05/2014", "04/07/2014"))

  (y <- cut.mondate(x, "2 days", include.lowest = TRUE, attr.breaks = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/07/2014"))
  checkEquals(levels(y), c("04/01/2014", "04/03/2014", "04/05/2014", "04/07/2014"))

  x <- mondate.ymd(2014, 4, c(1, 8))
  (y <- cut.mondate(x, "2 days", attr.breaks = TRUE))
  checkEquals(as.character(y), c(NA, "04/08/2014"))
  checkEquals(levels(y), c("04/04/2014", "04/06/2014", "04/08/2014"))

  (y <- cut.mondate(x, "2 days", include.lowest = TRUE, attr.breaks = TRUE))
  checkEquals(as.character(y), c("04/02/2014", "04/08/2014"))
  checkEquals(levels(y), c("04/02/2014", "04/04/2014", "04/06/2014", "04/08/2014"))
  checkEqualsNumeric(attr(y, "breaks"), mondate(c("03/31/2014", "04/02/2014", 
                                                  "04/04/2014", "04/06/2014", 
                                                  "04/08/2014")))

  x <- mondate.ymd(2014, 4, c(1, 7))
  (y <- cut.mondate(x, "days", right = FALSE, attr.breaks = TRUE))
  checkEquals(as.character(y), c("04/01/2014", NA))
  (z <- cut.mondate(x, attr(y, "breaks"), right = FALSE))
  checkTrue(is.na(tail(z, 1)))
  (z <- cut.mondate(x, attr(y, "breaks"), right = FALSE, include.lowest = TRUE))
  checkEquals(as.character(z), c("[04/01/2014,04/02/2014)", 
                                 "[04/06/2014,04/07/2014]"))
  (y <- cut.mondate(x, "days", right = FALSE, include.lowest = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/07/2014"))
}
test.cut.mondate.months <- function() {
  x <- mondate(0:4)
  (y <- cut(x, "months", include.lowest = FALSE))
  checkTrue(is.na(y[1]))
  checkEquals(levels(y), c("01/31/2000", "02/29/2000", "03/31/2000", "04/30/2000"))
  (y <- cut(x, "months", right = FALSE))
  checkTrue(is.na(y[length(y)]))
  checkEquals(levels(y), c("12/01/1999", "01/01/2000", "02/01/2000", "03/01/2000"))
  (y <- cut(x, "months", right = TRUE, include.lowest = TRUE))
  checkTrue(!is.na(y[1]))
  checkEquals(levels(y), c("12/31/1999", "01/31/2000", "02/29/2000", "03/31/2000", "04/30/2000"))
  (y <- cut(x, "months", right = TRUE, include.lowest = TRUE, attr.breaks = TRUE))
  checkEqualsNumeric(attr(y, "breaks"), mondate(-1:4))
  
  # Test for non-NA when scalar x on month boundary
  (x <- mondate.ymd(2008, 6))
  (y <- cut(x, "month", right = TRUE))
  checkTrue(!is.na(y))
  checkEquals(levels(y), "06/30/2008")
  (y <- cut(x, "month", right = FALSE))
  checkTrue(!is.na(y))
  checkEquals(levels(y), "06/01/2008")
  
  x <- mondate.ymd(2015, 1:12)
  (y <- cut(x, "month", right = TRUE, include.lowest = TRUE))
  (y <- cut(x, "month", right = FALSE, include.lowest = TRUE))
  (y <- cut(x, "month", right = TRUE, include.lowest = FALSE))
  (y <- cut(x, "month", right = FALSE, include.lowest = FALSE))
  (y <- cut(x, "month", right = TRUE, include.lowest = TRUE, attr.breaks = TRUE))
  (y <- cut(x, "month", right = FALSE, include.lowest = TRUE, attr.breaks = TRUE))
  (y <- cut(x, "month", right = TRUE, include.lowest = FALSE, attr.breaks = TRUE))
  (y <- cut(x, "month", right = FALSE, include.lowest = FALSE, attr.breaks = TRUE))
  # demo recut with breaks as might occur with Date's
  res <- cut(x, "month", right = FALSE, include.lowest = TRUE, attr.breaks = TRUE)
  b <- attr(res, "breaks")
  (u <- cut(as.Date(x), as.Date(b)))
  (v <- cut(as.Date(x), "month"))
  checkTrue(identical(u, v))
}
