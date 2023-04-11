# vim: ft=sls

{#-
    Removes the built ``chroma`` binary, the build path and the
    ``grst`` script.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Gitea RST external renderer is absent:
  file.absent:
    - names:
      - {{ gitea.lookup.mod_rst.chroma_build_path }}
      - {{ gitea.lookup.mod_rst.chroma_bin }}
      - {{ gitea.lookup.mod_rst.path }}
