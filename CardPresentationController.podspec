
Pod::Spec.new do |s|
    s.name = 'CardPresentationController'
    s.version = '1.2'
    s.summary = 'Custom UIPresentationController which mimics the behavior of Apple Music UI'
    s.description = 'Custom UIPresentationController which mimics the behavior of Apple Music UI'
    s.homepage = 'htts://github.com/radianttap/CardPresentationController'
    s.license = {:type => "MIT",:file => "LICENSE"}
    s.author = {'Aleksandar Vacić =>'radianttap.com'}
    s.ios.deployment_target = "9.0"
    s.tvos.deployment_target = "9.0"
    s.source = {:git => "https://github.com/radianttap/CardPresentationController.git"}
    s.source_files = 'CardPresentationController/*.swift'
    s.frameworks = 'UIKit'
    s.swift_version = '4.2'
end

