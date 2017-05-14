# Podfile
use_frameworks!

abstract_target 'Katanga-app' do

    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
    pod 'Marshal',	  '~> 1.0'
    pod 'NSObject+Rx', '~> 2.0'
	pod 'RealmSwift'

    target 'Katanga'

	target 'KatangaTests' do
	    pod 'RxBlocking', '~> 3.0'
	    pod 'RxTest',    '~> 3.0'
	end

    post_install do |installer|
        %x( cp hooks/pre-push .git/hooks/)
        %x( chmod +x .git/hooks/pre-push )
    end
end

