#!/bin/bash
#
# This script is run when the Drupal docker container is ready. It prepares
# an environment for development or testing, which contains a full Drupal
# 8 installation with a running website and our custom modules.
#
set -e

echo "Will try to connect to MySQL container until it is up. This can take about 15 seconds."
OUTPUT="ERROR"
while [[ "$OUTPUT" == *"ERROR"* ]]
do
  OUTPUT=$(echo 'show databases'|{ mysql -h mysql -u root --password=drupal 2>&1 || true; })
  if [[ "$OUTPUT" == *"ERROR"* ]]; then
    echo "MySQL container is not available yet. Should not be long..."
    sleep 2
  else
    echo "MySQL is up! Moving on..."
  fi
done

OUTPUT=$(echo 'select * from users limit 1'|{ mysql --user=root --password=drupal --database=drupal --host=mysql 2>&1 || true; })
if [[ "$OUTPUT" == *"ERROR"* ]]; then
  echo "Installing Drupal because we did not find an entry in the users table."
  drush sqlc < /scripts/initial.sql
  echo "ALTER TABLE node AUTO_INCREMENT = 500000;" | drush sqlc
  echo "ALTER TABLE node_revision AUTO_INCREMENT = 500000;" | drush sqlc
  echo "ALTER TABLE taxonomy_term_data AUTO_INCREMENT = 500000;" | drush sqlc
  echo "ALTER TABLE file_managed AUTO_INCREMENT = 500000;" | drush sqlc
  # Users are a bit different. See
  # https://www.drupal.org/project/drupal/issues/1209466
  drush ev "tdj()->migrate()->updateUserAutoIncrement()"
else
  echo "Assuming Drupal is already running, because there is a users table with at least one entry."
fi
echo "Run the update script whether or not this is an initial deployment."
mkdir -p /var/www/html/sites/default/files
chown -R www-data:www-data /var/www/html/sites/default/files

service rsyslog start
