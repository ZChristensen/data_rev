list.of.packages <- c("readr","varhandle")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only=T)

if(.Platform$OS.type == "unix"){
  prefix = "~"
}else{
  prefix = "E:"
}

wd = paste0(prefix,"/git/data_rev")
setwd(wd)

`%notin%` <- function(x,y) !(x %in% y) 



ihsn_raw=read.csv("http://catalog.ihsn.org/index.php/catalog/export/csv?ps=10000&collection[]=")

ihsn_raw$global=grepl("World Bank|World Health Organization|World Food|Values",ihsn_raw$authenty,ignore.case = T,useBytes = T)

ihsn=ihsn_raw[which(ihsn_raw$global!=T),]



# source("https://raw.githubusercontent.com/akmiller01/alexm-util/master/DevInit/R/fuzzy_match.R")
# meta$Short.Name=unfactor(meta$Short.Name)  
# dictionary=fuzzy(ihsn$nation,meta$Short.Name)
# dictionary$y=unfactor(dictionary$y)
# dictionary$x=unfactor(dictionary$x)
# dictionary$y[which(dictionary$x=="République Démocratique du Congo")]="Dem. Rep. Congo"
# dictionary$y[which(dictionary$x=="Africa")]="Africa"
# dictionary$y[which(dictionary$x=="Bénin")]="Benin"
# dictionary$y[which(dictionary$x=="Cape Verde")]="Cabo Verde"
# dictionary$y[which(dictionary$x=="Congo Democratic Republic")]="Dem. Rep. Congo"
# dictionary$y[which(dictionary$x=="Congo, Dem. Rep.")]="Dem. Rep. Congo"
# dictionary$y[which(dictionary$x=="Latin America")]="Latin America"
# dictionary$y[which(dictionary$x=="DPR Korea")]="Dem. People's Rep. Korea"
# dictionary$y[which(dictionary$x=="Guiné-Bissau")]="Guinea-Bissau"
# dictionary$y[which(dictionary$x=="République Démocratique du Congo")]="Dem. Rep. Congo"
# dictionary$y[which(dictionary$x=="Saint Lucia")]="St. Lucia"
# dictionary$y[which(dictionary$x=="St. Vincent & Grenadines")]="St. Vincent and the Grenadines"
# dictionary$y[which(dictionary$x=="Swaziland")]="eSwatini"
# dictionary$y[which(dictionary$x=="Sénégal")]="Senegal"
# dictionary$y[which(dictionary$x=="Timor Leste")]="Timor-Leste"
# dictionary$y[which(dictionary$x=="Viet Nam")]="Vietnam"
# dictionary$nation=dictionary$x
# dictionary$Short.Name=dictionary$y
# dictionary=dictionary[,c("nation","Short.Name")]
# meta=read.csv("code/metadata.csv")
# meta=merge(meta,dictionary,by=c("Short.Name"))
# fwrite(meta,"code/metadata.csv")
meta=read.csv("code/metadata.csv")
African.meta=subset(meta, WB.Region %in% c("Sub-Saharan Africa","Middle East & North Africa"))
African.meta=subset(African.meta, Short.Name %notin% c("Iran, Islamic Rep."
                                          ,"Jordan"
                                          ,"Lebanon"
                                          ,"West Bank and Gaza"
                                          ,"Syrian Arab Republic"
                                          ,"Yemen"
                                          ,"Iraq"
                                          ,"Israel"
                                          ,"Malta"
                                          ,"Iran, Islamic Rep."))
African.meta=African.meta[,c("di_id","nation")]
ihsn=merge(ihsn,African.meta,by=c("nation"))
ihsn$di_id=unfactor(ihsn$di_id)
ihsn$di_id[which(ihsn$nation=="Namimbia")]="NA"


latest=data.table(ihsn)[,.SD[which.max(data_coll_start)],by=c("di_id")]
fwrite(latest,"data/latest_survey.csv")
