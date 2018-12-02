<?php

namespace Drupal\my_custom_module;

use Drupal\my_custom_module\traits\Singleton;
use Drupal\my_custom_module\traits\Environment;

/**
 * Module-wide functionality.
 */
class Migrate {

  use Singleton;
  use Environment;

  /**
   * Ensure the next user has high ID, allowing us to enter users in 2 systems.
   *
   * During gradual launch, users entered in D7 will be <25000, and users
   * entered in D8 will be >25000.
   */
  public function updateUserAutoIncrement() {
    // See https://www.drupal.org/project/drupal/issues/1209466.
    if (user_load(25000)) {
      // This user already exists.
      return;
    }
    $values = [
      'field_first_name' => 'Placeholder dummy user',
      'fieldt_last_name' => 'Placeholder dummy user',
      'name' => 'dummy-user-bump-to-25000',
      'mail' => 'dummy-user@example.com',
      'roles' => array(),
      'pass' => rand() . rand() . rand() . rand() . rand() . rand(),
      'status' => 0,
      'uid' => 25000,
    ];
    $account = entity_create('user', $values);
    $account->save();
  }

}
