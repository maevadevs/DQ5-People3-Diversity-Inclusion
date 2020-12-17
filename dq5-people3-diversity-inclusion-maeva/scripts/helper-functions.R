### This function allows to get a key from a .env file and return the value of that key
### If none found, it will return NULL

get_key <- function(filepath, key) {
  # Loading API Secret file contents as a dataframe
  secrets <- read.table(
    file=filepath,
    header=FALSE,
    sep="=",
    col.names=c("key","value")
  )
  
  # Set "key" as the dataframe index
  rownames(secrets) <- secrets$key
  
  # Drop the "key" column
  secrets = subset(secrets, select = -c(key))
  
  # Selecting the key's value and return
  return(secrets[key, "value"])
}