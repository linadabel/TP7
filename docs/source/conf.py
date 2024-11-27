# -- Project information -----------------------------------------------------

project = 'Sum Project'  
author = 'Nesrine'     
release = '1.0'          

# -- General configuration ---------------------------------------------------

extensions = [
    'sphinx.ext.autodoc',  
    'sphinx.ext.viewcode',  
]

templates_path = ['_templates']
exclude_patterns = []

# -- Options for HTML output -------------------------------------------------

html_theme = 'alabaster'  
html_static_path = ['_static']
