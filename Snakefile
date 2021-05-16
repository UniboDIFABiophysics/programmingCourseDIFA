files = [
    "Lesson_00_details_about_the_exam.ipynb",
    "Lesson_01_introduction.ipynb",
    "Lesson_02_reviewing_fundamentals_of_programming.ipynb",
    "Lesson_03_version_control.ipynb",
    "Lesson_04_testing.ipynb",
    "Lesson_05_debugging_and_logging__kill_the_print.ipynb",
    "Lesson_06_Vectorization.ipynb",
    "Lesson_07_Scientific_computation_libraries.ipynb",
    "Lesson_08_Data_pipelines_and_Snakemake.ipynb",
    "Lesson_09_DataFrame_and_Pandas.ipynb",
    "Lesson_10_object_oriented_programming_sklearn.ipynb",
    "Lesson_AF_01_random_generation_and_montecarlo.ipynb",
    "Lesson_AF_02_Differential_Equations_analysis.ipynb",
    "Lesson_AF_03_continuous_time_random_walks.ipynb",
    "Lesson_AF_04_random_chain_text_generation.ipynb",
    "Lesson_AF_05_functional_programming_part_1.ipynb",
    "Lesson_AF_06_functional_programming_part_2.ipynb",
    "Lesson_AF_07_command_line_applications.ipynb",
    "Lesson_AF_08_Documentation_and_API.ipynb",
    "Lesson_AF_09_random_sampling_and_statistics.ipynb",
    "Lesson_AF_10_remote_server_management.ipynb",
]

rule all:
  input:
    [f.replace("ipynb", "html") for f in files]+[f.replace("ipynb", "md") for f in files]+[f.replace("ipynb", "slides.html") for f in files]

rule html_all:
  input:
    [f.replace("ipynb", "html") for f in files]

rule markdown_all:
  input:
    [f.replace("ipynb", "md") for f in files]

rule slides_all:
  input:
    [f.replace("ipynb", "slides.html") for f in files]

rule make_html:
  input:
    "{lesson}.ipynb"
  output:
    "{lesson}.html"
  shell:
    "jupyter nbconvert --to html {input}"

rule make_markdown:
  input:
    "{lesson}.ipynb"
  output:
    "{lesson}.md"
  shell:
    "jupyter nbconvert --to markdown {input}"

rule make_slides:
  input:
    "{lesson}.ipynb"
  output:
    "{lesson}.slides.html"
  shell:
    "jupyter nbconvert --to slides {input}"


