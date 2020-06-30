library(dplyr)

args = commandArgs(trailingOnly = TRUE)
input = args[1]
output = args[2]

snps = read.delim(input,
                  stringsAsFactors = FALSE,
                  header = TRUE,
                  sep = '\t')
not_any_na = function(x) all(!is.na(x))
snps = select_if(snps, not_any_na)

rng = list('QUAL' = c(0.48, 3), 'DP' = c(0, 4.59), 'VDB' = c(0, 1),
           'SGB' = c(-22542, 9834), 'RPB' = c(0, 1), 'MQB' = c(0, 1),
           'MQSB' = c(0, 1.01), 'BQB' = c(0, 1.013), 'MQ0F' = c(0, 1),
           'ICB' = c(0, 1), 'HOB' = c(0, 0.8), 'AN' = c(2, 322),
           'MQ' = c(0, 60))

df = as.data.frame(t(data.frame(rng)))
df$V3 = c(3:13, 15, 17)

pdf(output)
for(i in 1:13) {
  if(df$V3[i] %in% c(3, 4)) {
      hist(x = log10((snps[, df$V3[i]])), col = 'gold', breaks = 200,
       xlim = c(df$V1[i], df$V2[i]),
       main = colnames(snps)[df$V3[i]])
  }
  if(!(df$V3[i] %in% c(3, 4))) {
  hist(x = na.omit(as.numeric(snps[, df$V3[i]])), col = 'gold', breaks = 200,
       xlim = c(df$V1[i], df$V2[i]),
       main = colnames(snps)[df$V3[i]])
  }
}
dev.off()
