library(targets)
library(tarchetypes)
# This is an example target script.
# Read the tar_script() help file for details.

# Define custom functions and other global objects.
# This is where you write source(\"R/functions.R\")
# if you keep your functions in external scripts.
summ = function(dataset) {
  summarize(dataset, mean_x = mean(x))
}



# Set target-specific options such as packages.
pkgs = c("dplyr", "dftTrafficCounts")
tar_option_set(packages = pkgs)

# Define targets
tar_pipeline(
  tar_target(data, data.frame(x = sample.int(100), y = sample.int(100))),
  tar_target(summary, summ(data))
  , # Call your custom functions as needed.
  tar_render(readme, "README.Rmd", output_format = "github_document", output_file = "README.md")
)

# End with a call to tar_pipeline() to wrangle the targets together.
# This target script must return a pipeline object.
