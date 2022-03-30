#!/bin/zsh
# Configuration related to Hammerspoon

export HAMMERSPOON_SRC=${HOME}/develop/hammerspoon
export HAMMERSPOON_VENV=${HOME}/.virtualenvs/hammerspoon

hammerspoon-make-doc() {
  # Do in subshell we we dont change caller's shell
  (
    ${HAMMERSPOON_VENV}/bin/python \
    ${HAMMERSPOON_SRC}/scripts/docs/bin/build_docs.py \
      --templates ${HAMMERSPOON_SRC}/scripts/docs/templates/ \
      --output_dir . \
      --json --html --markdown --standalone ${(q)@} .
  )
}
