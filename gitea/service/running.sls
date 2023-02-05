# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

include:
  - {{ sls_config_file }}

Gitea is running:
  service.running:
    - name: {{ gitea.lookup.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
      - Gitea binary is installed
