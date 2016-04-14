

APP_ROOT = File.dirname(__FILE__)

$:.unshift(File.join(APP_ROOT, 'lib'))
require 'guide.rb';

guide = Guide.new('resturant.txt')
guide.launch!