source 'https://github.com/CocoaPods/Specs.git'

FRAMEWORK_NAME = 'AUTTheming'
PODSPEC_PATH = './'
# Target Names
TESTS_TARGET_NAME = 'Tests'
THEMING_SYMBOLS_GENERATOR_TARGET_NAME = 'AUTThemingSymbolsGenerator'
BUTTONS_EXAMPLE_TARGET_NAME = 'ButtonsExample'
DYNAMIC_THEMES_EXAMPLE_TARGET_NAME = 'DynamicThemesExample'
SWIFT_BUTTONS_EXAMPLE_TARGET_NAME = 'SwiftButtonsExample'
# Paths
EXAMPLES_FOLDER = 'Examples'
TESTS_PATH = "#{TESTS_TARGET_NAME}/#{TESTS_TARGET_NAME}"
BUTTONS_EXAMPLE_PATH = "#{EXAMPLES_FOLDER}/#{BUTTONS_EXAMPLE_TARGET_NAME}"
DYNAMIC_THEMES_EXAMPLE_PATH = "#{EXAMPLES_FOLDER}/#{DYNAMIC_THEMES_EXAMPLE_TARGET_NAME}"
SWIFT_BUTTONS_EXAMPLE_PATH = "#{EXAMPLES_FOLDER}/#{SWIFT_BUTTONS_EXAMPLE_TARGET_NAME}"
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

xcodeproj SWIFT_BUTTONS_EXAMPLE_PATH
target SWIFT_BUTTONS_EXAMPLE_TARGET_NAME do
  use_frameworks!
  platform :ios, '8.0'
  xcodeproj SWIFT_BUTTONS_EXAMPLE_PATH
  pod 'Cartography', :git => 'https://github.com/robb/Cartography.git', :branch => 'xcode6-3'
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
end

xcodeproj THEMING_SYMBOLS_GENERATOR_PATH
target THEMING_SYMBOLS_GENERATOR_TARGET_NAME do
  platform :osx, '10.8'
  xcodeproj THEMING_SYMBOLS_GENERATOR_PATH
  pod FRAMEWORK_NAME, :path => PODSPEC_PATH
  pod 'GBCli'
end

# Add AUTTHEMING_DISABLE_SYMBOL_RESOLUTION define to preprocessor macros in theming symbols generator project
post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      
      # Add macro to pods preprocessor definitions for theming symbols generator project
      if target.to_s == "Pods-#{THEMING_SYMBOLS_GENERATOR_TARGET_NAME}-#{FRAMEWORK_NAME}"
        # Preprocessor Definitions
        preprocessor_definitions = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
        preprocessor_definitions = [ '$(inherited)' ] if preprocessor_definitions == nil
        preprocessor_definitions.push('AUTTHEMING_DISABLE_SYMBOL_RESOLUTION') if target.to_s.include?(THEMING_SYMBOLS_GENERATOR_TARGET_NAME)
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = preprocessor_definitions
      end
      
      # Enable coverage reports for tests target
      if target.to_s == "Pods-#{TESTS_TARGET_NAME}-#{FRAMEWORK_NAME}"
        config.build_settings['GCC_GENERATE_TEST_COVERAGE_FILES'] = 'YES'
        config.build_settings['GCC_INSTRUMENT_PROGRAM_FLOW_ARCS'] = 'YES'
      end
      
    end
  end
end
