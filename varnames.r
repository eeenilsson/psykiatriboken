
source('../functions/make_namedlist.r')

common_varnames <- c(

## table column labels
    'var' = "Variable",
    'line' = "Line",
    'hand' = "Hand",
    'level' = "Category",
    'n' = "N",
    'count_valid' = "Valid n",
    'events' = "Events, n",
    'ip_percent' = "IP (95% CI), %",
    'atrisk' = "At risk, n",
    'or' = "Crude OR (95% CI)",
    'or_adj1' = "Adjusted OR (95% CI)",
    'ip' = "IP, %",
    'rr' = "RR, ratio",
    'rd'  = "RD, %",
    'par' = "PAR, %",
    'pval_adj1' = "P-value for adjusted OR",
    'n_yes' = "n",
    'freq' = "n",
    'percent_yes' = "%",
    'percent' = "%",
    'no' = "No",
    'yes' = "Yes",
    'all' = "All",
    'pval' = "P-value",
    'p_chisq' = "P-value",
    'key' = "Variable",

    ## statistical notation
    'mean' = "M",
    'sd' = "SD",
    'median' = "Mdn",
    'iqi' = "IQI"

)

varnames <- common_varnames

tmp <- read_csv('varnames_svenska.csv')
labs <- make_namedlist(tmp, "varnames", "labels")
varnames <- append(varnames[!names(varnames) %in% names(labs)], labs)
