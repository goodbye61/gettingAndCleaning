


# Variables.
# act:  activities 
# feat: features 
# focusing : features that contain 'mean' or 'std' labels
# extract:   Processed data table. 


act <- read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
feat <- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)

focusing <- grep("mean|std", feat[,2])

extract <- feat[focusing,2]
extract <- gsub("-mean()","Mean",extract)
extract <- gsub("-std()","Std",extract)
extract <- gsub("[-()]", "" , extract)


train  <- read.table("./UCI HAR Dataset/train/X_train.txt")[focusing]
tsub   <- read.table("./UCI HAR Dataset/train/subject_train.txt")
ty     <- read.table("./UCI HAR Dataset/train/y_train.txt")

test   <- read.table("./UCI HAR Dataset/test/X_test.txt")[focusing]
tetsub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
tety   <- read.table("./UCI HAR Dataset/test/y_test.txt")

train <- cbind(tsub,ty,train)
test <- cbind(tetsub,tety,test)
alldat <- rbind(train,test)

all(colSums(is.na(alldat)) == 0)


colnames(alldat) <- c("subject","activity",extract)

alldat$activity <- factor(alldat$activity, levels = act[,1], labels = act[,2])
alldat$subject <- as.factor(alldat$subject)

# Now , I want to make dataset in unique labels with 'subject' & 'activity' 

mlt <- melt(alldat, id = c("subject","activity"))
mean_by_ac <-dcast(mlt, subject+activity ~ variable, mean)
write.table(x = mean_by_ac, file = "./UCI HAR Dataset/pj.txt",quote = FALSE,row.names = FALSE)
