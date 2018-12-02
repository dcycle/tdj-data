Starterkit for a complete Drupal 8 site
=====

[![CircleCI](https://circleci.com/gh/dcycle/starterkit-drupal8site.svg?style=svg)](https://circleci.com/gh/dcycle/starterkit-drupal8site)

Quickstart
-----

Step 1: Install [Docker](https://www.docker.com/get-docker) (nothing else required)

Step 2:

    cd ~/Desktop && git clone https://github.com/dcycle/starterkit-drupal8site.git
    cd ~/Desktop/starterkit-drupal8site && ./scripts/deploy.sh

Step 3: Click on the login link at the end of the command line output and enjoy a fully installed Drupal 8 environment.

HTTPS quickstart
-----

    cd ~/Desktop/starterkit-drupal8site && ./scripts/https-deploy.sh

See the article [Local development using Docker and HTTPS, Dcycle Blog, Oct. 27, 2018](https://blog.dcycle.com/blog/2018-10-27) for details on how this works.

About
-----

A starterkit to build a Drupal 8 project.

### Features

* **Docker-based**: only Docker is required to build a development environment.
* **One-click install**: a full installation should be available simply by running `./scripts/deploy.sh`.
* **Dependencies and generated files are not included in the repo**: modules, libraries, etc. should not be included in the repo. If you need to generate a directory with all dependencies and generated files, run `./scripts/create-build.sh`.
* **Sass is not used**: to keep the workflow simple, this project does not use SASS; we encourage direct modification of CSS. See the section "No SASS", below.

### Where to find the code

* The [code lives on GitHub](https://github.com/dcycle/starterkit-drupal8site).
* The [issue queue is on GitHub](https://github.com/dcycle/starterkit-drupal8site/issues).
* If you fork of copy this directory for your own project, enter other environments here (production, stage, secondary git origins).

Initial installation on Docker
-----

To install or update the code, install Docker and run `./scripts/deploy.sh`, which will give you a login link to a local development site.

Incremental deployment (updating) on Docker
-----

Updating your local installation is the same command as the installation command:

    ./scripts/deploy.sh

This will bring in new features and keep your existing data.

Power up/power down the Docker environment
-----

To shut down your containers but _keep your data for next time_:

    docker-compose down

To power up your containers:

    docker-compose up -d

Uninstalling the Docker environment
-----

To shut down your containers and _destroy your data_:

    docker-compose down -v
    docker network rm tdj_d8
    rm .env

If your project is the only project using the local https via the [Nginx Proxy], you might want to destroy the nginx-proxy container

    docker kill nginx-proxy
    docker rm nginx-proxy

You might also want to remove, from /etc/hosts, the line which contains your local development domain (use `sudo vi /etc/hosts` to edit that file); and also remove the certificate for your domain from `~/.docker-compose-certs`.

Prscribed development process
-----

The development cycle is as follows:

* Download the latest code and run `./scripts/deploy.sh`.
* Perform your local development on a branch `my-feature`.
* Export your config changes to code using `./scripts/export-config.sh`.
* Merge the latest version of master and run `./scripts/deploy.sh`.
* Push to Github and open a pull request.
* Self-review or have a colleague review code in the pull request.
* Make sure automated tests and linting is passing using `./scripts/test.sh`
* Use Github's GUI to **Squash and merge** your branch for clean git history.
* Use Github's GUI to delete your branch.
* Delete your branch locally and switch back to master.
* Pull the latest version of master.

Developers should also read this entire ./README.md file and add to it any information which may be useful for other developers.

Patches
-----

If you need to apply a patch, make sure it is published on Drupal.org in an issue, and apply it in the Dockerfiles. See ./Dockerfile for an example.

Development design patterns
-----

If you are looking at the code for the first time, here are a few design patterns and approaches which explain some of the choices which were made during the development process:

### Do not commit code which can be dowloaded or generated

We are not committing code such as downloaded modules, keeping the codebase rather small.

### No SASS

We do not use SASS in this project to avoid complexity. If you want to implement SASS support, consider the following questions:

* Generated CSS should be created in the build phase by `./scripts/create-build.sh`. Because we only allow Docker as a dependency of this project, you might consider a technique such as the one outlined in ["Compass Sass to CSS using Docker", Feb. 9, 2016, Dcycle blog](http://blog.dcycle.com/blog/107/compass-sass-css-using-docker/).
* You should not commit generated CSS to this git repo. You might need to `.gitignore` certain files, or make sure they reside on the container, but not your local computer.
* Do you need a real-time compiler directly embedded in your container?

### Docker-based one-click development setup

./scripts/deploy.sh is designed to use Docker to set up everything you need to have a complete environment.

### Common code as traits

We make use of traits to allow classes to implement common code and the Singleton design pattern (see ./drupal/custom-modules/my_custom_module/src/App.php and ./drupal/custom-modules/my_custom_module/my_cystom_module.module for usage).

Running automated tests
-----

Developers are encouraged to run `./scripts/test.sh` on their machine. If you have Docker installed, this will work without any further configuration.

This lints code (that is, it checks code for stylistic errors) and runs automated unit PHPUnit tests. If you get linting errors you feel do not apply, see a workaround in the "Linting" section, below.

We are not using Drupal's automated testing framework, rather:

* PHPUnit is used to test the code;
* Any Drupal-specific code is wrapped in methods `./drupal/custom-modules/my_custom_module/src/traits/Environment.php`, then mocked in the unit tests. See `./drupal/custom-modules/my_custom_module/test/AppTest.php` for an example.
* Running tests is done using `./scripts/test.sh` (which includes linting) or `./scripts/unit.sh` (which does not include linting), requiring only Docker and no additional setup.

Security and maintenance updates
-----

Because our git repo does not contain actual Drupal or module code, it downloads these each time ./scripts/deploy.sh is run, so simply running ./scripts/deploy.sh will update everything to the latest version.

Theming
-----

We are using the [CDN Drupal Bootstrap subtheme](https://drupal-bootstrap.org/api/bootstrap/starterkits%21cdn%21README.md/group/sub_theming_cdn/8).

Acquia
-----

This project provides some integration with Acquia Cloud.

### Prerequisites on the Acquia server

* We need to install the same version of PHP as can be found on the containers by typing `docker-compose exec drupal /bin/bash -c 'php -v'`.
* Make sure you are periodically calling "drush cron" from the command line using [this technique](https://docs.acquia.com/acquia-cloud/manage/cron) on your Acquia site.

### Notes about cron on Acquia

Acquia suggests [this technique](https://docs.acquia.com/acquia-cloud/manage/cron) for setting up cron.

    drush @MY-ACQUIA-ACCOUNT -dv -l http://my-site-on-acquia.example.com cron &>> /var/log/sites/${AH_SITE_NAME}/logs/$(hostname -s)/drush-cron.log

### Do not modify the Acquia git code directly, "build" it instead

Run ./scripts/create-build.sh

Login links for Acquia environments
-----

    ./scripts/acquia/uli.sh

Linting
-----

We use a [PHP linter](https://github.com/dcycle/docker-php-lint) and other linters in ./scripts/lint.sh. If your code is not commented correctly or structured correctly, Circle CI continuous integration will fail. See the linter documentation on how to ignore certain blocks of code, for example `t()` is ignored in ./drupal-server/custom-modules/my_custom_module/src/traits/Utilities.php.

    // @codingStandardsIgnoreStart
    ...
    // @codingStandardsIgnoreEnd

Getting a local version of the database
-----

If you have a .sql file with the database database, you can run:

docker-compose exec drupal /bin/bash -c 'drush sqlc' < /path/to/db.sql

You can set up the Stage File Proxy module to fetch files from the live server instead of importing the files.

Logging
-----

We are [using syslog instead of dblog](https://www.drupal.org/docs/8/core/modules/syslog/overview) for speed and ease of use. This means you will not have access to log messages through the administrative interface.

To access logs you can then use

    tail \
      -f ./do-not-commit/log/drupal.log \

Or the Mac OS X Console application.

Troubleshooting
-----

### First steps if anything goes wrong

Make sure you completely delete your environment using:

    docker-compose down -v

Make sure you have the latest stable version of your OS and of Docker.
If you're really in a bind, you can do a factory reset of Docker (which will kill your local data).
Make sure Docker has 6Gb of RAM. (On Mac OS, for example, this can be done using Docker > Preferences > Advanced, then restarting Docker).

Rerun `./scripts/deploy.sh`, and reimport the stage database if you need it (see "Getting a local version of the database", above).

### docker-compose down -v results in a network error

If you run `docker network rm tdj_d8` and you get "ERROR: network tdj_d8 id ... has active endpoints", you might need to disconnect the Drupal 7 site from the Drupal 8 network first. This should be done in the migration process, but it might not have worked. If such is the case, type:

    docker network disconnect tdj_d8 $(docker-compose ps -q database)

### Beware case-sensitivity

Docker is meant to mimic the Acquia environment relatively well, but there can be certain differences, for instance:

* if you `use path/to/class` instead of `path/To/Class`, it will work in Docker (local) and in automated tests, but fail on Acquia.

### docker-compose build --no-cache

Docker will, by default, used cached versions of each step of the build process for images. For example:

    FROM ubuntu
    RUN apt-get install something

If you _know_ "something" has changed, you might want to run:

    docker-compose build --no-cache
    ./scripts/deploy.sh

### Can't see the syslogs (see the "Logging" section, above)

Run `./scripts/deploy.sh`, which will restart rsyslog.


docker network connect tdj_d8 --alias=oldmysql b801ad764181697c2ec2ceacdbdd13cca175b35463f7adbc2f682f51d60d6f64
mysql --user=root --password=drupal --database=drupal --host=oldmysql --port=3306
drush migrate-upgrade --legacy-db-url='mysql://root:drupal@oldmysql/drupal' --legacy-root=http://terredesjeunes.org --configure-only
drush migrate-status

drush

drush migrate-import upgrade_d6_file --limit=5
upgrade_d6_user
upgrade_d6_node_antenne
upgrade_d6_node_faq
upgrade_d6_node_page
upgrade_d6_node_procesverbal
upgrade_d6_node_story
upgrade_d6_node_tdj_ressource
upgrade_d6_url_alias

drush mmsg upgrade_d6_file
