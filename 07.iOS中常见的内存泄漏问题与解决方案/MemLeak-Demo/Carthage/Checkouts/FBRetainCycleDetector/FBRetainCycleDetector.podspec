#
#  Be sure to run `pod spec lint FBRetainCycleDetector.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "FBRetainCycleDetector"
  s.version      = "0.1"
  s.summary      = "It can detect all retain cycles in the app"
  s.homepage     = "https://github.com/facebook/FBRetainCycleDetector"
  s.license      = "BSD"
  s.author       = { "Grzegorz Pstrucha" => "gricha@fb.com" }
  s.platform     = :ios, "8.0"
  s.source       = {
    :git => "git@github.com:facebook/FBRetainCycleDetector.git",
    :tag => "0.1"
  }
  s.source_files  = "FBRetainCycleDetector", "{FBRetainCycleDetector,fishhook}/**/*.{h,m,mm,c}"

  mrr_files = [
    'FBRetainCycleDetector/Associations/FBAssociationManager.h',
    'FBRetainCycleDetector/Associations/FBAssociationManager.mm',
    'FBRetainCycleDetector/Layout/Blocks/FBBlockStrongLayout.h',
    'FBRetainCycleDetector/Layout/Blocks/FBBlockStrongLayout.m',
    'FBRetainCycleDetector/Layout/Blocks/FBBlockStrongRelationDetector.h',
    'FBRetainCycleDetector/Layout/Blocks/FBBlockStrongRelationDetector.m',
    'FBRetainCycleDetector/Layout/Classes/FBClassStrongLayoutHelpers.h',
    'FBRetainCycleDetector/Layout/Classes/FBClassStrongLayoutHelpers.m',
  ]

  files = Pathname.glob("FBRetainCycleDetector/**/*.{h,m,mm}")
  files = files.map {|file| file.to_path}
  files = files.reject {|file| mrr_files.include?(file)}

  s.requires_arc = files + [
    'fishhook/**/*.{c,h}'
  ]

  s.framework = "Foundation", "CoreGraphics", "UIKit"
  s.library = 'c++'
end
