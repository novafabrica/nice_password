$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'nice_password'))

require 'core_ext'
require 'nice_password'
require 'errors'

$LOAD_PATH.shift

NicePassword.load_default_dictionaries
