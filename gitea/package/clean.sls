# vim: ft=sls

{#-
    Removes Gitea.
    Has a dependency on `gitea.config.clean`_.
#}

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}

include:
  - {{ sls_config_clean }}

# This does not delete the working/data dirs to prevent accidental loss.
Gitea package files are absent:
  file.absent:
    - names:
      - {{ gitea.lookup.service.unit.format(name=gitea.lookup.service.name) }}
      - {{ gitea.lookup.paths.bin | path_join('gitea') }}
{%- for p in ['conf', 'custom', 'log'] %}
      - {{ gitea.lookup.paths[p] }}
{%- endfor %}
      # to make sure this can be installed again (onchanges req in package.installed)
      - /tmp/gitea-{{ gitea.version }}
    - require:
      - sls: {{ sls_config_clean }}

Gitea user/group are absent:
  user.absent:
    - name: {{ gitea.lookup.user }}
    - require:
      - sls: {{ sls_config_clean }}
  group.absent:
    - name: {{ gitea.lookup.group }}
    - require:
      - sls: {{ sls_config_clean }}
