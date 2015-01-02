source 'https://github.com/CocoaPods/Specs.git'

FRAMEWORK_NAME = 'AUTTheming'
PODSPEC_PATH = './'
# Target Names
TESTS_TARGET_NAME = 'Tests'
THEMING_SYMBOLS_GENERATOR_TARGET_NAME = 'AUTThemingSymbolsGenerator'
BUTTONS_EXAMPLE_TARGET_NAME = 'ButtonsExample'
DYNAMIC_THEMES_EXAMPLE_TARGET_NAME = 'DynamicThemesExample'
# Paths
EXAMPLES_FOLDER = 'Examples'
TESTS_PATH = "#{TESTS_TARGET_NAME}/#{TESTS_TARGET_NAME}"
BUTTONS_EXAMPLE_PATH = "#{EXAMPLES_FOLDER}/#{BUTTONS_EXAMPLE_TARGET_NAME}/#{BUTTONS_EXAMPLE_TARGET_NAME}"
DYNAMIC_THEMES_EXAMPLE_PATH = "#{EXAMPLES_FOLDER}/#{DYNAMIC_THEMES_EXAMPLE_TARGET_NAME}/#{DYNAMIC_THEMES_EXAMPLE_TARGET_NAME}"
THEMING_SYMBOLS_GENERATOR_PATH = "#{THEMING_SYMBOLS_GENERATOR_TARGET_NAME}/#{THEMING_SYMBOLS_GENERATOR_TARGET_NAME}"

workspace FRAMEWORK_NAME

xcodeproj TESTS_PATH
target TESTS_TARGET_NAME do
  platform :ios, '7.0'
  xcodeproj TESTS_PATH
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
end

xcodeproj BUTTONS_EXAMPLE_PATH
target BUTTONS_EXAMPLE_TARGET_NAME do
  platform :ios, '7.0'
  xcodeproj BUTTONS_EXAMPLE_PATH
  pod 'Masonry'
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
end

xcodeproj DYNAMIC_THEMES_EXAMPLE_PATH
target DYNAMIC_THEMES_EXAMPLE_TARGET_NAME do
  platform :ios, '7.0'
  xcodeproj DYNAMIC_THEMES_EXAMPLE_PATH
  pod 'Masonry'
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
end

xcodeproj THEMING_SYMBOLS_GENERATOR_PATH
target THEMING_SYMBOLS_GENERATOR_TARGET_NAME do
  platform :osx, '10.8'
  xcodeproj THEMING_SYMBOLS_GENERATOR_PATH
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
  pod 'GBCli'
end