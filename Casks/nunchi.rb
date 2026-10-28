cask "nunchi" do
  version "0.3.2"
  sha256 "88482f4fb4f3af3d3f5b00d2bf34bca7ee0a2967b147e35cd59fbab3a0257e12"

  url "https://github.com/apsoei/nunchi/releases/download/v#{version}/Nunchi-#{version}.zip"
  name "Nunchi"
  name "눈치"
  desc "Korean/English auto-switching input method"
  homepage "https://github.com/apsoei/nunchi"

  depends_on macos: :sonoma

  input_method "Nunchi.app"

  # 서명 없는 앱이라 macOS 가 막지 않도록 "인터넷에서 받은 파일" 표시를 지운 뒤 입력 소스로 등록한다.
  postflight do
    app = "#{Dir.home}/Library/Input Methods/Nunchi.app"
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", app]
    system_command "#{app}/Contents/MacOS/Nunchi", args: ["--register"]
  end

  # 지우기 전에 입력 소스 목록에서 빼고, 떠 있는 입력기 프로세스를 내린다.
  uninstall_preflight do
    binary = "#{Dir.home}/Library/Input Methods/Nunchi.app/Contents/MacOS/Nunchi"
    system_command binary, args: ["--unregister"], must_succeed: false if File.exist?(binary)
  end

  uninstall signal: [["TERM", "io.github.apsoei.inputmethod.Nunchi"]]

  zap trash: "~/Library/Application Support/Nunchi"

  caveats <<~EOS
    처음 설치했다면 메뉴 막대의 입력 메뉴에서 '눈치'를 고르세요.
    목록에 없으면 로그아웃했다가 다시 로그인하세요.

    업데이트(brew upgrade --cask nunchi) 전에는 입력 소스를 ABC 등으로 바꿔 두고,
    끝나면 다시 '눈치'를 고르세요.

    단어장: ~/Library/Application Support/Nunchi/words.txt
    (brew uninstall --cask --zap nunchi 로 지우면 단어장도 함께 지워집니다)
  EOS
end
