library(dplyr)

args = commandArgs(trailingOnly = TRUE)
input = args[1]
output = args[2]

indels = read.delim(input,
                    stringsAsFactors = FALSE,
                    header = TRUE,
                    sep = '\t')
not_any_na = function(x) all(!is.na(x))
indels = select_if(indels, not_any_na)

rng = list('QUAL' = c(0.48, 3), 'DP' = c(0, 4.57), 'VDB' = c(0, 1),
           'SGB' = c(-29947, 9351), 'MQ0F' = c(0, 1), 'ICB' = c(0, 1),
           'HOB' = c(0, 0.75), 'AN' = c(2, 322), 'MQ' = c(0, 60),
           'IDV' = c(1, 284), 'IMF' = c(0, 1), 'MQSB' = c(0, 1))

df = as.data.frame(t(data.frame(rng)))
df$V3 = c(3:9, 11, 13:16)

pdf(output)
for(i in 1:12) {
  if(df$V3[i] %in% c(3, 4)) {
      hist(x = log10((indels[, df$V3[i]])), col = 'gold', breaks = 200,
       xlim = c(df$V1[i], df$V2[i]),
       main = colnames(indels)[df$V3[i]])
  }
  if(!(df$V3[i] %in% c(3, 4))) {
  hist(x = na.omit(as.numeric(indels[, df$V3[i]])), col = 'gold', breaks = 200,
       xlim = c(df$V1[i], df$V2[i]),
       main = colnames(indels)[df$V3[i]])
  }
}
dev.off()
