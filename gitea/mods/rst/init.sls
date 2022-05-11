# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- set sls_go_install = tplroot ~ '.go' %}
{%- from tplroot ~ "/map.jinja" import mapdata as gitea with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_go_install }}

RST external renderer pkg dependencies are installed:
  pkg.installed:
    - pkgs: {{ gitea.lookup.mod_rst.pkg_dependencies | json }}

RST external renderer pip dependencies are installed:
  pip.installed:
    - names: {{ gitea.lookup.mod_rst.pip_dependencies | json }}
    - require:
      - RST external renderer pkg dependencies are installed

Chroma is cloned:
  file.directory:
    - name: {{ gitea.lookup.mod_rst.chroma_build_path }}
    - makedirs: true
    - user: {{ gitea.lookup.build_user }}
    - mode: '0755'
  git.latest:
    - name: {{ gitea.lookup.mod_rst.chroma_repo }}
    - target: {{ gitea.lookup.mod_rst.chroma_build_path }}
    - rev: {{ gitea.lookup.mod_rst.chroma_rev }}
    - user: {{ gitea.lookup.build_user }}
    - force_reset: true
    - require:
      - file: {{ gitea.lookup.mod_rst.chroma_build_path }}

Chroma is installed:
  file.directory:
    - name: {{ salt["file.dirname"](gitea.lookup.mod_rst.chroma_bin) }}
  cmd.run:
    - name: {{ gitea.lookup.build_user_home | path_join("go", "bin", "go") }} build -o '{{ gitea.lookup.mod_rst.chroma_bin }}'
    - cwd: {{ gitea.lookup.mod_rst.chroma_build_path | path_join("cmd", "chroma") }}
    - runas: {{ gitea.lookup.build_user }}
    - require:
      - RST external renderer pkg dependencies are installed
      - file: {{ salt["file.dirname"](gitea.lookup.mod_rst.chroma_bin) }}
      - sls: {{ sls_go_install }}
    - onchanges:
      - Chroma is cloned

RST external renderer is installed:
  file.managed:
    - name: {{ gitea.lookup.mod_rst.path }}
    - source: {{ files_switch(['grst'],
                              use_subpath=True,
                              lookup='RST external renderer is installed'
                 )
              }}
    - mode: '0755'
    - user: root
    - group: {{ gitea.lookup.rootgroup }}
    - template: jinja
    - context:
        gitea: {{ gitea | json }}
    - require:
      - RST external renderer pip dependencies are installed
