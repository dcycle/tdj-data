<?php

namespace Drupal\my_custom_module\traits;

use Drupal\my_custom_module\App;
use Drupal\my_custom_module\Migrate;

/**
 * Dependency injection trait.
 */
trait DependencyInjection {

  /**
   * Get the App singleton.
   *
   * @return App
   *   The App singleton.
   */
  public function app() : App {
    return App::instance();
  }

  /**
   * Get the Migrate singleton.
   *
   * @return Migrate
   *   The Migrate singleton.
   */
  public function app() : Migrate {
    return Migrate::instance();
  }

}
