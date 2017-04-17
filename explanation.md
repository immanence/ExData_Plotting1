The four scripts in this repo each download and unzip electric power consumption data and then make a png file containing a specifically formatted plot.  

The raw data as over two million lines with nine columns each.  The first two columns contain strings of  6 to 8 characters, so assume 8 bytes each to be conservative.  For the numerics in the other seven columns, also assume 8 bytes each.  Thus we have 8 bytes * 9 columns * 2,075,259 rows = 149,418,648 bytes.  Divide this by 1024 squared (1,048,576) to get 142.5 megabytes, which most computers should be able to handle.  The unzipped file I can see using the folders on my Mac is indeed a bit less at 133 megabytes.

Nevertheless, to be efficient, I don't want to create an object in R of that size.  Therefore I read the lines (but don't save them) while using grep to return the indices for the two dates we want (1 and 2 February 2007).  I then read the table into a dataframe that has rows for only the minutes (2,880 of them) in these two days.  When doing this I make the date and time columns read in as strings rather than factors, and check for "?" to assign them NA values for proper plotting.  This dataframne is then maninpulated (via strptime function) to contain a column of POSIXlt date-times.  After that the data are used to make the plots (all of which use the POSIXlt column as the horizontal axis).