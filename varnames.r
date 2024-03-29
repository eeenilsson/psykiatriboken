
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
    'adjustment' = "Adjustment",
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
    'alternative' = "Alternativ",
    'item' = "Nr",
    'drug' = "Läkemedel",
    'strength' = "Styrka",
    'dose' = "Dos",
    'route' = "Adm",
    'maximum_dose_24h' = "Maxdos/24h",
    'placebo' = "Placebo",
    'antidepressant' = "Antidepressivt läkemedel",
    'adultbelowsixtysix' = "Vuxen < 66 år",
    'fiftyfiveplus' ="55+", 
    'sixtyfiveplus' = "65+",
    'antipsychotic' = "Antipsykotiskt läkemedel",
    'clinical_anticholinergic' = "Klinisk antikolinerg effekt",
    'binding_affinity' = "Affinitet (Ki)",

    ## svenska namn
    'clozapine' = "Klozapin",
    'thioridazine' = "Thioridazin",
    'chlorpromazine' = "Klorpromazin",
    'methotrimeprazine' = "Metotrimeprazin",
    'olanzapine' = "Olanzapin",
    'loxapine' = "Loxapin",
    'quetiapine' = "Kvetiapin",
    'fluphenazine' = "Flufenazin",
    'flupenthixol' = "Flupentixol",
    'flupentixol' = "Flupentixol",
    'haloperidol' = "Haloperidol",
    'risperidone' = "Risperidon",
    'aripiprazole' = "Aripiprazol",
    'ziprasidone' = "Ziprasidon",
    'lurasidone' = "Lurasidon",
    'cariprazine' = "Kariprazin",
    
    ## statistical notation
    'mean' = "M",
    'sd' = "SD",
    'median' = "Mdn",
    'iqi' = "IQI",

    'prevention_any' = "Prevention båda",
    'prevention_mania' = "Prevention mani",
    'prevention_depression' = "Prevention depression",
    'medication' = "Läkemedel",
    'mania' = "Mani",
    'depression' = "Depression",
    'features_mania' = "Särskilt vid",
    'features_depression' = "Särskilt vid",
    'features_prevention' = "Särskilt vid",
    'substance' = "Substans",
    'unit' = "Enhet",
    'therapeutic_lower' = "Nedre terapeutisk nivå",
    'therapeutic_upper' = "Övre terapeutisk nivå",
    'therapeutic_max' = "Maximal terapeutisk nivå",
    'toxic' = "Toxisk nivå"

    

)

varnames <- common_varnames

tmp <- read_csv('varnames_svenska.csv')
labs <- make_namedlist(tmp, "varnames", "labels")
varnames <- append(varnames[!names(varnames) %in% names(labs)], labs)
