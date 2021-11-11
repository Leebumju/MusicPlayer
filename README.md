## MusicPlayer
-----------------
### 프로젝트 소개

네이버 부스트코스 - iOS 앱 프로그래밍 과정 중 진행한 Music Player.
`AVFoundation` 프레임워크의 `AVAudioPlayer`라는 클래스를 통해 음원을 재생하는 애플리케이션을 제작

-----------------
### 화면구성

재생 버튼, 타임 레이블, 슬라이더가 화면 X축 중앙에 위치합니다.
각각의 요소는 서로의 영역을 침범하거나 겹치지 않으며 화면 밖으로 나가지 않도록 합니다.
타임 레이블과 슬라이더는 0에서 시작합니다.

--------------------
### 기능

재생 버튼을 누르면 음악을 재생하고, 일시정지 버튼으로 바뀌며 재생위치에 따라 슬라이더가 움직입니다.<br>
일시정지 버튼을 누르면 음악을 멈추고, 재생 버튼으로 바뀌며 슬라이더 움직임이 정지합니다.<br>
음악이 재생됨에 따라 타임 레이블이 밀리세컨드 단위(0.01초)로 변경됩니다.<br>
음악이 재생됨에 따라 타임 레이블과 슬라이더의 값이 밀리세컨드 단위(0.01초)로 변경됩니다.<br>
슬라이더의 위치를 변경해 현재 재생위치를 조절할 수 있습니다.<br>
음악을 모두 재생하면 버튼, 레이블, 슬라이더가 맨 처음 상태로 되돌아갑니다.<br>
