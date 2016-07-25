#
# Be sure to run `pod lib lint DBC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name               = 'DBC'
	s.version            = '0.1.0'
	s.summary            = 'A short description of DBC.'
	s.homepage           = 'https://github.com/busybusy/DBC-Apple'
	s.license		       = 'Copyright 2016 Busy, LLC. All rights reserved.'
	s.author             = { 'Jim Boyd' => 'jim@busybusy.com' }
	s.source             = { :git => 'https://github.com/<GITHUB_USERNAME>/DBC.git', :tag => s.version.to_s }

	s.requires_arc = true
	s.ios.deployment_target = '8.0'
	s.watchos.deployment_target = '2.0'
	s.osx.deployment_target = '10.10'
	s.tvos.deployment_target = '9.2'
	s.default_subspec = 'Bridged'

	s.subspec 'Bridged' do |ss|
		ss.ios.frameworks = 'Foundation'
		ss.requires_arc = true
		ss.source_files = 'DBC-swift/DBCIntensityBridged.swift'
		ss.dependency 'DBC/Swift'
		ss.dependency 'DBC/Objc'
	end

	s.subspec 'Swift' do |ss|
		ss.ios.frameworks = 'Foundation'
		ss.requires_arc = true
		ss.source_files = 'DBC-swift/*.swift'
		ss.exclude_files = "DBC-swift/DBCIntensityBridged.swift"
	end

	s.subspec 'Objc' do |ss|
		ss.ios.frameworks = 'Foundation'
		ss.requires_arc = true
		ss.source_files = 'DBC-objc/*.{h,m}'
	end
end
