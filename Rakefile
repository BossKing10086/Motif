task :bootstrap do
  sh("git submodule update --init --recursive")
end

task :run_tests_ios => [:bootstrap, :clean] do
  sh("#{BUILD_TOOL} #{BUILD_FLAGS_TEST_IOS} | #{PRETTIFY}")
end

task :run_tests_osx => [:bootstrap, :clean] do
  sh("#{BUILD_TOOL} #{BUILD_FLAGS_TEST_OSX} | #{PRETTIFY}")
end

task :run_tests => [:run_tests_ios, :run_tests_osx]

task :build_buttons_example => [:bootstrap, :clean] do
  sh("#{BUILD_TOOL} #{BUILD_FLAGS_BUTTONS_EXAMPLE} | #{PRETTIFY}")
end

task :build_dynamic_themes_example => [:bootstrap, :clean] do
  sh("#{BUILD_TOOL} #{BUILD_FLAGS_DYNAMIC_THEMES_EXAMPLE} | #{PRETTIFY}")
end

task :build_screen_brightness_example => [:bootstrap, :clean] do
  sh("#{BUILD_TOOL} #{BUILD_FLAGS_SCREEN_BRIGHTNESS_EXAMPLE} | #{PRETTIFY}")
end

task :build_examples => [
  :build_dynamic_themes_example,
  :build_screen_brightness_example,
  :build_buttons_example
]

task :lint_podspec do
  sh("#{LINT_TOOL} #{LINT_FLAGS}")
end

task :clean do
  sh("rm -rf '#{DERIVED_DATA_PATH}'")
end

private

LIBRARY_NAME = 'Motif'
WORKSPACE_PATH = "#{LIBRARY_NAME}.xcworkspace"
PODSPEC_PATH = "#{LIBRARY_NAME}.podspec"
SCHEME_BUTTONS_EXAMPLE = 'ButtonsExample'
SCHEME_DYNAMIC_THEMING_EXAMPLE = 'Dynamic Theming Example'
SCHEME_SCREEN_BRIGHTNESS_THEMING_EXAMPLE = 'Screen Brightness Theming Example'
DESTINATION = 'platform=iOS Simulator,name=iPhone 4s,OS=latest'
DERIVED_DATA_PATH = "/tmp/#{LIBRARY_NAME}"

LINT_TOOL = 'bundle exec pod lib lint'
BUILD_TOOL = 'xcodebuild'

LINT_FLAGS = "#{PODSPEC_PATH}"

BUILD_FLAGS =
  "-workspace '#{WORKSPACE_PATH}' "\
  "-derivedDataPath '#{DERIVED_DATA_PATH}'"
  
BUILD_FLAGS_IOS = BUILD_FLAGS + " -destination '#{DESTINATION}'"

BUILD_FLAGS_TEST_IOS = "test -scheme '#{LIBRARY_NAME}-iOS' " + BUILD_FLAGS_IOS
BUILD_FLAGS_TEST_OSX = "test -scheme '#{LIBRARY_NAME}-OSX' " + BUILD_FLAGS

BUILD_FLAGS_DYNAMIC_THEMES_EXAMPLE = "build -scheme '#{SCHEME_DYNAMIC_THEMING_EXAMPLE}' " + BUILD_FLAGS_IOS
BUILD_FLAGS_SCREEN_BRIGHTNESS_EXAMPLE = "build -scheme '#{SCHEME_SCREEN_BRIGHTNESS_THEMING_EXAMPLE}' " + BUILD_FLAGS_IOS
BUILD_FLAGS_BUTTONS_EXAMPLE = "build -scheme '#{SCHEME_BUTTONS_EXAMPLE}' " + BUILD_FLAGS_IOS

PRETTIFY = "xcpretty --color; exit ${PIPESTATUS[0]}"
