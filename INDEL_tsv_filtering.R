library(dplyr)

args = commandArgs(trailingOnly = TRUE)
input = args[1]
output = args[2]

indels = read.delim(input,
                  stringsAsFactors = FALSE,
                  header = TRUE,
                  sep = '\t')
# Remove columns with all NA
not_any_na = function(x) all(!is.na(x))
indels = select_if(indels, not_any_na)
# Gifu is either 0/0 or 0/1
indels = indels[indels$X.9.results.sorted_Gifu_R.bam.GT %in% c('0/0', '0/1'), ]
# MQ >= 40
indels = indels[indels$X.8.MQ >= 40, ]
# DP >= 200
indels = indels[indels$X.4.DP >= 200, ]
# HOB <= 0.05
indels = indels[indels$X.5.HOB <= 0.05, ]
# MQSB >= 0.5
indels = indels[indels$X.6.MQSB >= 0.5, ]
#MQ0F <= 0.05
indels = indels[indels$X.7.MQ0F <= 0.05, ]
# Missing < 50%
missing = apply(indels[, 9:169], 1, function(x) sum(x == './.'))
indels = indels[missing <= 81, ]
# Must be biallelic
biallelic = apply(indels[, 9:169], 1, function(x) names(table(x)))
biallelic = unlist(biallelic)
biallelic = levels(factor(biallelic))
biallelic = biallelic[!(biallelic %in% c('./.', '0/0', '0/1', '1/1'))]
biallelic = (apply(indels, 1, function(x) sum(!(x %in% biallelic))))
indels = indels[biallelic == 169, ]
positions = indels[, 1:2, drop = FALSE]
# Output
write.table(positions, file = output,
            quote = FALSE, sep = '\t',
            row.names = FALSE, col.names = FALSE)
