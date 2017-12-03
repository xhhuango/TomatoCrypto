Pod::Spec.new do |s|
  s.name         = "TomatoCrypto"
  s.version      = "1.0.0"
  s.summary      = "A pure swift cryptographic framwork"
  s.description  = "A pure swift cryptograhic fromwork implementing AES, RSA, SHA1, RSA PSS Signature, and HMAC"
  s.homepage     = "https://gitlab.com/xhhuango/TomatoCrypto"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author       = { "Xuan Hau Huang" => "xhhuango@gmail.com" }
  # s.social_media_url   = "http://twitter.com/Xuan Hau Huang"
  s.ios.deployment_target      = "8.0"
  s.osx.deployment_target      = "10.9"
  s.watchos.deployment_target  = "2.0"
  s.tvos.deployment_target     = "9.0"
  s.source        = { :git => "https://gitlab.com/xhhuango/TomatoCrypto.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/**/*.swift"
  s.requires_arc  = true
  s.dependency "BigInt", "~> 3.0"
end
