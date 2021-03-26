#
# Be sure to run `pod lib lint DBC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name               = 'DBCTesting'
	s.version            = '1.4.0'
	s.summary            = 'A short description of DBC.'
	s.homepage           = 'https://github.com/busybusy/DBC-Apple'
	s.license		       = 'Copyright 2016 Busy, LLC. All rights reserved.'
	s.author             = { 'Jim Boyd' => 'jim@busybusy.com' }
	s.source             = { :git => 'git@github.com:busybusy/DBC-Apple.git', :tag => s.version.to_s }

	s.requires_arc = true
	s.ios.deployment_target = '9.0'
	s.osx.deployment_target = '10.10'
	s.tvos.deployment_target = '9.2'
	s.swift_version = '5.0'

	s.ios.frameworks = 'Foundation'
	s.frameworks = 'XCTest'
	s.dependency 'DBC/Swift', '~> 1.2'
	s.source_files = 'DBC-testing/*.{h,m,swift}'
end
