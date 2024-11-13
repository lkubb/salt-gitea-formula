.. _readme:

Gitea Formula
=============

|img_sr| |img_pc|

.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Manage Gitea with Salt.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Special notes
-------------
* This installs from the `official binary source <https://dl.gitea.io/gitea/>`_.
* The formula is currently Linux/systemd-centric. It should be relatively easy to provide the correct parameters and service file for other platforms though.
* Since the formula skips the web installer, you will need to provide at least the database configuration.
* You can optionally specify the secrets, but they can be autogenerated by Salt as well. In that case, they will be saved in a separate file inside your config dir.
* All the paths are modifiable, find them in ``lookup:paths``. You should not need to set the corresponding values in your config, they are added automatically.
* If Gitea requires mounts for some of the paths, you can specify them in ``service:requires_mount`` as a list.
* If Gitea requires a local service unit (e.g. Redis server), specify it/them in ``service:wants`` as a list. This formula will do its best to automatically add a locally running database service to this list.

RST mod
^^^^^^^
This formula provides basic support for installing an external ``rst`` renderer. This especially makes Gitea display ``README.rst`` files similar to as it does for ``README.md``.

The installation is not included by default, you will have to specifically target ``gitea.mods.rst`` to the minion. Furthermore, you will have to setup the external renderer in your ``app.ini`` similar to:

.. code-block:: yaml

  markup.restructuredtext:
    enabled: true
    file_extensions: '.rst'
    render_command: timeout 30s /usr/local/bin/grst
    is_input_file: true
  markup.sanitizer.restructuredtext:
    element: pre
    allow_attr: class
    regexp: ''

The mod compiles ``chroma`` (the syntax highlighting library that is used by Gitea) from source and installs a Python script that renders RST files, which currently relies on ``chroma`` and the ``docutils`` python package. The parameters can be modified in ``gitea:lookup:mod_rst``. I currently use this to patch ``*.sls``, ``*.jinja`` and ``*.j2`` highlighting into ``chroma``.


Configuration
-------------
An example pillar is provided, please see `pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in `map.jinja`.

<INSERT_STATES>

Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.
