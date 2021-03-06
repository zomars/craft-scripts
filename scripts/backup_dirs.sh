#!/bin/bash

# Backup Files
#
# Backup local files to a timestamped archive
#
# @author    nystudio107
# @copyright Copyright (c) 2017 nystudio107
# @link      https://nystudio107.com/
# @package   craft-scripts
# @since     1.1.0
# @license   MIT

# Get the directory of the currently executing script
DIR="$(dirname "${BASH_SOURCE[0]}")"

# Include files
INCLUDE_FILES=(
            "common/defaults.sh"
            ".env.sh"
            "common/common_env.sh"
            )
for INCLUDE_FILE in "${INCLUDE_FILES[@]}"
do
    if [ -f "${DIR}/${INCLUDE_FILE}" ]
    then
        source "${DIR}/${INCLUDE_FILE}"
    else
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
done

BACKUP_FILES_DIR_PATH="${LOCAL_BACKUPS_PATH}${LOCAL_DB_NAME}${FILES_BACKUP_SUBDIR}/"

# Make sure the asset backup directory exists
if [[ ! -d "${BACKUP_FILES_DIR_PATH}" ]] ; then
    echo "Creating backup directory ${BACKUP_FILES_DIR_PATH}"
    mkdir -p "${BACKUP_FILES_DIR_PATH}"
fi

# Backup the files dirs via rsync
for DIR in "${LOCAL_DIRS_TO_BACKUP[@]}"
do
    rsync -F -L -a -z "${DIR}" "${BACKUP_FILES_DIR_PATH}" --progress
    echo "*** Backed up assets from ${DIR}"
done

# Normal exit
exit 0

