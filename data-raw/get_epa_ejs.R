# EPA Environmental Justice Screening and Mapping Tool
library(sf)
library(httr)
library(data.table)
library(tidyverse)

years <- c(2017:2021)
ncr_fips <- c("^24021|^24031|^24033|^24017|^11001|^51107|^51059|^51153|^51013|^51510|^51683|^51600|^51610|^51685")
va_fips <- c("^51")

# download data
for(year in years){
  file <- paste0("epa_ejs_", year, ".gdb.zip")
  url <- paste0("https://gaftp.epa.gov/EJSCREEN/", year, "/EJSCREEN_", year, "_StatePctile.gdb.zip")
  GET(url, write_disk(file, overwrite = TRUE))
}

# file names
files <- paste0("epa_ejs_", years, ".gdb.zip")

# subset to ncr and va, write csvs
for(file in files){
  layer <- st_read(file)
  layer <- layer %>% st_drop_geometry()
  ncr <- layer %>% dplyr::filter(str_detect(ID, ncr_fips))
  va <- layer %>% dplyr::filter(str_detect(ID, va_fips))
  name <- str_extract(file, "[^\\.]+")
  write.csv(ncr, paste0("ncr_", name, ".csv"))
  write.csv(va, paste0("va_", name, ".csv"))
}

va_epa_ejs_2017 <- read_csv("va_epa_ejs_2017.csv") %>% mutate(year = 2017, region_type = "block group", geoid = ID)
va_epa_ejs_2018 <- read_csv("va_epa_ejs_2018.csv") %>% mutate(year = 2018, region_type = "block group", geoid = ID)
va_epa_ejs_2019 <- read_csv("va_epa_ejs_2019.csv") %>% mutate(year = 2019, region_type = "block group", geoid = ID)
va_epa_ejs_2020 <- read_csv("va_epa_ejs_2020.csv") %>% mutate(year = 2020, region_type = "block group", geoid = ID)
va_epa_ejs_2021 <- read_csv("va_epa_ejs_2021.csv") %>% mutate(year = 2021, region_type = "block group", geoid = ID)

ncr_epa_ejs_2017 <- read_csv("ncr_epa_ejs_2017.csv") %>% mutate(year = 2017, region_type = "block group", geoid = ID)
ncr_epa_ejs_2018 <- read_csv("ncr_epa_ejs_2018.csv") %>% mutate(year = 2018, region_type = "block group", geoid = ID)
ncr_epa_ejs_2019 <- read_csv("ncr_epa_ejs_2019.csv") %>% mutate(year = 2019, region_type = "block group", geoid = ID)
ncr_epa_ejs_2020 <- read_csv("ncr_epa_ejs_2020.csv") %>% mutate(year = 2020, region_type = "block group", geoid = ID)
ncr_epa_ejs_2021 <- read_csv("ncr_epa_ejs_2021.csv") %>% mutate(year = 2021, region_type = "block group", geoid = ID)

# COLUMNS DON'T MATCH, DIFFERENT MEASURES FOR EACH YEAR, need to look into this
va_epa_ejs <- rbind(va_epa_ejs_2017, va_epa_ejs_2018) %>% rbind(va_epa_ejs_2019) %>% rbind(va_epa_ejs_2020) %>% rbind(va_epa_ejs_2021)
ncr_epa_ejs <- rbind(ncr_epa_ejs_2017, ncr_epa_ejs_2018) %>% rbind(ncr_epa_ejs_2019) %>% rbind(ncr_epa_ejs_2020) %>% rbind(ncr_epa_ejs_2021)


