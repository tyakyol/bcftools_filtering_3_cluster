args = commandArgs(trailingOnly = TRUE)
input = args[1]
output = args[2]

df = read.table(input,
                stringsAsFactors = FALSE,
                header = FALSE,
                skip = 1,
                col.names = paste0("V",seq_len(max(count.fields(input, sep = '\t')))),
                fill = TRUE)
df = df[, -1 * 1:4]

splitter = function(x) {
  out = c()
  sp = strsplit(x, split = ':')
  for(i in 1:length(sp)) {
    if(length(sp[[i]]) == 0) {
      out[i] = ''
    } else {
      out[i] = sp[[i]][2]
    }
  }
  return(as.integer(out))
}

df2 = apply(df, 2, splitter)

selectforhist = c()
for(i in 1:nrow(df2)) {
  a = df2[i, ]
  a = a[-which.max(a)]
  selectforhist = append(selectforhist, a)
  selectforhist = na.omit(selectforhist)
}

pdf(output)
hist(selectforhist, col = 'gold',
     breaks = 200,
     main = '',
     xlab = 'Minor allele count')
dev.off()
