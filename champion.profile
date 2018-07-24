<?php
/**
 * Implements hook_form_alter().
 */
if (!function_exists('system_form_install_select_profile_form_alter')) {
  function system_form_install_select_profile_form_alter(&$form, $form_state) {
    foreach($form['profile'] as $key => $element) {
      $form['profile'][$key]['#value'] = 'champion';
    }
  }
}
/**
 * @file
 * Enables modules and site configuration for a champion site installation.
 */

/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 *
 * Allows the profile to alter the site configuration form.
 */
function champion_form_install_configure_form_alter(&$form, $form_state) {
  // Pre-populate the site name with the server name.
  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];

  $form['#submit'][] = 'champion_form_install_configure_submit';
}

/**
 * Extra submit handler install_configure_form().
 */
function champion_form_install_configure_submit($form, &$form_state) {
  // Update the home page hero block to use the site name.
  $layout = layout_load('home');
  foreach ($layout->content as &$block) {
    if ($block->delta === 'hero') {
      $block->settings['title'] = st('Welcome to !sitename!', array('!sitename' => $form_state['values']['site_name']));
      break;
    }
  }
  $layout->save();
}