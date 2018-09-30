#
# Be sure to run `pod lib lint NYSqliteTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NYSqliteTool'
  s.version          = '0.1.1'
  s.summary          = 'a manager base FMDB and CTMediator'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
a manager base FMDB and CTMediator
a manager base FMDB and CTMediator
                       DESC

  s.homepage         = 'https://github.com/qyning/NYSqliteTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qyning' => 'qyning@qq.com' }
  s.source           = { :git => 'https://github.com/qyning/NYSqliteTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'NYSqliteTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NYSqliteTool' => ['NYSqliteTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.static_framework = true
  s.requires_arc = true

  s.dependency 'FMDB'
  s.dependency 'CTMediator'
end
