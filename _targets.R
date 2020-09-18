library(targets)
library(tarchetypes)
# This is an example target script.
# Read the tar_script() help file for details.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.

summ = function(dataset) {
  summary(dataset)
}

# dft_all = tar_read(data)
# names(dft_all)
summary_dft_mode_year = function(data, v = c("pedal_cycles", "all_motor_vehicles"), gv = "year") {
  data %>%
    select(contains(c(gv, v))) %>%
    group_by(year) %>%
    summarise_all(sum) %>%
    tidyr::pivot_longer(cols = contains(v))
}

# Set target-specific options such as packages.
# pkgs = c("dplyr", "dftTrafficCounts")
pkgs = c("dplyr")
tar_option_set(packages = pkgs)
devtools::load_all()

# Define targets
tar_pipeline(
  tar_target(data, dtc_import(u = "http://data.dft.gov.uk/road-traffic/dft_traffic_counts_raw_counts.zip")),
  tar_target(summary_dft, summ(data)),
  tar_target(summary_mode, summary_dft_mode_year(data)),
  tar_render(readme, "README.Rmd", output_format = "github_document", output_file = "README.md")
)

# End with a call to tar_pipeline() to wrangle the targets together.
# This target script must return a pipeline object.
