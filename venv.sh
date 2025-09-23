#!/bin/bash

PYTHON_REQUIREMENTS_FILE=requirements.txt
PYTHON_VERSION=python3.12

download_galaxy () {
  ansible-galaxy install -r "${CUR_MOL_VENV_DIR}"/roles/requirements.yml -p "${CUR_MOL_VENV_DIR}"/roles/ --force
}

setup_env () {
  git update-index --skip-worktree .vault_pass.txt
  dir=$(basename "${CUR_MOL_VENV_DIR}")
  if [[ -d "${CUR_MOL_VENV_DIR}/.virtualenv" ]]
  then
    source ${CUR_MOL_VENV_DIR}/.virtualenv/${dir}/bin/activate
  else
    virtualenv -p `which ${PYTHON_VERSION}` "${CUR_MOL_VENV_DIR}"/.virtualenv/"${dir}" && source ${CUR_MOL_VENV_DIR}/.virtualenv/${dir}/bin/activate
    python -m pip install --upgrade pip
    python -m pip install -r "${CUR_MOL_VENV_DIR}"/${PYTHON_REQUIREMENTS_FILE}
  fi
}

update_requirements () {
  _python_requirements_file=$PYTHON_REQUIREMENTS_FILE
  PYTHON_REQUIREMENTS_FILE=requirements.update.txt
  rebuild_env
  PYTHON_REQUIREMENTS_FILE=$_python_requirements_file
  python -m pip freeze > "${CUR_MOL_VENV_DIR}"/$PYTHON_REQUIREMENTS_FILE
}

rebuild_env () {
  deactivate
  rm -rf "${CUR_MOL_VENV_DIR}"/.virtualenv
  setup_env
}

test_lint() {
  ansible-lint
  yamllint -c .yamllint .
  flake8
}

run_tests() {
  test_lint
  molecule test --all
}

if [[ ! -f "venv.sh" ]]; then
  echo "Sourcing must be done in the base directory"
  return 1
fi

CUR_MOL_VENV_DIR=`pwd`
setup_env

echo "############################################################"
echo "Type 'deactivate' to quit venv"
echo "Type 'download_galaxy' to download ansible roles"
echo "Type 'rebuild_env' to recreate your virtualenv"
echo "Type 'update_requirements' to update your requirements.txt"
echo "Type 'test_lint' to run the linters"
echo "Type 'run_tests' to run the tests"
echo "############################################################"
