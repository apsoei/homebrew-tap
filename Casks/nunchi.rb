cask "nunchi" do
  version "0.3.5"
  sha256 "73322ec765ea77061d93bae67cd326fd46339a29d7d09fd1d08783e1ee218b32"

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

  # 입력 소스 목록에서 빼는(--unregister) 단계는 두지 않는다. brew 는 업데이트 때도 삭제 단계를 거치는데,
  # 업데이트 중에 끄고 다시 켜면 입력 메뉴에서 눈치가 사라졌다(설정에는 남아 있음). 떠 있는 프로세스만 내린다.
  uninstall signal: [["TERM", "io.github.apsoei.inputmethod.Nunchi"]]

  zap trash: "~/Library/Application Support/Nunchi"

  caveats <<~EOS
    처음 설치했다면 메뉴 막대의 입력 메뉴에서 '눈치'를 고르세요.
    목록에 없으면 로그아웃했다가 다시 로그인하세요.

    업데이트(brew upgrade --cask nunchi) 전에는 입력 소스를 ABC 등으로 바꿔 두고,
    끝나면 다시 '눈치'를 고르세요.

    업데이트 뒤 입력 메뉴에서 눈치가 안 보이면: 시스템 설정 › 키보드 › 입력 소스 › 편집… 에서
    눈치를 - 로 뺐다가 + 로 다시 추가하세요(로그아웃해도 됩니다).
    삭제(uninstall) 뒤 입력 메뉴에 눈치가 남아 있으면 같은 곳에서 - 로 빼세요.

    단어장: ~/Library/Application Support/Nunchi/words.txt
    (brew uninstall --cask --zap nunchi 로 지우면 단어장도 함께 지워집니다)
  EOS
end
